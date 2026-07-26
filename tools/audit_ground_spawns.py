#!/usr/bin/env python3
"""Audit spatial des grounds de relais et de boss pour New Era.

Vérifie que les entités/markers/spawners et les coordonnées scriptées simples
sont dans les bornes et sur des cellules marchables (Tags == 0).
"""
from __future__ import annotations
import json, os, re, sys
from pathlib import Path
from collections import defaultdict, deque

ROOT = Path(os.environ.get("MOD_ROOT", Path(__file__).resolve().parents[1]))
GDIR = ROOT / "Data" / "Ground"
SDIR = ROOT / "Data" / "Script" / "halcyon" / "ground"

DEFAULT_GROUNDS = sorted(
    p.stem for p in GDIR.glob("*.rsground")
    if re.search(r"(boss|guardian|miniboss|crucible|fulgur|relay|midpoint)", p.stem)
)

# Position scriptée : nom symbolique -> (x, y)
SCRIPT_TELEPORT_RE = re.compile(r"GROUND:TeleportTo\(\s*([^,]+?)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*Direction\.(\w+)", re.S)
SCRIPT_MOVETO_RE = re.compile(r"GROUND:MoveToPosition\(\s*([^,]+?)\s*,\s*(-?\d+)\s*,\s*(-?\d+)", re.S)
SCRIPT_MOVEIN_RE = re.compile(r"GROUND:MoveInDirection\(\s*([^,]+?)\s*,\s*Direction\.(\w+)\s*,\s*(-?\d+)", re.S)
SCRIPT_MAKECHAR_BLOCK_RE = re.compile(r"MakeCharactersFromList\s*\(\s*\{(.*?)\}\s*\)", re.S)
SCRIPT_MAKECHAR_ENTRY_RE = re.compile(r"\{\s*['\"]([^'\"]+)['\"]\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*Direction\.(\w+)", re.S)
SCRIPT_CAMERA_RE = re.compile(r"GAME:MoveCamera\(\s*(-?\d+)\s*,\s*(-?\d+)", re.S)

DIR_DELTA = {"Up": (0, -1), "Down": (0, 1), "Left": (-1, 0), "Right": (1, 0)}

def load_ground(name: str):
    with (GDIR / f"{name}.rsground").open(encoding="utf-8-sig") as f:
        data = json.load(f)
    obj = data["Object"]
    obs = obj.get("obstacles", [])
    gw, gh = len(obs), len(obs[0]) if obs else 0
    return data, obj, obs, gw, gh

def is_walkable(obs, x, y):
    return 0 <= x < len(obs) and 0 <= y < len(obs[0]) and obs[x][y].get("Tags", 0) == 0

def rect_cells(collider):
    x0 = int(collider.get("X", 0)) // 8
    y0 = int(collider.get("Y", 0)) // 8
    # Collider width/height are pixels; include all cells touched by the rect.
    x1 = (int(collider.get("X", 0)) + max(1, int(collider.get("Width", 1))) - 1) // 8
    y1 = (int(collider.get("Y", 0)) + max(1, int(collider.get("Height", 1))) - 1) // 8
    return [(x, y) for x in range(x0, x1 + 1) for y in range(y0, y1 + 1)]

def char_cells(px, py, w=16, h=16):
    """Cells touched by a 16x16 character collider placed at top-left px/py."""
    return rect_cells({"X": int(px), "Y": int(py), "Width": w, "Height": h})

def in_bounds_px(px, py, gw, gh):
    return 0 <= px < gw * 8 and 0 <= py < gh * 8

def check_cells(obs, cells):
    bad = []
    for x, y in cells:
        if not (0 <= x < len(obs) and 0 <= y < len(obs[0])):
            bad.append((x, y, "hors bornes"))
        elif obs[x][y].get("Tags", 0) != 0:
            bad.append((x, y, f"bloqué Tags={obs[x][y].get('Tags')}") )
    return bad

