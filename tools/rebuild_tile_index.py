#!/usr/bin/env python3
"""Reconstruit Content/Tile/index.idx depuis tous les .tile présents sur disque."""
from __future__ import annotations
import os
import struct
from pathlib import Path

ROOT = Path(os.environ.get("MOD_ROOT", Path(__file__).resolve().parents[1]))
TILE_DIR = ROOT / "Content" / "Tile"
OUT = TILE_DIR / "index.idx"

names = sorted(p.stem for p in TILE_DIR.glob("*.tile"))
buf = bytearray()
buf += struct.pack("<I", len(names))
for name in names:
    raw = name.encode("utf-8")
    if len(raw) > 255:
        raise ValueError(f"Nom de tileset trop long pour index.idx: {name}")
    data = (TILE_DIR / f"{name}.tile").read_bytes()
    if len(data) < 8:
        raise ValueError(f"Tileset invalide: {name}.tile")
    tile_size, tile_count = struct.unpack_from("<II", data, 0)
    header_len = 8 + tile_count * 16
    if len(data) < header_len:
        raise ValueError(f"Index interne tronqué: {name}.tile")
    buf += struct.pack("B", len(raw))
    buf += raw
    buf += data[:header_len]

OUT.write_bytes(buf)
print(f"index.idx reconstruit : {len(names)} tilesets, {len(buf)} octets")
