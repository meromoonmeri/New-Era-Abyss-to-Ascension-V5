# PROJECT_CONTEXT — New Era : Abyss to Ascension

Dernière mise à jour : 2026-07-26 (prise en main de session par agent Arena.ai)

## But de ce fichier

Fichier de reprise à la racine du dépôt. À lire au début de la prochaine session, en complément de `docs/CONTEXTE_PROJET.md`.

## Prise en main effectuée

- Dépôt cloné depuis `https://github.com/meromoonmeri/new-era-abyss-to-ascension-V4.git`.
- Branche locale : `main`, alignée sur `origin/main` au commit `239525a`.
- `Mod.xml`, `patchnotes.txt`, la structure `CONVERSION/`, `Content/`, `Data/`, `Strings/`, `docs/`, `tools/` et l'historique `git log` ont été inspectés.
- Les pages wiki de référence ont été ouvertes au moins pour cadrage initial : `Floor_Generation_Overview`, `Text_Guide`, `Scripting_Cheat_Sheet`, `Script_Reference`. Pour une tâche de code/contenu précise, relire la page pertinente avant modification.
- Le fichier racine `PROJECT_CONTEXT.md` n'existait pas avant cette prise en main ; celui-ci a donc été créé conformément au protocole.

## Identité du mod vérifiée

Dans `Mod.xml` :

- `Name` : `New Era : Abyss to Ascension`
- `Namespace` : `halcyon`
- `UUID` : `CAE98609-7A96-4CFC-B5AB-0E1D41F6A1FF`
- `Version` : `0.5.1`
- `GameVersion` : `0.8.12`
- `ModType` : `Quest`

Rappel : ne pas modifier `Namespace` / UUID sans validation explicite, pour préserver la compatibilité des sauvegardes.

## Intégrité du clone local

Contrôles effectués le 2026-07-26 :

- `git status --short --branch` : propre avant création de ce fichier.
- `git ls-files -d` : aucun fichier suivi supprimé.
- `git fsck --no-progress` : aucune sortie signalant un problème.
- Fichiers suivis vs présents :
  - `Data/Ground/*.rsground` : 68 suivis, 68 présents.
  - `Content/Tile/*.tile` : 248 suivis, 248 présents.
  - `Content/Music/*.ogg` : 51 suivis, 51 présents.
- Tous les gros fichiers critiques observés sont présents, notamment `Data/Ground/metano_town.rsground` (~38,3 Mo), `Content/Tile/index.idx` (~4,4 Mo), `Content/Music/Team_Dazzling.ogg`.

Attention : `verify_new_era.sh` est obsolète sur les compteurs exacts. Il attend 61 `.rsground` et 219 `.tile`, mais le dépôt actuel en contient 68 et 248. Le script signale donc 2 erreurs de comptage alors que les fichiers suivis sont présents.

## Validation exécutée

- `python3 tools/validate_all.py` : OK.
  - Les 5 salles de boss Ch5 (`vast_steppe_miniboss`, `vast_steppe_guardian`, `searing_tunnel_miniboss`, `mount_windswept_miniboss`, `mount_windswept_guardian`) sont validées par le script : présence des fichiers, tilesets, cohérence obstacles, spawners/markers, positions cinématiques, connexité.
- Pas de test en jeu effectué dans cet environnement.

## État technique/narratif constaté

- Le renommage public Halcyon vers `New Era : Abyss to Ascension` est bien présent dans `Mod.xml`, mais le namespace reste `halcyon`.
- `patchnotes.txt` documente seulement les versions 0.3.0, 0.4.0 et 0.5.0 ; il n'est pas à jour avec le commit courant `Version 0.5.1` de `Mod.xml`.
- Le dossier `docs/CONTEXTE_PROJET.md` contient une mémoire longue du projet, notamment les formats `.tile`, `Content/Tile/index.idx`, l'architecture `.rsground` / `.rsmap` / `Data/Zone/*.json`, et la règle de `require` explicite des `ground/<map>/<map>_ch_N.lua`.
- L'architecture Lua réelle diffère du résumé du prompt : il n'y a pas de `newera_common.lua` ni de `newera_include.lua`. Les scripts sont sous le namespace `halcyon`.
- `Data/Script/halcyon/main.lua` charge les services `debug_tools`, `menu_tools`, `upgrade_tools`, `config_tools`.
- `Data/Script/halcyon/event.lua` charge `origin.common`, `halcyon.dungeon_event.beginner_lesson_evt`, `event_single`, `event_battle`, `event_misc`, `event_mapgen`.
- Les `ground/*/init.lua` possédant des fichiers frères `_ch_N.lua` ont été inspectés : aucun cas détecté de sibling `_ch_N.lua` sans `require` correspondant.

