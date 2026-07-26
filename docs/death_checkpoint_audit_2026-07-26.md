# Audit logique de mort / retour de segment — 2026-07-26

## Portee

Audit statique et correctif des routes de defaite/KO pour les donjons et relais New Era actuellement branches dans `halcyon` :

- Vast Steppe ;
- Searing Tunnel / Searing Crucible ;
- Mount Windswept ;
- Gloomy Forest ;
- Cloven Ruins ;
- Crystal Sanctuary ;
- Forgotten Marsh ;
- Celestial Peak.

> Limite : les tests KO reels en mode dev PMDO restent a effectuer dans le moteur. Cette passe corrige les references et les branches manifestement invalides cote scripts/donnees.

## Correctifs appliques

- `SV.checkpoint` : correction de la cle par defaut `Structure` -> `Segment`, car `COMMON.EndDungeonDay` lit `SV.checkpoint.Segment`.
- Ajout d'initialisation explicite de `SV.checkpoint.Zone/Segment/Map/Entry` avant les entrees de donjon et depuis les relais existants.
- Ajout des GroundMaps de relais/boss futurs dans `Data/Zone/master_zone.json`, afin que les retours `EndDungeonRun` / `EnterZone` pointent vers des mapIDs valides.
- Vast Steppe : une mort apres le relais (`segmentID == 2`) revient maintenant a `vast_steppe_midpoint` (`master_zone` mapID 62) au lieu de retomber dans la branche generale d'entree.
- Mount Windswept : une mort apres le relais (`segmentID == 2`) revient maintenant a `mount_windswept_midpoint` (`master_zone` mapID 63) au lieu d'achever la journee/guilde.
- Cloven Ruins : les retours pre-relais pointent vers `cloven_ruins_entrance` (mapID 64) et les morts post-relais vers `cloven_ruins_midpoint` (mapID 66), au lieu de `vast_steppe_entrance` (mapID 46).
- Creation du script `Data/Script/halcyon/ground/cloven_ruins_midpoint/init.lua`, manquant alors que le ground etait reference dans `master_zone` et par `zone/cloven_ruins/init.lua`.
- Crystal Sanctuary / Forgotten Marsh / Celestial Peak : les morts apres relais/boss reviennent maintenant au relais dedie ajoute dans `master_zone`; le fichier `celestial_peak/init.lua` a aussi ete corrige pour supprimer une fin de fichier incoherente (`end`/`EnterGroundMap` parasite).
- Ajout de `tools/audit_dungeon_death_logic.py` pour verifier statiquement les mapIDs `master_zone`, `ExitSegment` et la cle `SV.checkpoint.Segment`.

## Validation statique

Commande executee :

```bash
python3 tools/audit_dungeon_death_logic.py
```

Resultat :

```text
AUDIT OK
master_zone GroundMaps: 75 entries
- celestial_peak_relay: mapID 72
- cloven_ruins_midpoint: mapID 66
- crystal_sanctuary_relay: mapID 68
- forgotten_marsh_relay: mapID 70
- gloomy_forest_midpoint: mapID 61
- mount_windswept_midpoint: mapID 63
- searing_tunnel_midpoint: mapID 48
- vast_steppe_midpoint: mapID 62
```

## Fiche de suivi rapide

| Donjon / zone | ExitSegment present | Retour mort avant relais | Retour mort apres relais | Validation statique |
|---|---:|---|---|---:|
| Vast Steppe | oui | entree Vast Steppe mapID 46 | `vast_steppe_midpoint` mapID 62 | OK |
| Searing Tunnel | oui | entree Searing Tunnel mapID 47 | `searing_tunnel_midpoint` mapID 48 | OK |
| Mount Windswept | oui | entree Mount Windswept mapID 50 | `mount_windswept_midpoint` mapID 63 | OK |
| Gloomy Forest | oui | fin de journee / ville selon script existant | `gloomy_forest_midpoint` mapID 61 | OK |
| Cloven Ruins | oui | `cloven_ruins_entrance` mapID 64 | `cloven_ruins_midpoint` mapID 66 | OK |
| Crystal Sanctuary | oui | fallback valide mapID 64 tant qu'aucune entree dediee n'existe | `crystal_sanctuary_relay` mapID 68 | OK statique |
| Forgotten Marsh | oui | fallback valide mapID 64 tant qu'aucune entree dediee n'existe | `forgotten_marsh_relay` mapID 70 | OK statique |
| Celestial Peak | oui | fallback valide mapID 64 tant qu'aucune entree dediee n'existe | `celestial_peak_relay` mapID 72 | OK statique |

## Tests moteur requis

A faire en mode dev PMDO pour fermer l'audit :

1. Entrer dans Vast Steppe, mourir avant relais : retour entree, pas d'ecran noir.
2. Entrer dans Vast Steppe, atteindre relais, continuer segment 2, mourir : retour `vast_steppe_midpoint`, pas d'ecran noir.
3. Repeter au minimum sur Mount Windswept, Searing Tunnel, Gloomy Forest et Cloven Ruins.
4. Lorsque les chapitres 8-10 seront jouables, tester Crystal Sanctuary, Forgotten Marsh et Celestial Peak depuis leurs routes narratives finales.
