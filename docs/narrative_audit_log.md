# Journal d’audit narratif global

## Passage du 2026-07-26 — correctifs spatiaux relais/boss

Date de l’audit : 2026-07-26

Chapitres couverts : chapitres 5 à 10, avec priorité technique sur les relais/checkpoints et les grounds de boss.

Ressources vérifiées :
- `vast_steppe_midpoint`, `mount_windswept_midpoint`, `searing_tunnel_midpoint` ;
- `vast_steppe_miniboss`, `vast_steppe_guardian`, `searing_tunnel_miniboss`, `searing_crucible`, `mount_windswept_miniboss`, `mount_windswept_guardian` ;
- `gloomy_forest_boss`, `cloven_ruins_boss` ;
- `crystal_sanctuary_boss`, `forgotten_marsh_boss`, `celestial_peak_fulgur`, `celestial_peak_boss` ;
- `celestial_peak_relay`, `crystal_sanctuary_relay`, `forgotten_marsh_relay` ;
- checkpoints déjà présents : `crooked_cavern_midpoint`, `gloomy_forest_midpoint`, `cloven_ruins_midpoint`.

Incohérences trouvées :
- Plusieurs coordonnées de cutscene provenaient de patrons de grandes arenas et sortaient des limites sur les grounds 30×40 (`vast_steppe_midpoint`, `mount_windswept_midpoint`, `cloven_ruins_boss`).
- Certains markers/spawns étaient à cheval sur des cellules bloquées (`Main_Entrance_Marker` des petits boss/relays, `Kangaskhan_Statue` des relays futurs, `TEAMMATE_3` sur `searing_tunnel_miniboss`).
- `Zarude` dans `gloomy_forest_boss` et certains trajets de `mount_windswept_guardian` touchaient une cellule bloquée.
- `growlithe` et `zigzagoon` dans `searing_crucible` étaient placés à `Y=504`, exactement hors borne pour une map de 504 px de haut.
- Les boss futurs `Lugia`, `Lucario`, `Heliolisk`, `Diancie`, `Swampert` et `Mew` étaient invoqués par script sans entrée correspondante dans `CharacterEssentials.lua`.

Actions correctives :
- Repositionnement des coordonnées scriptées hors bornes vers des zones internes walkables.
- Ouverture de petites zones/couloirs de collision (`Tags = 0`) pour les trajets de cutscene validés.
- Repositionnement des markers/spawners problématiques sur cellules marchables.
- Ajout des entrées manquantes dans `CharacterEssentials.lua`.
- Reconstruction de `Content/Tile/index.idx` pour couvrir les 248 tilesets présents.
- Ajout de `tools/audit_ground_spawns.py`, `tools/fix_ground_spatial.py` et `tools/rebuild_tile_index.py` pour rejouer l’audit/correctif.
- Rapport spatial détaillé ajouté : `docs/ground_spatial_audit_2026-07-26.md`.

Verdict global : **non, le joueur ne devrait pas sentir le patchwork sur cette passe technique**. Les corrections ne changent pas la fonction narrative des zones ; elles empêchent surtout les entités d’apparaître hors champ, hors carte ou sur collision bloquée. La continuité narrative globale reste à relire après chaque intégration majeure de nouveaux grounds externes.

## Passage du 2026-07-26 — logique de mort / checkpoints

Date de l'audit : 2026-07-26

Chapitres couverts : chapitres 5 à 10, avec verification des retours KO avant/apres relais.

Actions correctives :
- Correction de `SV.checkpoint.Structure` en `SV.checkpoint.Segment` dans `scriptvars.lua`.
- Initialisation explicite des checkpoints avant les entrees de donjon et depuis les relais principaux.
- Ajout des relais/boss futurs dans `master_zone` pour obtenir des mapIDs valides.
- Correction des retours post-relais de `vast_steppe`, `mount_windswept`, `cloven_ruins`, `crystal_sanctuary`, `forgotten_marsh` et `celestial_peak`.
- Ajout du rapport `docs/death_checkpoint_audit_2026-07-26.md` et de l'outil `tools/audit_dungeon_death_logic.py`.

Validation : audit statique OK (`python3 tools/audit_dungeon_death_logic.py`). Tests KO reels PMDO encore requis.