## Team Dazzling / Lockpin

- `CharacterEssentials.lua` contient un commentaire explicite : `Lockpin` est le nom français d'espèce de Lopunny, pas un second personnage.
- Team Dazzling utilise les codenames `Adagio` (Tsareena), `Aria` (Lopunny) et `Sonata` (Mismagius).
- `Mawile` existe séparément comme PNJ `Bria`, pas comme membre Team Dazzling.
- `docs/team_dazzling_chapter6.md` dit aussi que le nom utilisé dans les dialogues est `Team Dazzling`, pas `Les Trois Reines`.

## Zones légendaires / Grodoudou

- Le système n'est plus seulement une idée : il existe dans `Data/Script/halcyon/LegendZones.lua`, `Data/Script/halcyon/ground/metano_town/metano_town_legend.lua`, `SV.LegendZones` dans `scriptvars.lua`, et le `require` correspondant dans `metano_town/init.lua`.
- Règle actuelle : achat chez Grodoudou = accès à un lieu de revanche, pas recrutement automatique ni rencontre aléatoire.
- Une seule entrée est actuellement `ready = true` : `verdant_oath` / Zarude, déverrouillée par `SV.Chapter6.DefeatedGloomyBoss == true`, destination `gloomy_forest` segment 3.
- Les autres entrées sont des contrats d'avenir avec `ready = false` ou flags non prêts.

## Points d'attention trouvés pendant la prise en main

1. `verify_new_era.sh` doit être mis à jour : ses seuils exacts 61 maps / 219 tilesets sont faux pour le dépôt courant (68 / 248).
2. `docs/audit_critique_2026-07-26.md` dit que la branche défaite Team Dazzling est absente, mais le code courant contient `PostDefeatCutscene()` et le dispatch depuis `metano_town/init.lua`. Cet audit est donc au moins partiellement dépassé.
3. Suspicion de bug dans `metano_town_ch_6.SetupGround()` : en branche `SV.Chapter6.DefeatedByZarude`, le code appelle `GROUND:TeleportTo(hero, ...)` et `GROUND:TeleportTo(partner, ...)` sans déclarer `local hero = CH('PLAYER')` ni `local partner = CH('Teammate1')` dans cette fonction. À confirmer/corriger avant de travailler sur la branche défaite.
4. Suspicion de bug de progression Ch6 : `PostDefeatCutscene()` pose `SV.Chapter6.PostMissionScenePlayed = true`. Comme le dispatch de la scène de victoire vérifie `MissionComplete and not PostMissionScenePlayed`, cela pourrait empêcher la scène post-victoire après une défaite préalable. À confirmer en test / simulation avant correction.

## Règles opérationnelles pour la prochaine tâche

- Toujours vérifier `git status --short` et `git ls-files -d` avant tout `git add`.
- Ne pas utiliser `git add -A` / `git add .` sans contrôle explicite des suppressions.
- Pour toute affirmation technique, citer fichier + ligne.
- Le test en jeu reste requis dès que possible ; les validations statiques ne suffisent pas.

---

## Session 2026-07-26 — Priorités 1 à 3 traitées sans commit

### Pré-contrôle d'intégrité

Au début de la reprise, le répertoire avait perdu `.git` dans le snapshot local. Le dépôt a été réinitialisé avec `git init`, `git fetch origin main`, puis restauré avec `git reset --hard origin/main` avant toute modification de contenu. Après restauration :

