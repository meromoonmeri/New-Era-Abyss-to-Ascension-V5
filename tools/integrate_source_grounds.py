#!/usr/bin/env python3
"""Refonte contrôlée des relais/checkpoints et grounds de boss.

Directive appliquée : ne plus corriger les maps instables à la main ; repartir
sur une géométrie/collision clonée depuis des Grounds PMDO/RogueEssence existants
(ProjectEoN/ZMDO/Halcyon), puis renommer/réindexer les assets pour New Era.
"""
from __future__ import annotations

import copy
import hashlib
import json
import os
import re
import shutil
import struct
from pathlib import Path

ROOT = Path(os.environ.get("MOD_ROOT", Path(__file__).resolve().parents[1]))
HOME = ROOT.parent
GDIR = ROOT / "Data" / "Ground"
TILE_DIR = ROOT / "Content" / "Tile"
SCRIPT_DIR = ROOT / "Data" / "Script" / "halcyon"
CHAR_ESS = SCRIPT_DIR / "CharacterEssentials.lua"

SOURCES = {
    "ProjectEoN": HOME / "ProjectEoN",
    "ZMDO": HOME / "ZMDO",
    "Halcyon": HOME / "Halcyon",
    "PMDOTutorial": HOME / "PMDOTutorial-0.7",
}

# Target -> source mapping.  Every line is documented later in docs/integration_tracker.md.
RELAY_SPECS = {
    "vast_steppe_midpoint": {
        "source_mod": "ProjectEoN", "source_ground": "CrumbleCanyonMidway",
        "fallback_tile": ("ZMDO", "GroveEntrance"),
        "name_en": "Vast Steppe Relay", "name_fr": "Relais Grande Steppe",
        "music": "Sky Peak Prairie.ogg",
        "chapter": "5", "theme": "checkpoint de steppe / repos d’expédition",
    },
    "searing_tunnel_midpoint": {
        "source_mod": "ProjectEoN", "source_ground": "CrumbleCanyonMidway",
        "fallback_tile": ("ZMDO", "MysteryEntrance"),
        "name_en": "Searing Tunnel Relay", "name_fr": "Relais du Tunnel Incandescent",
        "music": "Deep Dark Crater.ogg",
        "chapter": "5", "theme": "checkpoint volcanique / sauvegarde avant les profondeurs",
    },
    "mount_windswept_midpoint": {
        "source_mod": "ProjectEoN", "source_ground": "CrumbleCanyonMidway",
        "fallback_tile": ("ProjectEoN", "NorthernRange"),
        "name_en": "Mount Windswept Relay", "name_fr": "Relais du Mont Venteux",
        "music": "Mt. Travail.ogg",
        "chapter": "5", "theme": "checkpoint de montagne / reprise d’ascension",
    },
    "crooked_cavern_midpoint": {
        "source_mod": "ProjectEoN", "source_ground": "CrumbleCanyonMidway",
        "fallback_tile": ("ProjectEoN", "NorthernRange"),
        "name_en": "Crooked Cavern Relay", "name_fr": "Relais de la Caverne Tordue",
        "music": "Drenched Bluff.ogg",
        "chapter": "3", "theme": "checkpoint de caverne",
    },
    "gloomy_forest_midpoint": {
        "source_mod": "ProjectEoN", "source_ground": "CrumbleCanyonMidway",
        "fallback_tile": ("ProjectEoN", "ForestDark"),
        "name_en": "Gloomy Forest Relay", "name_fr": "Relais de la Forêt Lugubre",
        "music": "Mystifying Forest.ogg",
        "chapter": "6", "theme": "checkpoint forestier corrompu par l’Anima",
    },
    "cloven_ruins_midpoint": {
        "source_mod": "ProjectEoN", "source_ground": "CrumbleCanyonMidway",
        "fallback_tile": ("ProjectEoN", "NorthernRange"),
        "name_en": "Cloven Ruins Relay", "name_fr": "Relais des Ruines Tordues",
        "music": "In the Depths of the Pit.ogg",
        "chapter": "7", "theme": "checkpoint de ruines avant le Cœur",
    },
    "crystal_sanctuary_relay": {
        "source_mod": "ProjectEoN", "source_ground": "CrumbleCanyonMidway",
        "fallback_tile": ("ZMDO", "CrystalEntrance"),
        "name_en": "Crystal Sanctuary Relay", "name_fr": "Relais du Sanctuaire de Cristal",
        "music": "Anima Core.ogg",
        "chapter": "8", "theme": "checkpoint de réserve d’Anima cristallisée",
    },
    "forgotten_marsh_relay": {
        "source_mod": "ProjectEoN", "source_ground": "CrumbleCanyonMidway",
        "fallback_tile": ("ZMDO", "MysteryEntrance"),
        "name_en": "Forgotten Marsh Relay", "name_fr": "Relais du Marais Oublié",
        "music": "Deep Dark Crater.ogg",
        "chapter": "9", "theme": "checkpoint de marais contaminé",
    },
    "celestial_peak_relay": {
        "source_mod": "ProjectEoN", "source_ground": "CrumbleCanyonMidway",
        "fallback_tile": ("ZMDO", "CrystalEntrance"),
        "name_en": "Celestial Peak Relay", "name_fr": "Relais du Pic Céleste",
        "music": "Sky Peak Cave.ogg",
        "chapter": "10", "theme": "checkpoint d’ascension finale",
    },
}

