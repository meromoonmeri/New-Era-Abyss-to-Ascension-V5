#!/usr/bin/env python3
"""Static audit for dungeon death/checkpoint routing.

Checks the New Era zone scripts for the most common black-screen causes:
- SV.checkpoint uses Segment (not the obsolete Structure key);
- every halcyon zone init.lua declares ExitSegment;
- hard-coded master_zone map IDs used by EndDungeonRun/EnterZone exist in Data/Zone/master_zone.json;
- chapter relay grounds referenced by checkpoint/death logic exist in master_zone.

This is a static guardrail only; PMDO dev-mode KO tests are still required.
"""
from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MASTER_ZONE = ROOT / "Data/Zone/master_zone.json"
SCRIPT_VARS = ROOT / "Data/Script/halcyon/scriptvars.lua"
ZONE_DIR = ROOT / "Data/Script/halcyon/zone"

WATCHED_RELAY_GROUNDS = {
    "searing_tunnel_midpoint",
    "gloomy_forest_midpoint",
    "vast_steppe_midpoint",
    "mount_windswept_midpoint",
    "cloven_ruins_midpoint",
    "crystal_sanctuary_relay",
    "forgotten_marsh_relay",
    "celestial_peak_relay",
}


def main() -> int:
    failures: list[str] = []
    master = json.loads(MASTER_ZONE.read_text(encoding="utf-8-sig"))["Object"]
    grounds = master["GroundMaps"]

    sv = SCRIPT_VARS.read_text(encoding="utf-8")
    if "SV.checkpoint" not in sv or "Segment" not in sv.split("SV.checkpoint", 1)[1].split("}", 1)[0]:
        failures.append("SV.checkpoint ne definit pas la cle Segment attendue par COMMON.EndDungeonDay")
    if "Structure" in sv.split("SV.checkpoint", 1)[1].split("}", 1)[0]:
        failures.append("SV.checkpoint contient encore Structure dans son bloc par defaut")

    missing_relays = sorted(name for name in WATCHED_RELAY_GROUNDS if name not in grounds)
    if missing_relays:
        failures.append("GroundMaps manquants dans master_zone: " + ", ".join(missing_relays))

    map_ref = re.compile(r"(?:EndDungeonRun|EnterZone)\(result,\s*[\"']master_zone[\"'],\s*-1,\s*(\d+),")
    enter_ref = re.compile(r"EnterZone\([\"']master_zone[\"'],\s*-1,\s*(\d+),")
    for path in sorted(ZONE_DIR.glob("*/init.lua")):
        text = path.read_text(encoding="utf-8")
        if "function " not in text or ".ExitSegment" not in text:
            failures.append(f"ExitSegment absent: {path.relative_to(ROOT)}")
        for pattern in (map_ref, enter_ref):
            for match in pattern.finditer(text):
                idx = int(match.group(1))
                if idx < 0 or idx >= len(grounds):
                    failures.append(f"mapID master_zone invalide {idx}: {path.relative_to(ROOT)}")

    if failures:
        print("AUDIT ECHEC")
        for item in failures:
            print("- " + item)
        return 1

    print("AUDIT OK")
    print(f"master_zone GroundMaps: {len(grounds)} entries")
    for name in sorted(WATCHED_RELAY_GROUNDS):
        print(f"- {name}: mapID {grounds.index(name)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