- `Data/Ground/*.rsground` : 68 présents ;
- `Content/Tile/*.tile` : 248 présents ;
- `Content/Music/*.ogg` : 51 présents ;
- `Data/Ground/metano_town.rsground` : 38 335 570 octets ;
- `git ls-files -d` : aucun fichier suivi supprimé.

### Priorité 1.1 — Ch6 `hero` / `partner` non déclarés

Bug confirmé.

Preuve dans l'état `origin/main` : `metano_town_ch_6.SetupGround()` utilisait `GROUND:TeleportTo(hero, ...)` et `GROUND:TeleportTo(partner, ...)` dans la branche retour après défaite Zarude, mais aucune déclaration locale `hero` / `partner` n'existait dans cette fonction. Les seules déclarations de ce type étaient dans d'autres fonctions (`DazzlingIntroduction`, `PostMissionCutscene`, `PostDefeatCutscene`) et ne pouvaient pas être capturées par `SetupGround`.

Test de reproduction par exécution Lua simulée via Lupa, avec `GROUND:TeleportTo` configuré pour refuser un premier argument nil :

```text
C_ORIGIN_CONFIRMED_ERROR [string "<python>"]:9: GROUND.TeleportTo first argument is nil
```

Correction appliquée dans `Data/Script/halcyon/ground/metano_town/metano_town_ch_6.lua` :

- `local hero = CH('PLAYER')` ajouté en début de `SetupGround()` ;
- `local partner = CH('Teammate1')` ajouté juste après ;
- la branche défaite utilise maintenant ces deux valeurs locales.

Lignes actuelles : `metano_town_ch_6.lua:24-26` pour les déclarations, `metano_town_ch_6.lua:69-72` pour les deux `TeleportTo`.

Test après correction :

```text
C_FIXED_TELEPORTS [('Butterfree', 824, 816), ('Adagio', 1008, 784), ('Aria', 1040, 816), ('Sonata', 1072, 848), ('PLAYER', 792, 896), ('Teammate1', 824, 896)]
```

Conclusion : la branche se déclenche en simulation sans erreur nil et téléporte bien le héros + partenaire.

### Priorité 1.2 — Conflit de flag `PostMissionScenePlayed`

Bug confirmé.

Dans l'état `origin/main`, la séquence simulée `défaite Zarude -> PostDefeatCutscene -> nouvelle tentative victorieuse` donnait :

```text
D_ORIGIN_AFTER_DEFEAT calls= ['CALL.PostDefeatCutscene'] PostMission= True PostDefeat= True
D_ORIGIN_AFTER_RETRY_WIN calls= [] PostMission= True PostDefeat= True
```

Donc la scène de victoire était bloquée : `PostDefeatCutscene()` posait `PostMissionScenePlayed = true`, puis le dispatch de victoire ne passait plus.

Correction appliquée :

- le dispatch Ch6 dans `Data/Script/halcyon/ground/metano_town/init.lua` vérifie désormais `DefeatedByZarude and not PostDefeatScenePlayed` pour la branche défaite (`init.lua:102-105`) ;
- `PostDefeatCutscene()` vérifie désormais `PostDefeatScenePlayed` au lieu de `PostMissionScenePlayed` (`metano_town_ch_6.lua:829-832`) ;
- `PostDefeatCutscene()` ne pose plus `PostMissionScenePlayed`; elle pose seulement `PostDefeatScenePlayed = true` (`metano_town_ch_6.lua:957`).

Le contenu narratif de `PostDefeatCutscene()` n'a pas été modifié ; seule la logique de flags/dispatch a été changée.

Tests après correction :

```text
D_FIXED_AFTER_DEFEAT calls= ['CALL.PostDefeatCutscene'] PostMission= False PostDefeat= True
D_FIXED_AFTER_RETRY_WIN calls= ['CALL.PostMissionCutscene'] PostMission= True PostDefeat= True
D_FIXED_VICTORY_ONLY calls= ['CALL.PostMissionCutscene'] PostMission= True PostDefeat= False
```

Conclusion :

- défaite puis victoire : la scène défaite se joue, puis la scène victoire se joue à la réussite ultérieure ;
- victoire seule : la scène victoire continue de se jouer ;
- pas de test en jeu réel effectué, seulement simulation Lua avec stubs moteur.