def reachable(obs, start):
    gw, gh = len(obs), len(obs[0])
    seen = set()
    if not is_walkable(obs, *start):
        return seen
    dq = deque([start]); seen.add(start)
    while dq:
        x, y = dq.popleft()
        for dx, dy in ((1,0),(-1,0),(0,1),(0,-1)):
            nx, ny = x+dx, y+dy
            if 0 <= nx < gw and 0 <= ny < gh and (nx,ny) not in seen and is_walkable(obs,nx,ny):
                seen.add((nx,ny)); dq.append((nx,ny))
    return seen

def scan_entities(name, obj, obs):
    issues = []
    infos = []
    ents = obj.get("Entities") or []
    for li, layer in enumerate(ents):
        for group in ("Markers", "Spawners", "MapChars"):
            for ent in layer.get(group, []) or []:
                entname = ent.get("EntName") or ent.get("NPCName") or ent.get("Name") or "?"
                col = ent.get("Collider") or {}
                loc = ent.get("serializationLoc")
                if loc and not col:
                    col = {"X": loc.get("X", 0), "Y": loc.get("Y", 0), "Width": 16, "Height": 16}
                # Certains GroundSpawner vides générés par les outils n'ont pas de position.
                if not col:
                    continue
                cells = rect_cells(col)
                bad = check_cells(obs, cells)
                infos.append((group, entname, col, not bad))
                if bad:
                    issues.append((f"{group}:{entname}", col, bad[:8]))
        # GroundObjects are not always expected to be walkable (rocks, signs),
        # but touch/trigger zones need to stay within map bounds.  Le repo contient
        # selon les générations soit Collider, soit Position.
        for ent in layer.get("GroundObjects", []) or []:
            entname = ent.get("EntName") or "?"
            col = ent.get("Collider") or ent.get("Position") or {}
            if not col:
                continue
            cells = rect_cells(col)
            oob = [(x, y, "hors bornes") for x, y in cells if not (0 <= x < len(obs) and 0 <= y < len(obs[0]))]
            infos.append(("GroundObjects", entname, col, not oob))
            if oob:
                issues.append((f"GroundObjects:{entname}", col, oob[:8]))
    return infos, issues

