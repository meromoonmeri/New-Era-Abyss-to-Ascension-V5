# PROMPT — AUDIT ET CORRECTIF : LOGIQUE DE MORT / RETOUR DE SEGMENT SUR TOUS LES DONJONS

## Symptôme signalé

Sur plusieurs donjons, dont **Vast Steppe**, la mort du joueur (défaite, KO) provoque un **écran noir** au lieu du comportement attendu : retour automatique à l'entrance (ou au dernier checkpoint franchi). Ce prompt demande un audit complet de la logique de fin de segment sur **tous les donjons de New Era**, pas seulement Vast Steppe, avec correction immédiate de chaque cas trouvé.

## Référence technique (documentation officielle PMDO)

- Structure des scripts de zone : https://wiki.pmdo.pmdcollab.org/Creating_Dungeons
- Scripts de zone détaillés (`ExitSegment`) : https://wiki.pmdo.pmdcollab.org/Basic_Zone_Scripts
- Aide-mémoire de scripting : https://wiki.pmdo.pmdcollab.org/Scripting_Cheat_Sheet
- Système d'enjeu de donjon (perte d'objets/argent selon le stake) : https://wiki.pmdo.pmdcollab.org/Dungeon_stake

---

## 1. Comprendre le mécanisme attendu (pour cadrer l'audit)

Chaque zone de donjon possède un script `init.lua` avec une fonction `ExitSegment(zone, result, rescue, segmentID, mapID)`, appelée à chaque sortie de segment (y compris une défaite). Sa logique standard (jeu de base) est :

```lua
function [zone].ExitSegment(zone, result, rescue, segmentID, mapID)
    COMMON.ExitDungeonMissionCheck(zone.ID, segmentID)
    if rescue == true then
        COMMON.EndRescue(zone, result, segmentID)
    elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
        -- cas défaite / fuite / timeout : retour au dernier checkpoint
        COMMON.EndDungeonDay(result, SV.checkpoint.Zone, SV.checkpoint.Segment, SV.checkpoint.Map, SV.checkpoint.Entry)
    else
        -- cas donjon terminé avec succès : logique propre à chaque donjon
        ...
    end
end
```

Le point central : **`SV.checkpoint.Zone`, `SV.checkpoint.Segment`, `SV.checkpoint.Map`, `SV.checkpoint.Entry`** sont les variables qui déterminent où le joueur atterrit après une défaite. Si l'une de ces valeurs pointe vers une zone/segment/map/marker qui **n'existe pas, a été renommé sans mise à jour de la référence, ou n'a jamais été initialisée pour ce donjon**, le jeu tente de charger une destination invalide → c'est la cause la plus probable de l'écran noir observé sur Vast Steppe.

---

## 2. Périmètre de l'audit — TOUS les donjons, pas seulement Vast Steppe

Pour chaque donjon de New Era (ceux déjà en jeu + relais/midpoints/boss traités dans les audits précédents : `vast_steppe_*`, `mount_windswept_*`, `searing_tunnel_*`, `searing_crucible`, `gloomy_forest_*`, `cloven_ruins_*`, `crystal_sanctuary_*`, `forgotten_marsh_*`, `celestial_peak_*`, et tout autre donjon du chapitre 5 en cours), vérifier :

1. Le fichier `init.lua` de la zone contient bien une fonction `ExitSegment` complète, avec la branche `result ~= Cleared` correctement présente (pas de branche manquante ou vide qui laisserait le jeu "en suspens" sur écran noir).
2. `SV.checkpoint.Zone`, `SV.checkpoint.Segment`, `SV.checkpoint.Map`, `SV.checkpoint.Entry` sont **initialisés à l'entrée du donjon** (au premier segment) avec des valeurs valides pointant vers l'entrance réelle du donjon concerné.
3. Chaque **relais/midpoint** du donjon (déjà cloné/audité dans les prompts précédents) **met à jour ces mêmes variables de checkpoint** au moment où le joueur l'atteint — sinon, mourir après un midpoint renverra quand même à l'entrance d'origine au lieu du midpoint, ce qui est un bug de progression même sans écran noir.
4. Les valeurs de `Zone`/`Map`/`Entry` référencées correspondent à des Grounds et des markers **qui existent réellement** dans les fichiers actuels du mod — en particulier après tous les renommages effectués lors du clonage depuis ProjectEoN/ZMDO/Halcyon/moteur de base (sections précédentes). Un renommage de Ground sans mise à jour de la référence de checkpoint est la cause la plus probable d'écran noir.
5. `COMMON.EndDungeonDay(...)` est bien appelé avec les 4 paramètres dans le bon ordre (Zone, Segment, Map, Entry) — une inversion de paramètres provoque aussi une destination invalide silencieuse.

---

## 3. Cas spécifique à corriger immédiatement : Vast Steppe

1. Ouvrir `Data/Script/halcyon/zone/vast_steppe/init.lua` (ou chemin équivalent selon la structure réelle du mod) et vérifier la fonction `ExitSegment`.
2. Confirmer que la branche défaite appelle bien `COMMON.EndDungeonDay` avec des valeurs de `SV.checkpoint` valides.
3. Vérifier si `vast_steppe_midpoint` (déjà audité dans un prompt précédent) met à jour `SV.checkpoint` lors de son passage — si le joueur meurt après le midpoint, il doit revenir au midpoint, pas à l'entrance d'origine, et inversement s'il meurt avant.
4. Confirmer que la destination `SV.checkpoint` par défaut (avant tout midpoint) pointe vers l'entrance réelle et actuelle de Vast Steppe (pas vers un nom de Ground obsolète issu d'un renommage antérieur).
5. **Tester en conditions réelles en mode dev** (voir prompt précédent, section installation + mode dev) : entrer dans Vast Steppe, se faire volontairement tuer (ou utiliser un outil du panneau Dev pour se mettre à 0 PV), et confirmer que le retour se fait bien à l'entrance/au checkpoint attendu, sans écran noir.

---

## 4. Méthode d'exécution pour l'ensemble du périmètre

1. Lister tous les donjons/segments du périmètre (section 2).
2. Pour chacun, appliquer les 5 vérifications de la section 2.
3. Corriger immédiatement tout `SV.checkpoint` invalide, toute référence obsolète, ou toute branche `ExitSegment` incomplète — ne pas se contenter de signaler pour une passe future (même consigne que les audits précédents : audit + correctif dans la même passe).
4. Tester chaque correction en mode dev réel (mort volontaire ou mise à 0 PV via le panneau Dev), pas seulement en lecture de code.
5. Documenter chaque donjon audité dans le tableau de suivi global existant.

---

## 5. Fiche de validation "logique de mort / retour de segment"

```
Donjon/zone : [nom]
ExitSegment présent et complet (branche défaite incluse) : oui/non
SV.checkpoint initialisé à l'entrée du donjon avec valeurs valides : oui/non
Checkpoint mis à jour par chaque midpoint/relais du donjon : oui/non
Références Zone/Map/Entry pointent vers des Grounds/markers existants (post-renommage) : oui/non
Test réel en mode dev (mort volontaire) : résultat obtenu = entrance/checkpoint attendu, sans écran noir : oui/non
Verdict : OK / à corriger — détail du correctif appliqué
```

À ajouter au tableau de suivi global du projet, avec une colonne dédiée "logique de mort validée : oui/non" pour chaque Ground/donjon déjà traité dans les audits précédents.