### Priorité 2 — `verify_new_era.sh`

Script mis à jour :

- `EXPECTED_GROUNDS=68` (`verify_new_era.sh:13`) ;
- `EXPECTED_TILESETS=248` (`verify_new_era.sh:14`) ;
- `EXPECTED_MUSIC=51` (`verify_new_era.sh:15`) ;
- les checks `.rsground`, `.tile` et musiques comparent désormais contre ces constantes (`verify_new_era.sh:20-25`, `:56-61`, `:79-84`).

Autres compteurs inspectés :

- Lua : le script affiche 229 fichiers mais ne bloquait pas sur un seuil obsolète ;
- zones JSON : le script affiche 31 zones mais ne bloquait pas sur un seuil obsolète ;
- `.resx` : pas de compteur dédié dans ce script.

Relance après correction :

```text
✅ TOUT OK — 68 maps, 248 tilesets, 51 musiques
```

### Priorité 3 — Grodoudou / Zarude segment 3

Deux niveaux de vérification ont été exécutés.

#### Vérification statique complète

`python3 tools/verify_legend.py /home/user/new-era-abyss-to-ascension-V4` : résultat `TOUT EST VERIFIE`.

Points vérifiés par ce script :

- `Legend_Merchant` est présent sur `metano_town.rsground`, espèce `wigglytuff`, action activable, case marchable ;
- `Legend_Stand` et `Legend_Stand_Marker` existent ;
- `metano_town/init.lua` require et délègue au module `metano_town_legend.lua` ;
- `LegendZones.lua` existe ;
- toutes les clés `LZ_*` utilisées existent en EN et FR ;
- `verdant_oath` est la seule entrée `ready=true` ;
- `gloomy_forest` possède le segment 3 ;
- le segment 3 charge `verdant_oath_arena.rsmap` ;
- la map contient Zarude et `Unrecruitable = false` ;
- `zone/gloomy_forest/init.lua` gère `segmentID == 3` et appelle `LegendZones.SetDefeated('verdant_oath')`.

#### Simulation Lua du parcours boutique

Simulation via Lupa du vrai `LegendZones.lua` + `metano_town_legend.lua` avec stubs moteur :

```text
A no story unlock: buy list stays empty
  keys_contains_Verdant= False nothing= True
  spent= [] purchased= False defeated_flag= False
  enterDungeon= []

B story unlock: purchase succeeds
  keys_contains_Verdant= True nothing= False
  spent= [15000] purchased= True defeated_flag= False
  enterDungeon= []
  sounds= ['DUN_Money']
  flash= [(0, 0, 2, 6, 26)]

C owned zone: travel enters gloomy_forest segment 3
  keys_contains_Verdant= True nothing= False
  spent= [] purchased= True defeated_flag= False
  enterDungeon= [('gloomy_forest', 3, 0, 0)]

D segment 3 combat context
  segment_count= 4 mapid= verdant_oath_arena rsmap_exists= True
  map_species= ['zarude'] unrecruitable= [False]
```

Conclusion : le parcours achat puis voyage vers `gloomy_forest` segment 3 est cohérent en simulation. Le combat réel en jeu n'a pas été lancé dans cet environnement.

### Validations générales relancées

- `bash verify_new_era.sh` : OK, plus de fausse erreur de compteur.
- `python3 tools/verify_legend.py /home/user/new-era-abyss-to-ascension-V4` : OK.
- `python3 tools/validate_all.py` : OK, les 5 salles de boss Ch5 restent valides.

### État Git après cette session

Fichiers modifiés non commités :

- `Data/Script/halcyon/ground/metano_town/init.lua`
- `Data/Script/halcyon/ground/metano_town/metano_town_ch_6.lua`
- `verify_new_era.sh`

Fichier non suivi :

- `PROJECT_CONTEXT.md`

Aucun commit/push effectué.

---

## Session 2026-07-26 — Application du guide maître Team Dazzling

Guide lu : `/home/user/uploads/guide-maitre-new-era.md`.

### Décision d'application