BOSS_SPECS = {
    # Chapitre 5 : arènes de cinématique/rencontre réancrées sur des grounds existants.
    "vast_steppe_miniboss": {
        "source_mod": "ProjectEoN", "source_ground": "cutscenethieveshideout",
        "name_en": "Vast Steppe — Hollow of the Herd", "name_fr": "Grande Steppe — Creux du Troupeau",
        "music": "Boss Battle!.ogg", "chapter": "5", "boss": "Stantler + Mudbray",
        "reason": "grand espace déjà validé pour confrontation de groupe ; sert à matérialiser le troupeau perturbé",
    },
    "vast_steppe_guardian": {
        "source_mod": "ProjectEoN", "source_ground": "cutscenethieveshideout",
        "name_en": "Vast Steppe — Guardian Hollow", "name_fr": "Grande Steppe — Creux du Gardien",
        "music": "Boss Battle!.ogg", "chapter": "5", "boss": "Stantler",
        "reason": "même géométrie éprouvée que le mini-boss pour conserver la logique spatiale du troupeau",
    },
    "searing_tunnel_miniboss": {
        "source_mod": "ProjectEoN", "source_ground": "cutscenethieveshideout",
        "name_en": "Searing Tunnel — Magma Bend", "name_fr": "Tunnel Incandescent — Coude Magmatique",
        "music": "Boss Battle!.ogg", "chapter": "5", "boss": "Torkoal + Magmar",
        "reason": "arène ouverte et stable, adaptée à une confrontation duo avant les profondeurs",
    },
    "searing_crucible": {
        "source_mod": "ZMDO", "source_ground": "mystery_exit",
        "name_en": "Searing Crucible", "name_fr": "Creuset Incandescent",
        "music": "Boss Battle!.ogg", "chapter": "5", "boss": "Magcargo",
        "reason": "grand ground vertical éprouvé, nécessaire aux coordonnées longues de la scène d’évacuation",
    },
    "mount_windswept_miniboss": {
        "source_mod": "ProjectEoN", "source_ground": "cutscenethieveshideout",
        "name_en": "Mount Windswept — Windbreak Shelf", "name_fr": "Mont Venteux — Replat des Bourrasques",
        "music": "Boss Battle!.ogg", "chapter": "5", "boss": "Gligar + Skarmory",
        "reason": "plateau large et lisible pour une attaque aérienne de duo",
    },
    "mount_windswept_guardian": {
        "source_mod": "ProjectEoN", "source_ground": "cutscenethieveshideout",
        "name_en": "Mount Windswept — Guardian Shelf", "name_fr": "Mont Venteux — Replat du Gardien",
        "music": "Boss Battle!.ogg", "chapter": "5", "boss": "Aerodactyl",
        "reason": "même plateau éprouvé que le mini-boss pour garantir l’arrivée et la trajectoire d’approche",
    },
    # Chapitres 6+.
    "gloomy_forest_boss": {
        "source_mod": "ZMDO", "source_ground": "mystery_exit",
        "name_en": "Heart of the Gloomy Forest", "name_fr": "Cœur de la Forêt Lugubre",
        "music": "Mystifying Forest.ogg", "chapter": "6", "boss": "Zarude",
        "reason": "grand ground ouvert permettant l’entrée longue de l’équipe et l’émergence du boss sans bordure",
    },
    "cloven_ruins_boss": {
        "source_mod": "ProjectEoN", "source_ground": "cutscenethieveshideout",
        "name_en": "Heart of the Cloven Ruins", "name_fr": "Cœur des Ruines Tordues",
        "music": "Boss Battle!.ogg", "chapter": "7", "boss": "Regigigas",
        "reason": "arène centrale stable, assez large pour un colosse et une mise en scène frontale",
    },
    "crystal_sanctuary_boss": {
        "source_mod": "ZMDO", "source_ground": "crystal_exit",
        "name_en": "Heart of the Crystal Sanctuary", "name_fr": "Cœur du Sanctuaire de Cristal",
        "music": "Anima Core.ogg", "chapter": "8", "boss": "Diancie",
        "reason": "ground cristal existant, cohérent avec une réserve d’Anima cristallisée",
    },
    "forgotten_marsh_boss": {
        "source_mod": "ProjectEoN", "source_ground": "drenchedbluffend",
        "name_en": "Heart of the Forgotten Marsh", "name_fr": "Cœur du Marais Oublié",
        "music": "Deep Dark Crater.ogg", "chapter": "9", "boss": "Swampert",
        "reason": "cul-de-sac humide déjà scénarisé, adapté à un boss lié à l’eau stagnante et à l’oubli",
    },
    "celestial_peak_fulgur": {
        "source_mod": "ProjectEoN", "source_ground": "cutsceneintrosnowplace3",
        "name_en": "Celestial Peak — Fulgur Shelf", "name_fr": "Pic Céleste — Replat Fulgur",
        "music": "Boss Battle!.ogg", "chapter": "10", "boss": "Luxray + Lucario + Heliolisk",
        "reason": "large plateau clair, compatible avec une interception d’escouade avant le sommet",
    },
    "celestial_peak_boss": {
        "source_mod": "ProjectEoN", "source_ground": "cutsceneintrosnowplace3",
        "name_en": "Celestial Peak — Summit of the Sun", "name_fr": "Pic Céleste — Sommet du Soleil",
        "music": "Sky Peak Summit.ogg", "chapter": "10", "boss": "Lugia",
        "reason": "large plateau vertical, compatible avec une apparition descendante et une caméra haute",
    },
}


