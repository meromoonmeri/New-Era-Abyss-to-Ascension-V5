# Journal d’audit narratif global

## Passage du 2026-07-26 — refonte source-ground relais/boss

Date de l'audit : 2026-07-26

Chapitres couverts : 3, 5, 6, 7, 8, 9 et 10, avec focus immédiat sur l’ensemble du chapitre 5, les relais/checkpoints et tous les Grounds de boss actuellement présents.

Ressources vérifiées (réf. `docs/integration_tracker.md`) : tous les relais et boss listés dans le tableau de suivi, soit `vast_steppe_midpoint`, `searing_tunnel_midpoint`, `mount_windswept_midpoint`, `crooked_cavern_midpoint`, `gloomy_forest_midpoint`, `cloven_ruins_midpoint`, `crystal_sanctuary_relay`, `forgotten_marsh_relay`, `celestial_peak_relay`, ainsi que `vast_steppe_miniboss`, `vast_steppe_guardian`, `searing_tunnel_miniboss`, `searing_crucible`, `mount_windswept_miniboss`, `mount_windswept_guardian`, `gloomy_forest_boss`, `cloven_ruins_boss`, `crystal_sanctuary_boss`, `forgotten_marsh_boss`, `celestial_peak_fulgur`, `celestial_peak_boss`.

Incohérences trouvées :
- Anciennes bases faites à la main ou issues de patrons hétérogènes : remplacées par des Grounds sources réels.
- Plusieurs entités de boss futurs référencées sans entrée `CharacterEssentials.lua` : corrigé (`Lugia`, `Lucario`, `Heliolisk`, `Diancie`, `Swampert`, `Mew`).
- L’index des tilesets ne pouvait plus rester à 248 après renommage/réindexation : reconstruit et attendu à 250 après suppression des reliquats non référencés EoN/ZMDO.

Actions correctives :
- Refonte par clonage de géométrie/collision depuis ProjectEoN et ZMDO, sans reprise narrative des scènes sources.
- Renommage des `AssetName`, noms visibles, markers, objets de relais et feuilles de tileset sous préfixe `ne_*`.
- Suppression des MapChars/PNJ d’origine sur les grounds clonés ; remplacement par markers/spawners New Era et scripts existants réadaptés lorsque nécessaire.
- Ajout des fiches/tableaux : `docs/integration_tracker.md`, `docs/ground_integration_validation_2026-07-26.md`, `docs/ground_spatial_audit_2026-07-26.md`.
- Outils ajoutés : `tools/integrate_source_grounds.py`, `tools/audit_ground_spawns.py`, `tools/rebuild_tile_index.py`, `tools/fix_ground_spatial.py`.

Verdict global : **non, le patchwork ne devrait pas être perceptible sur cette passe structurelle**. Les ressources ont été renommées, les placements sources ne conservent pas leurs personnages/dialogues d’origine, et chaque Ground contrôlé a désormais un rôle explicite dans New Era. Réserve : un test en jeu reste obligatoire pour juger la qualité visuelle fine du retheming et des caméras au-delà du contrôle statique.