def scan_script(name, obs, gw, gh):
    d = SDIR / name
    if not d.exists():
        return [], []
    infos=[]; issues=[]
    state = {}  # raw char expr -> (x,y)
    files = sorted(d.glob("*.lua"))
    for fp in files:
        src = fp.read_text(encoding="utf-8", errors="replace")
        # very simple linear scan: list all coordinate-bearing calls in source order
        events=[]
        for m in SCRIPT_TELEPORT_RE.finditer(src):
            events.append((m.start(), "teleport", m))
        for m in SCRIPT_MOVETO_RE.finditer(src):
            events.append((m.start(), "moveto", m))
        for m in SCRIPT_MOVEIN_RE.finditer(src):
            events.append((m.start(), "movein", m))
        for m in SCRIPT_MAKECHAR_BLOCK_RE.finditer(src):
            for e in SCRIPT_MAKECHAR_ENTRY_RE.finditer(m.group(1)):
                # adjust order with offset within block
                events.append((m.start()+e.start(), "makechar", e))
        for m in SCRIPT_CAMERA_RE.finditer(src):
            events.append((m.start(), "camera", m))
        for _, typ, m in sorted(events, key=lambda x: x[0]):
            if typ in ("teleport", "moveto"):
                char = re.sub(r"\s+", "", m.group(1))
                px, py = int(m.group(2)), int(m.group(3))
                if typ == "moveto" and char in state:
                    sx, sy = state[char]
                    # Simulation statique du trajet MoveToPosition : ligne droite
                    # échantillonnée tous les 4 px avec un collider 16x16.
                    steps = max(1, max(abs(px - sx), abs(py - sy)) // 4)
                    cells = []
                    for i in range(steps + 1):
                        t = i / steps
                        qx = round(sx + (px - sx) * t)
                        qy = round(sy + (py - sy) * t)
                        cells.extend(char_cells(qx, qy))
                    cells = list(dict.fromkeys(cells))
                    label = f"{fp.name}:{typ}:{char}@{sx},{sy}->{px},{py}"
                else:
                    cells = char_cells(px, py)
                    label = f"{fp.name}:{typ}:{char}@{px},{py}"
                bad = check_cells(obs, cells)
                infos.append((label, px, py, not bad))
                if not in_bounds_px(px, py, gw, gh):
                    issues.append((label, {"X":px,"Y":py}, [(px//8,py//8,"hors bornes px")]))
                elif bad:
                    issues.append((label, {"X":px,"Y":py}, bad[:8]))
                state[char] = (px, py)
            elif typ == "movein":
                char = re.sub(r"\s+", "", m.group(1))
                direction, dist = m.group(2), int(m.group(3))
                start = state.get(char)
                if start and direction in DIR_DELTA:
                    dx, dy = DIR_DELTA[direction]
                    sx, sy = start
                    ex, ey = sx + dx*dist, sy + dy*dist
                    # sample every 8 px along the path, including endpoint
                    cells=[]
                    steps = max(1, abs(dist)//4)
                    for i in range(steps+1):
                        t=i/steps
                        px=round(sx + (ex-sx)*t); py=round(sy + (ey-sy)*t)
                        cells.extend(char_cells(px, py))
                    # de-dupe
                    cells = list(dict.fromkeys(cells))
                    bad = check_cells(obs, cells)
                    label = f"{fp.name}:movein:{char}:{direction}:{dist}@{sx},{sy}->{ex},{ey}"
                    infos.append((label, ex, ey, not bad))
                    if bad:
                        issues.append((label, {"X":sx,"Y":sy,"EndX":ex,"EndY":ey}, bad[:8]))
                    state[char]=(ex,ey)
            elif typ == "makechar":
                cname, px, py, direction = m.group(1), int(m.group(2)), int(m.group(3)), m.group(4)
                cells = char_cells(px, py)
                bad = check_cells(obs, cells)
                label = f"{fp.name}:makechar:{cname}@{px},{py}"
                infos.append((label, px, py, not bad))
                if not in_bounds_px(px, py, gw, gh):
                    issues.append((label, {"X":px,"Y":py}, [(px//8,py//8,"hors bornes px")]))
                elif bad:
                    issues.append((label, {"X":px,"Y":py}, bad[:8]))
            elif typ == "camera":
                px, py = int(m.group(1)), int(m.group(2))
                ok = in_bounds_px(px, py, gw, gh)
                label = f"{fp.name}:camera@{px},{py}"
                infos.append((label, px, py, ok))
                if not ok:
                    issues.append((label, {"X":px,"Y":py}, [(px//8,py//8,"camera hors bornes")]))
    return infos, issues

def main(argv=None):
    argv = argv or sys.argv[1:]
    grounds = argv or DEFAULT_GROUNDS
    any_bad=False
    print("# Audit spatial grounds boss/relais")
    for name in grounds:
        try:
            _, obj, obs, gw, gh = load_ground(name)
        except FileNotFoundError:
            print(f"❌ {name}: fichier absent")
            any_bad=True; continue
        _, e_issues = scan_entities(name, obj, obs)
        _, s_issues = scan_script(name, obs, gw, gh)
        walk = sum(1 for x in range(gw) for y in range(gh) if obs[x][y].get('Tags',0)==0)
        print(f"{'❌' if e_issues or s_issues else '✅'} {name:28s} dims={gw}x{gh} cells marchables={walk}/{gw*gh}")
        for label, col, bad in (e_issues + s_issues)[:20]:
            print(f"    - {label}: {col} -> {bad}")
        if e_issues or s_issues:
            any_bad=True
    return 1 if any_bad else 0

if __name__ == "__main__":
    raise SystemExit(main())
