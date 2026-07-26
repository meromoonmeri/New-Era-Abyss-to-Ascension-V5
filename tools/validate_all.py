#!/usr/bin/env python3
"""Validation complète des 5 salles de boss avant intégration."""
import json, os, struct, collections
import numpy as np

P = os.environ.get('MOD_ROOT', os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
G = os.path.join(P, 'Data/Ground')
T = os.path.join(P, 'Content/Tile')

ROOMS = {
    'vast_steppe_miniboss':     [(240 - 40, 400), (168, 400), (200, 360), (200, 300),
                                 (184, 232), (152, 200), (184, 160)],
    'vast_steppe_guardian':     [(200, 400), (168, 400), (200, 360), (200, 300),
                                 (184, 200), (184, 160)],
    'searing_tunnel_miniboss':  [(240, 440), (272, 440), (240, 380), (240, 320),
                                 (220, 232), (292, 208), (256, 200)],
    'mount_windswept_miniboss': [(240, 440), (208, 440), (240, 380), (240, 340),
                                 (180, 240), (268, 192), (224, 180)],
    'mount_windswept_guardian': [(240, 440), (208, 440), (240, 380), (240, 340),
                                 (224, 192), (224, 180)],
}

def reachable(mask, start):
    W, H = mask.shape
    seen = np.zeros_like(mask)
    if mask[start]:
        return seen
    st = [start]; seen[start] = True
    while st:
        x, y = st.pop()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < W and 0 <= ny < H and not seen[nx, ny] and not mask[nx, ny]:
                seen[nx, ny] = True; st.append((nx, ny))
    return seen

ok_all = True
for name, pts in ROOMS.items():
    p = os.path.join(G, name + '.rsground')
    if not os.path.exists(p):
        print('❌ %-26s FICHIER ABSENT' % name); ok_all = False; continue
    d = json.load(open(p, encoding='utf-8-sig'))['Object']
    ts = 8 * d.get('TexSize', 1)
    W = len(d['Layers'][0]['Tiles']); H = len(d['Layers'][0]['Tiles'][0])
    ob = d['obstacles']
    GW, GH = len(ob), len(ob[0])
    mask = np.array([[ob[x][y]['Tags'] != 0 for y in range(GH)] for x in range(GW)])

    problems = []
    # 1. grille obstacles cohérente avec la taille en pixels
    if GW != W * ts // 8 or GH != H * ts // 8:
        problems.append('grille obstacles %dx%d != attendu %dx%d'
                        % (GW, GH, W * ts // 8, H * ts // 8))
    # 2. tilesets présents
    sheets = set()
    for lay in d['Layers']:
        for col in lay['Tiles']:
            for t in col:
                for tl in t.get('Layers', []):
                    for f in tl.get('Frames', []):
                        if f.get('Sheet'):
                            sheets.add(f['Sheet'])
    miss = [s for s in sheets if not os.path.exists(os.path.join(T, s + '.tile'))]
    if miss:
        problems.append('tilesets manquants %s' % miss)
    # 3. tailles de tuile cohérentes avec TexSize
    for s in sheets:
        fp = os.path.join(T, s + '.tile')
        if os.path.exists(fp):
            tsz, _ = struct.unpack('<II', open(fp, 'rb').read(8))
            if tsz != ts:
                problems.append('%s ts=%d != carte %d' % (s, tsz, ts))
    # 4. entités
    ents = d['Entities'][0] if d.get('Entities') else {}
    sp = {s['NPCName'] for s in ents.get('Spawners', [])}
    mk = {m['EntName'] for m in ents.get('Markers', [])}
    if 'Teammate1' not in sp:
        problems.append('Teammate1 absent')
    if 'Main_Entrance_Marker' not in mk:
        problems.append('Main_Entrance_Marker absent')
    # 5. positions cinématique marchables
    blocked = []
    for (px, py) in pts:
        gx, gy = px // 8, py // 8
        if gx >= GW or gy >= GH:
            blocked.append('(%d,%d) hors carte' % (px, py))
        elif mask[gx, gy]:
            blocked.append('(%d,%d) bloqué' % (px, py))
    if blocked:
        problems.append('positions: %s' % blocked)
    # 6. connexité départ -> boss
    start = (pts[0][0] // 8, pts[0][1] // 8)
    goal = (pts[-2][0] // 8, pts[-2][1] // 8)
    seen = reachable(mask, start)
    if not seen[goal]:
        problems.append('boss NON atteignable depuis le départ')
    walk = int((~mask).sum())

    status = '✅' if not problems else '❌'
    if problems:
        ok_all = False
    print('%s %-26s %2dx%-2d ts=%2d  marchable %d/%d (%.0f%%)  %d calques'
          % (status, name, W, H, ts, walk, GW * GH, 100 * walk / (GW * GH),
             len(d['Layers'])))
    for pr in problems:
        print('      → %s' % pr)

print()
print('RÉSULTAT GLOBAL :', '✅ toutes les salles sont valides' if ok_all else '❌ corrections nécessaires')
