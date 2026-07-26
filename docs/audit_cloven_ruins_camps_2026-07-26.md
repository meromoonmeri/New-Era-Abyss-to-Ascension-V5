# Audit immédiat — Cloven Ruins, camps/relais et équivalents calqués sur de vrais Grounds

Date : 2026-07-26
Directive appliquée : `prompt-audit-cloven-ruins-camps.md` + directive multi-sources sections 11 à 15.

## Réponse courte

Oui : les Grounds du périmètre ci-dessous sont désormais **calqués sur de vrais Grounds PMDO/RogueEssence** provenant de ProjectEoN ou ZMDO, et non plus sur des compositions manuelles non garanties.

Limite honnête : le sandbox ne permet pas de lancer PMDO en mode développeur, donc le **test réel F1/F9/F11/F2-F3 n’a pas été effectué ici**. La validation effectuée est statique : dimensions, collision, markers, spawners, coordonnées scriptées et chemins simulés via `tools/audit_ground_spawns.py`.

## Synthèse de validation statique

Commandes exécutées :

```bash
python3 tools/audit_ground_spawns.py
python3 tools/validate_all.py
python3 tools/validate_ch5.py
bash verify_new_era.sh
```

Résultats :

- `audit_ground_spawns.py` : 21/21 Grounds OK, 0 erreur.
- `validate_all.py` : toutes les salles de boss ch.5 valides.
- `validate_ch5.py` : chaîne du chapitre 5 cohérente.
- `verify_new_era.sh` : 68 maps, 250 tilesets, 51 musiques, OK.

## Détail par Ground

| Ground | Statut avant audit | Source réelle utilisée | Correctifs appliqués | Test réel mode dev | Verdict final |
|---|---|---|---|---|---|
| `cloven_ruins_boss` | partiellement/inventé, non garanti | ProjectEoN / `cutscenethieveshideout.rsground` | arène reconstruite, MapChars source supprimés, markers/spawners New Era, tileset renommé `ne_*`, scripts conservés côté New Era | non | OK statique — test PMDO requis |
| `cloven_ruins_midpoint` | partiellement/inventé, non garanti | ProjectEoN / `CrumbleCanyonMidway.rsground` | relais reconstruit, ancre Kangourex/entrées/sorties calquées, tileset rethemé/renommé | non | OK statique — test PMDO requis |
| `vast_steppe_midpoint` | partiellement/inventé, non garanti | ProjectEoN / `CrumbleCanyonMidway.rsground` | relais reconstruit ; partenaire déplacé sur la voie walkable clonée | non | OK statique — test PMDO requis |
| `mount_windswept_midpoint` | partiellement/inventé, non garanti | ProjectEoN / `CrumbleCanyonMidway.rsground` | relais reconstruit ; collision et markers validés | non | OK statique — test PMDO requis |
| `searing_tunnel_midpoint` | partiellement/inventé, non garanti | ProjectEoN / `CrumbleCanyonMidway.rsground` | relais reconstruit ; entrée/sortie/Kangourex validés | non | OK statique — test PMDO requis |
| `crooked_cavern_midpoint` | partiellement/inventé, non garanti | ProjectEoN / `CrumbleCanyonMidway.rsground` | relais reconstruit ; script midpoint adapté à la voie walkable clonée | non | OK statique — test PMDO requis |
| `gloomy_forest_midpoint` | partiellement/inventé, non garanti | ProjectEoN / `CrumbleCanyonMidway.rsground` | relais reconstruit ; script midpoint adapté à la voie walkable clonée | non | OK statique — test PMDO requis |
| `crystal_sanctuary_relay` | partiellement/inventé, non garanti | ProjectEoN / `CrumbleCanyonMidway.rsground` | relais reconstruit et rethemé cristal | non | OK statique — test PMDO requis |
| `forgotten_marsh_relay` | partiellement/inventé, non garanti | ProjectEoN / `CrumbleCanyonMidway.rsground` | relais reconstruit et rethemé marais | non | OK statique — test PMDO requis |
| `celestial_peak_relay` | partiellement/inventé, non garanti | ProjectEoN / `CrumbleCanyonMidway.rsground` | relais reconstruit et rethemé ascension/céleste | non | OK statique — test PMDO requis |
| `vast_steppe_miniboss` | partiellement/inventé, non garanti | ProjectEoN / `cutscenethieveshideout.rsground` | arène reconstruite ; spawns New Era ; source narrative supprimée | non | OK statique — test PMDO requis |
| `vast_steppe_guardian` | partiellement/inventé, non garanti | ProjectEoN / `cutscenethieveshideout.rsground` | arène reconstruite ; spawns New Era ; source narrative supprimée | non | OK statique — test PMDO requis |
| `searing_tunnel_miniboss` | partiellement/inventé, non garanti | ProjectEoN / `cutscenethieveshideout.rsground` | arène reconstruite ; spawns New Era ; source narrative supprimée | non | OK statique — test PMDO requis |
| `searing_crucible` | partiellement/inventé, non garanti | ZMDO / `mystery_exit.rsground` | grande arène verticale reconstruite pour la scène Magcargo | non | OK statique — test PMDO requis |
| `mount_windswept_miniboss` | partiellement/inventé, non garanti | ProjectEoN / `cutscenethieveshideout.rsground` | arène reconstruite ; spawns New Era ; source narrative supprimée | non | OK statique — test PMDO requis |
| `mount_windswept_guardian` | partiellement/inventé, non garanti | ProjectEoN / `cutscenethieveshideout.rsground` | arène reconstruite ; spawns New Era ; source narrative supprimée | non | OK statique — test PMDO requis |
| `gloomy_forest_boss` | partiellement/inventé, non garanti | ZMDO / `mystery_exit.rsground` | grande arène ouverte reconstruite pour l’arrivée longue et Zarude | non | OK statique — test PMDO requis |
| `crystal_sanctuary_boss` | partiellement/inventé, non garanti | ZMDO / `crystal_exit.rsground` | arène cristal reconstruite ; Diancie conservée comme boss New Era | non | OK statique — test PMDO requis |
| `forgotten_marsh_boss` | partiellement/inventé, non garanti | ProjectEoN / `drenchedbluffend.rsground` | arène humide reconstruite ; PNJ source supprimés ; Swampert New Era | non | OK statique — test PMDO requis |
| `celestial_peak_fulgur` | partiellement/inventé, non garanti | ProjectEoN / `cutsceneintrosnowplace3.rsground` | plateau large reconstruit pour l’escouade Fulgur | non | OK statique — test PMDO requis |
| `celestial_peak_boss` | partiellement/inventé, non garanti | ProjectEoN / `cutsceneintrosnowplace3.rsground` | plateau large reconstruit pour Lugia | non | OK statique — test PMDO requis |

## Nettoyage effectué

- Suppression des anciens assets runtime à noms visibles `EoN_*` et `ZMDO_*` non référencés par les Grounds finaux.
- Réindexation complète : `Content/Tile/index.idx` reconstruit pour 250 tilesets.
- Les sources d’origine ne subsistent que dans les rapports `docs/`, pas dans les fichiers runtime `Data`, `Content`, `Strings`.

## Prochaine vérification obligatoire en jeu

À faire dans PMDO dev mode :

1. Charger New Era seul.
2. `Travel > Enter Ground` pour chaque Ground listé.
3. F1 : vérifier hitboxes et positions.
4. F9 : vérifier toute la géométrie.
5. F11 : capturer la carte complète.
6. F2/F3 : vérifier les triggers/cutscenes de boss frame par frame.

Verdict final jouable après cette étape : **à confirmer en PMDO**, mais la passe statique est propre et prête à tester.