Le guide demande une introduction officielle Team Dazzling immédiatement après `Grand Stepped` (`guide-maitre-new-era.md:103-104`). Dans le dépôt réel, aucun identifiant exact `Grand Stepped` n'existe ; l'équivalent le plus proche est `vast_steppe` / Grande Steppe. Or `vast_steppe` est intégré au chapitre 5 comme étape de l'expédition : après victoire finale, `Data/Script/halcyon/zone/vast_steppe/init.lua:100-102` route directement vers `searing_tunnel_entrance`, et `vast_steppe_guardian_ch_5.DefeatedBoss()` route aussi vers `searing_tunnel_entrance` (`Data/Script/halcyon/ground/vast_steppe_guardian/vast_steppe_guardian_ch_5.lua:239-244`).

Après clarification utilisateur, carte blanche a été donnée. Choix appliqué : ne pas casser le flux Ch5 existant ; renforcer la première scène Team Dazzling déjà chargée par l'architecture actuelle en chapitre 6, tout en appliquant les exigences qualitatives du guide : entrée célébrité, foule, thème musical, ton condescendant non maléfique, mission Chenipent comme contraste prestige/compassion.

### Changements appliqués

Fichier : `Data/Script/halcyon/ground/metano_town/metano_town_ch_6.lua`.

- Ajout d'un court temps de célébration avant l'arrivée des Dazzling : nouvelles clés `MT6_118` à `MT6_121`, jouées juste après le placement initial du héros, du partenaire et de Papilusion.
- Réorganisation locale : Papilusion ne formule sa demande qu'après l'entrée de la Team Dazzling, pour suivre le déroulé du guide : satisfaction du retour -> rumeur -> entrée Dazzling -> demande de secours.
- Ajout du thème `Team_Dazzling.ogg` dans l'introduction, avec `SOUND:FadeOutBGM(30)` puis `SOUND:PlayBGM("Team_Dazzling.ogg", true)`. Le fichier existe et `verify_new_era.sh` le vérifie.
- Réécriture des clés `MT6_003` à `MT6_006`, `MT6_015` à `MT6_017`, `MT6_042` à `MT6_047` pour coller au guide : Adagio polie et supérieure, Aria provocatrice, Sonata théâtrale, foule impressionnée.

Fichiers de texte :

- `Data/Script/halcyon/ground/metano_town/strings.resx` : valeurs EN ajustées et clés `MT6_118` à `MT6_121` ajoutées.
- `Data/Script/halcyon/ground/metano_town/strings.fr.resx` : valeurs FR ajustées et clés `MT6_118` à `MT6_121` ajoutées.

Adaptation assumée : le guide parle de Chenipotte, mais le dépôt réel a déjà `Venipede` / `Chenipent` comme personnage de mission (`CharacterEssentials.lua` et `docs/team_dazzling_chapter6.md`). La scène conserve donc Chenipent pour ne pas casser les scripts de mission existants.

### Tests effectués

- Parse XML de `strings.resx` et `strings.fr.resx` : OK.
- Simulation Lua de `metano_town_ch_6.SetupGround()` + `DazzlingIntroduction()` avec stubs moteur : OK.
  - `SV.Chapter6.DazzlingIntroPlayed` devient `true`.
  - `SV.Chapter6.MissionAvailable` devient `true`.
  - `SOUND:PlayBGM("Team_Dazzling.ogg", true)` est bien appelé.
  - Les nouvelles clés `MT6_118` à `MT6_121` sont bien lues.
- `bash verify_new_era.sh` : OK.
- `python3 tools/validate_all.py` : OK.
- `python3 tools/verify_legend.py /home/user/new-era-abyss-to-ascension-V4` : OK.

Pas de test en jeu réel effectué dans cet environnement.

### État Git

Modifications non commitées supplémentaires :

- `Data/Script/halcyon/ground/metano_town/metano_town_ch_6.lua`
- `Data/Script/halcyon/ground/metano_town/strings.resx`
- `Data/Script/halcyon/ground/metano_town/strings.fr.resx`

Les modifications précédentes restent non commitées :

- `Data/Script/halcyon/ground/metano_town/init.lua`
- `verify_new_era.sh`
- `PROJECT_CONTEXT.md` non suivi