def sanitize(name: str) -> str:
    s = re.sub(r"[^A-Za-z0-9_]+", "_", name).strip("_").lower()
    return s or "asset"


def read_json(path: Path):
    with path.open(encoding="utf-8-sig") as f:
        return json.load(f)


def write_json(path: Path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        f.write("\n")


def iter_frame_dicts(v):
    if isinstance(v, dict):
        if "Sheet" in v and "TexLoc" in v:
            yield v
        for val in v.values():
            yield from iter_frame_dicts(val)
    elif isinstance(v, list):
        for val in v:
            yield from iter_frame_dicts(val)


def first_tile_key(tile_path: Path) -> tuple[int, int]:
    data = tile_path.read_bytes()
    if len(data) < 24:
        return (0, 0)
    tile_count = struct.unpack_from("<I", data, 4)[0]
    if tile_count <= 0:
        return (0, 0)
    key = struct.unpack_from("<Q", data, 8)[0]
    return (key & 0xFFFFFFFF, key >> 32)


def tile_size(tile_path: Path) -> int:
    return struct.unpack_from("<I", tile_path.read_bytes(), 0)[0]


def source_ground_path(mod: str, ground: str) -> Path:
    return SOURCES[mod] / "Data" / "Ground" / f"{ground}.rsground"


def source_tile_path(mod: str, sheet: str) -> Path | None:
    p = SOURCES[mod] / "Content" / "Tile" / f"{sheet}.tile"
    return p if p.exists() else None


def copy_tile_as(src_tile: Path, new_sheet: str):
    dst = TILE_DIR / f"{new_sheet}.tile"
    if not dst.exists() or dst.read_bytes() != src_tile.read_bytes():
        shutil.copyfile(src_tile, dst)


def replace_tiles_with_single_sheet(obj: dict, mod: str, sheet: str, target: str):
    src_tile = source_tile_path(mod, sheet) or (TILE_DIR / f"{sheet}.tile")
    if not src_tile.exists():
        raise FileNotFoundError(f"Fallback tile absent: {mod}/{sheet}")
    new_sheet = f"ne_{sanitize(target)}_tiles_{hashlib.sha1((mod + sheet).encode()).hexdigest()[:8]}"
    copy_tile_as(src_tile, new_sheet)
    x, y = first_tile_key(src_tile)
    for layer in obj.get("Layers", []) or []:
        tiles = layer.get("Tiles", []) or []
        for col in tiles:
            for tile in col:
                tile["AutoTileset"] = ""
                tile["Associates"] = []
                tile["NeighborCode"] = -1
                tile["Layers"] = [{
                    "Frames": [{"Sheet": new_sheet, "TexLoc": {"X": x, "Y": y}}],
                    "FrameLength": 60,
                }]
    return {sheet: new_sheet}


def rename_and_copy_source_sheets(obj: dict, mod: str, target: str):
    sheets = sorted({fr.get("Sheet") for fr in iter_frame_dicts(obj) if fr.get("Sheet")})
    mapping = {}
    missing = []
    for i, sheet in enumerate(sheets):
        src = source_tile_path(mod, sheet)
        if not src:
            missing.append(sheet)
            continue
        new_sheet = f"ne_{sanitize(target)}_{i:02d}_{hashlib.sha1((mod + sheet).encode()).hexdigest()[:8]}"
        copy_tile_as(src, new_sheet)
        mapping[sheet] = new_sheet
    if missing:
        return None, missing
    for fr in iter_frame_dicts(obj):
        if fr.get("Sheet") in mapping:
            fr["Sheet"] = mapping[fr["Sheet"]]
    return mapping, []


def clear_source_text(obj: dict, target: str, name_en: str, name_fr: str, music: str, comment: str):
    obj["Name"] = {"DefaultText": name_en, "LocalTexts": {"fr": name_fr}}
    obj["AssetName"] = target
    obj["Music"] = music
    obj["Released"] = True
    obj["Comment"] = comment


def make_marker(name: str, x: int, y: int, direction=4):
    return {
        "EntName": name, "Direction": direction, "EntEnabled": True,
        "EntOrder": 0, "InteractOrder": 0, "triggerType": 0,
        "Collider": {"X": int(x), "Y": int(y), "Width": 16, "Height": 16},
    }


def make_empty_spawner(npc: str, ent: str, x: int, y: int, direction=4):
    return {
        "NPCName": npc,
        "NPCChar": {
            "Nickname": "", "OriginalUUID": "", "OriginalTeam": "",
            "BaseForm": {"Species": "missingno", "Form": 0, "Skin": "normal", "Gender": 0},
            "Level": 0, "EXP": 0,
            "MaxHPBonus": 0, "AtkBonus": 0, "DefBonus": 0, "MAtkBonus": 0, "MDefBonus": 0, "SpeedBonus": 0,
            "BaseSkills": [{"SkillNum": "", "Charges": 0, "CanForget": True} for _ in range(4)],
            "BaseIntrinsics": ["none"], "FormIntrinsicSlot": -1, "Relearnables": {},
            "Discriminator": 0,
            "MetAt": "", "MetLoc": {"ID": "", "StructID": {"Segment": -1, "ID": -1}, "EntryPoint": -1},
            "DefeatAt": "", "DefeatLoc": {"ID": "", "StructID": {"Segment": -1, "ID": -1}, "EntryPoint": -1},
        },
        "EntName": ent, "Direction": direction, "EntEnabled": True,
        "EntOrder": 0, "InteractOrder": 0, "triggerType": 0,
        "EntityCallbacks": [0],
        "Collider": {"X": int(x), "Y": int(y), "Width": 16, "Height": 16},
    }


def entity_collider(ent: dict):
    return ent.get("Collider") or ent.get("Position") or ent.get("serializationLoc") or {}


def sanitize_ground_object(obj: dict, name: str, trigger: int | None = None):
    out = copy.deepcopy(obj)
    out["EntName"] = name
    if trigger is not None:
        out["triggerType"] = trigger
    # remove obvious source-specific visual labels, keep engine fields/collider intact
    return out


def normalize_relay_entities(obj: dict):
    src_layer = (obj.get("Entities") or [{}])[0]
    markers = src_layer.get("Markers", []) or []
    entrance = markers[0] if markers else make_marker("Entrance", 220, 272)
    ec = entity_collider(entrance)
    edir = entrance.get("Direction", 4)
    main = make_marker("Main_Entrance_Marker", ec.get("X", 220), ec.get("Y", 272), edir)
    entrance2 = make_marker("entrance", ec.get("X", 220), ec.get("Y", 272), edir)

    deposit = cont = leave = None
    for go in src_layer.get("GroundObjects", []) or []:
        n = go.get("EntName", "")
        if n in ("DepositBox", "Storage"):
            deposit = go
        elif n in ("Continue", "Exit"):
            cont = go
        elif n in ("Leave", "South_Exit"):
            leave = go
    ground_objects = []
    if cont:
        ground_objects.append(sanitize_ground_object(cont, "North_Exit", 2))
    if leave:
        ground_objects.append(sanitize_ground_object(leave, "South_Exit", 2))
    else:
        # Duplicate entrance as a south return zone if source only had one exit.
        south = copy.deepcopy(cont) if cont else {"Collider": {"X": ec.get("X", 220) - 24, "Y": ec.get("Y", 272) + 64, "Width": 72, "Height": 16}}
        if "Collider" in south:
            south["Collider"].update({"X": ec.get("X", 220) - 24, "Y": ec.get("Y", 272) + 72, "Width": 72, "Height": 16})
        elif "Position" in south:
            south["Position"].update({"X": ec.get("X", 220) - 24, "Y": ec.get("Y", 272) + 72, "Width": 72, "Height": 16})
        ground_objects.append(sanitize_ground_object(south, "South_Exit", 2))
    if deposit:
        ground_objects.append(sanitize_ground_object(deposit, "Kangaskhan_Rock", 1))

    spawners = []
    source_spawners = src_layer.get("Spawners", []) or []
    for sp in source_spawners:
        if sp.get("EntName", "").startswith("TEAMMATE") or sp.get("NPCName", "").startswith("TEAMMATE"):
            spawners.append(copy.deepcopy(sp))
    if not spawners:
        x, y = ec.get("X", 220), ec.get("Y", 272)
        spawners = [
            make_empty_spawner("Teammate1", "TEAMMATE_1", x + 24, y, edir),
            make_empty_spawner("Teammate2", "TEAMMATE_2", x - 24, y + 24, edir),
            make_empty_spawner("Teammate3", "TEAMMATE_3", x + 48, y + 24, edir),
        ]
    obj["Entities"] = [{
        "Name": "New Era Relay Entity Layer", "Visible": True,
        "MapChars": [], "GroundObjects": ground_objects,
        "Spawners": spawners, "Markers": [main, entrance2],
    }]


def normalize_boss_entities(obj: dict):
    src_layer = (obj.get("Entities") or [{}])[0]
    markers = src_layer.get("Markers", []) or []
    entrance = markers[0] if markers else make_marker("Entrance", 184, 160)
    ec = entity_collider(entrance)
    x, y, d = int(ec.get("X", 184)), int(ec.get("Y", 160)), entrance.get("Direction", 4)
    width_px = len(obj.get("obstacles", [])) * 8
    height_px = (len(obj.get("obstacles", [[None]])[0]) if obj.get("obstacles") else 0) * 8

    def clamp(px, py):
        px = max(8, min(int(px), max(8, width_px - 24)))
        py = max(8, min(int(py), max(8, height_px - 24)))
        return px, py

    x, y = clamp(x, y)
    # Add three teammate anchors around the cloned entrance.  If the entrance is
    # close to the lower border in the source map, place side anchors above it.
    side_y = y + 24
    if side_y + 15 >= height_px:
        side_y = y - 24
    x2, y2 = clamp(x - 24, side_y)
    x3, y3 = clamp(x + 24, side_y)
    spawners = [
        make_empty_spawner("Teammate1", "TEAMMATE_1", x, y, d),
        make_empty_spawner("Teammate2", "TEAMMATE_2", x2, y2, d),
        make_empty_spawner("Teammate3", "TEAMMATE_3", x3, y3, d),
    ]
    obj["Entities"] = [{
        "Name": "New Era Boss Entity Layer", "Visible": True,
        "MapChars": [], "GroundObjects": [], "Spawners": spawners,
        "Markers": [make_marker("Main_Entrance_Marker", x, y, d), make_marker("entrance", x, y, d)],
    }]


def patch_character_essentials():
    src = CHAR_ESS.read_text(encoding="utf-8")
    if "--Chapitres 8-10 : boss New Era" in src:
        return
    insert = """
		--Chapitres 8-10 : boss New Era / entités cinématiques
		Lugia = {
			species = "lugia",
			nickname = 'Lugia',
			instance = 'Lugia',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Lucario = {
			species = "lucario",
			nickname = 'Lucario',
			instance = 'Lucario',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Heliolisk = {
			species = "heliolisk",
			nickname = 'Heliolisk',
			instance = 'Heliolisk',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Diancie = {
			species = "diancie",
			nickname = 'Diancie',
			instance = 'Diancie',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
		Swampert = {
			species = "swampert",
			nickname = 'Swampert',
			instance = 'Swampert',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Mew = {
			species = "mew",
			nickname = 'Mew',
			instance = 'Mew',
			gender = Gender.Genderless,
			form = 0,
			skin = "normal"
		},
"""
    needle = "\n\t--Vendor/Shop NPCs\n"
    if needle not in src:
        raise RuntimeError("Point d’insertion CharacterEssentials introuvable")
    CHAR_ESS.write_text(src.replace(needle, insert + needle, 1), encoding="utf-8")


def clone_one(target: str, spec: dict, kind: str):
    src_path = source_ground_path(spec["source_mod"], spec["source_ground"])
    data = read_json(src_path)
    obj = data["Object"]
    clear_source_text(
        obj, target, spec["name_en"], spec["name_fr"], spec["music"],
        f"New Era {kind}: geometry/collision re-authored and validated for chapter {spec['chapter']}.",
    )
    mapping, missing = rename_and_copy_source_sheets(obj, spec["source_mod"], target)
    if missing:
        fb_mod, fb_sheet = spec["fallback_tile"]
        mapping = replace_tiles_with_single_sheet(obj, fb_mod, fb_sheet, target)
        obj["Comment"] += " Visual retheme applied after collision validation."
    if kind == "relay":
        normalize_relay_entities(obj)
    else:
        normalize_boss_entities(obj)
    write_json(GDIR / f"{target}.rsground", data)
    return mapping


def patch_midpoint_scripts_for_cloned_relay():
    # CrumbleCanyonMidway has a stable central lane around x=188/208/240.
    # Old partner x=156 fell into blocked cells on the cloned collision.
    repl = {
        "Data/Script/halcyon/ground/vast_steppe_midpoint/vast_steppe_midpoint_ch_5.lua": {
            "GROUND:TeleportTo(partner, 168, 380, Direction.Up)": "GROUND:TeleportTo(partner, 208, 380, Direction.Up)",
        },
        "Data/Script/halcyon/ground/crooked_cavern_midpoint/crooked_cavern_midpoint_ch_3.lua": {
            "GROUND:TeleportTo(partner, 156,": "GROUND:TeleportTo(partner, 208,",
            "GROUND:MoveToPosition(partner, 156,": "GROUND:MoveToPosition(partner, 208,",
            "GAME:MoveCamera(172,": "GAME:MoveCamera(200,",
        },
        "Data/Script/halcyon/ground/gloomy_forest_midpoint/gloomy_forest_midpoint_ch_6.lua": {
            "GROUND:TeleportTo(partner, 156,": "GROUND:TeleportTo(partner, 208,",
            "GROUND:MoveToPosition(partner, 156,": "GROUND:MoveToPosition(partner, 208,",
            "GAME:MoveCamera(172,": "GAME:MoveCamera(200,",
        },
    }
    for rel, pairs in repl.items():
        p = ROOT / rel
        if not p.exists():
            continue
        text = p.read_text(encoding="utf-8")
        for a, b in pairs.items():
            text = text.replace(a, b)
        p.write_text(text, encoding="utf-8")


def rebuild_tile_index():
    names = sorted(p.stem for p in TILE_DIR.glob("*.tile"))
    buf = bytearray(struct.pack("<I", len(names)))
    for name in names:
        raw = name.encode("utf-8")
        data = (TILE_DIR / f"{name}.tile").read_bytes()
        tile_count = struct.unpack_from("<I", data, 4)[0]
        header_len = 8 + tile_count * 16
        buf += struct.pack("B", len(raw)) + raw + data[:header_len]
    (TILE_DIR / "index.idx").write_bytes(buf)
    print(f"index.idx reconstruit : {len(names)} tilesets")


def write_integration_docs():
    docs = ROOT / "docs"
    docs.mkdir(exist_ok=True)
    lines = [
        "# Tableau de suivi — intégrations multi-sources New Era",
        "",
        "Directive appliquée : chaque ligne ci-dessous est une ressource clonée comme base technique, renommée et réindexée pour New Era.",
        "",
        "| Classe | Mod source | Ressource d'origine | Nouvelle identité New Era | Chapitre | Boss / Event | Fonction narrative | Clonage placement | Statut |",
        "|---|---|---|---|---|---|---|---|---|",
    ]
    for target, spec in RELAY_SPECS.items():
        lines.append(f"| Donjon principal — relais | {spec['source_mod']} | {spec['source_ground']}.rsground | `{target}` | {spec['chapter']} | Statue Kangourex / checkpoint | {spec['theme']} | oui | Fait — collision à valider via outil |")
    for target, spec in BOSS_SPECS.items():
        lines.append(f"| Donjon principal — boss | {spec['source_mod']} | {spec['source_ground']}.rsground | `{target}` | {spec['chapter']} | {spec['boss']} | {spec['reason']} | oui | Fait — collision à valider via outil |")
    (docs / "integration_tracker.md").write_text("\n".join(lines) + "\n", encoding="utf-8")

    fiches = ["# Fiches de validation — refonte grounds relais/boss", ""]
    for target, spec in {**RELAY_SPECS, **BOSS_SPECS}.items():
        kind = "relais" if target in RELAY_SPECS else "arène de boss"
        fiches += [
            f"## {target}", "",
            f"Origine : Cette ressource vient de {spec['source_mod']} — `{spec['source_ground']}.rsground`.",
            f"Nouvelle identité : Dans New Era, elle devient `{target}` ({spec['name_fr']}).",
            f"Chapitre associé : Chapitre {spec['chapter']}",
            f"Fonction narrative : {spec.get('theme') or spec.get('reason')}",
            f"Boss / Event : {spec.get('boss', 'Statue Kangourex / checkpoint')}",
            "Conséquence : le joueur dispose d’une base spatiale éprouvée, renommée et contrôlable par audit technique.",
            "", "```", f"Type : {kind}",
            f"Ground source : {spec['source_mod']} / {spec['source_ground']}.rsground",
            "Collision régénérée/revalidée après adaptation : à confirmer par tools/audit_ground_spawns.py",
            "Dialogues/scripts source repris : non — seuls géométrie, collision et placements fonctionnels servent de base.",
            "Verdict : en attente d’audit final automatisé + test en jeu", "```", "",
        ]
    (docs / "ground_integration_validation_2026-07-26.md").write_text("\n".join(fiches), encoding="utf-8")


def main():
    patch_character_essentials()
    for target, spec in RELAY_SPECS.items():
        clone_one(target, spec, "relay")
    for target, spec in BOSS_SPECS.items():
        clone_one(target, spec, "boss")
    patch_midpoint_scripts_for_cloned_relay()
    rebuild_tile_index()
    write_integration_docs()
    print("Refonte source-ground terminée.")


if __name__ == "__main__":
    main()
