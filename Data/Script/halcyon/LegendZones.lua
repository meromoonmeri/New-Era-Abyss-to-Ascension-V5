--[[
    LegendZones.lua
    Zones de recrutement des Pokemon fabuleux et legendaires.

    ------------------------------------------------------------------
    REGLE NARRATIVE (lecture 1, retenue et confirmee)
    ------------------------------------------------------------------
    La regle du projet reste intacte : un legendaire n'apparait JAMAIS en
    rencontre aleatoire. Acheter une zone chez Grodoudou ne fait pas
    apparaitre le legendaire dans la nature et ne le donne pas non plus.

    Elle ouvre une seule chose : le droit de RETOURNER l'affronter, dans
    son propre lieu, une fois que l'histoire l'a deja presente.
    Trois verrous en serie, dans cet ordre :

       1. verrou d'histoire  -> le legendaire doit avoir ete rencontre
                                dans le scenario (champ `flag`).
                                C'est ce qui met la zone EN VENTE.
       2. verrou marchand    -> la zone doit avoir ete achetee
       3. verrou de combat   -> il faut aller le vaincre sur place

    Tant que le verrou 1 n'est pas leve, la zone n'est meme pas proposee :
    Grodoudou n'a "pas encore entendu parler" du lieu. C'est la regle
    demandee : chaque fois qu'on rencontre un legendaire dans l'histoire,
    sa zone devient achetable.

    ------------------------------------------------------------------
    STRUCTURE D'UNE ENTREE
    ------------------------------------------------------------------
      key      identifiant interne, cle dans SV.LegendZones.*
      species  espece PMDO. Les 25 especes listees ici ont ete verifiees
               presentes dans Data/Misc/MonsterFeature.json (1011 entrees).
      name     cle .resx du nom de la zone (EN + FR)
      blurb    cle .resx du boniment de Grodoudou pour cette zone
      sight    cle .resx de la description du lieu (ce qu'on y voit)
      price    prix en Poke (monnaie standard : GAME:GetPlayerMoney)
      flag     fonction -> true si l'histoire a deja presente ce
               legendaire. C'est le verrou 1.
      zone     identifiant de donjon a rejoindre
      segment  segment de ce donjon contenant l'arene de revanche
      roam     true  = le legendaire se deplace dans sa zone une fois
                       vaincu et recrute (comportement errant)
               false = il attend sur place
      ready    true  = la chaine complete existe et est jouable
               false = le chapitre correspondant n'est pas encore ecrit ;
                       l'entree est un contrat pour plus tard et n'est
                       JAMAIS listee en boutique.

    Ne jamais passer `ready = true` sans avoir verifie les trois points :
      (a) le segment existe dans Data/Zone/<zone>.json
      (b) la .rsmap de l'arene existe et son occupant n'est PAS Unrecruitable
      (c) ExitSegment de zone/<zone>/init.lua gere ce numero de segment
]]--

require 'origin.common'

LegendZones = {}

LegendZones.LIST = {
    ------------------------------------------------------------------
    -- JOUABLE AUJOURD'HUI
    ------------------------------------------------------------------
    {
        key = 'verdant_oath', species = 'zarude',
        name = 'LZ_Name_Verdant_Oath', blurb = 'LZ_Blurb_Verdant_Oath',
        sight = 'LZ_Sight_Verdant_Oath', price = 15000,
        -- Pose par zone/gloomy_forest/init.lua (segment 2, victoire).
        flag = function() return SV.Chapter6 ~= nil and SV.Chapter6.DefeatedGloomyBoss == true end,
        zone = 'gloomy_forest', segment = 3, roam = true, ready = true
    },

    ------------------------------------------------------------------
    -- CONTRATS EN ATTENTE — chapitres a venir.
    -- Nom, prix et identite visuelle deja arretes : l'ecriture du
    -- chapitre n'aura plus qu'a poser le flag, le segment et ready.
    ------------------------------------------------------------------
    {
        key = 'colossus_quarry', species = 'regigigas',
        name = 'LZ_Name_Colossus_Quarry', blurb = 'LZ_Blurb_Colossus_Quarry',
        sight = 'LZ_Sight_Colossus_Quarry', price = 22000,
        flag = function() return SV.Chapter7 ~= nil and SV.Chapter7.DefeatedRuinsBoss == true end,
        zone = 'cloven_ruins', segment = 2, roam = false, ready = false
    },
    {
        key = 'spatial_hill', species = 'palkia',
        name = 'LZ_Name_Spatial_Hill', blurb = 'LZ_Blurb_Spatial_Hill',
        sight = 'LZ_Sight_Spatial_Hill', price = 38000,
        flag = function() return false end,
        zone = '', segment = -1, roam = true, ready = false
    },
    {
        key = 'hour_that_lags', species = 'dialga',
        name = 'LZ_Name_Hour_That_Lags', blurb = 'LZ_Blurb_Hour_That_Lags',
        sight = 'LZ_Sight_Hour_That_Lags', price = 38000,
        flag = function() return false end,
        zone = '', segment = -1, roam = false, ready = false
    },
    {
        key = 'reverse_slope', species = 'giratina',
        name = 'LZ_Name_Reverse_Slope', blurb = 'LZ_Blurb_Reverse_Slope',
        sight = 'LZ_Sight_Reverse_Slope', price = 42000,
        flag = function() return false end,
        zone = '', segment = -1, roam = true, ready = false
    },
    {
        key = 'dead_hours', species = 'celebi',
        name = 'LZ_Name_Dead_Hours', blurb = 'LZ_Blurb_Dead_Hours',
        sight = 'LZ_Sight_Dead_Hours', price = 25000,
        flag = function() return false end,
        zone = 'relic_forest', segment = -1, roam = true, ready = false
    },
    {
        key = 'clearwater_ford', species = 'suicune',
        name = 'LZ_Name_Clearwater_Ford', blurb = 'LZ_Blurb_Clearwater_Ford',
        sight = 'LZ_Sight_Clearwater_Ford', price = 26000,
        flag = function() return false end,
        zone = 'illuminant_riverbed', segment = -1, roam = true, ready = false
    },
    {
        key = 'ember_vigil', species = 'entei',
        name = 'LZ_Name_Ember_Vigil', blurb = 'LZ_Blurb_Ember_Vigil',
        sight = 'LZ_Sight_Ember_Vigil', price = 26000,
        flag = function() return false end,
        zone = 'searing_tunnel', segment = -1, roam = false, ready = false
    },
    {
        key = 'storm_bell', species = 'raikou',
        name = 'LZ_Name_Storm_Bell', blurb = 'LZ_Blurb_Storm_Bell',
        sight = 'LZ_Sight_Storm_Bell', price = 26000,
        flag = function() return false end,
        zone = 'mount_windswept', segment = -1, roam = true, ready = false
    },
    {
        key = 'soft_sleep', species = 'cresselia',
        name = 'LZ_Name_Soft_Sleep', blurb = 'LZ_Blurb_Soft_Sleep',
        sight = 'LZ_Sight_Soft_Sleep', price = 28000,
        flag = function() return false end,
        zone = '', segment = -1, roam = true, ready = false
    },
    {
        key = 'upturned_dream', species = 'darkrai',
        name = 'LZ_Name_Upturned_Dream', blurb = 'LZ_Blurb_Upturned_Dream',
        sight = 'LZ_Sight_Upturned_Dream', price = 30000,
        flag = function() return false end,
        zone = '', segment = -1, roam = true, ready = false
    },
    {
        key = 'unsaid_wishes', species = 'jirachi',
        name = 'LZ_Name_Unsaid_Wishes', blurb = 'LZ_Blurb_Unsaid_Wishes',
        sight = 'LZ_Sight_Unsaid_Wishes', price = 32000,
        flag = function() return false end,
        zone = '', segment = -1, roam = false, ready = false
    },
    {
        key = 'first_cradle', species = 'mew',
        name = 'LZ_Name_First_Cradle', blurb = 'LZ_Blurb_First_Cradle',
        sight = 'LZ_Sight_First_Cradle', price = 50000,
        flag = function() return false end,
        zone = '', segment = -1, roam = true, ready = false
    },
    {
        key = 'thawed_step', species = 'articuno',
        name = 'LZ_Name_Thawed_Step', blurb = 'LZ_Blurb_Thawed_Step',
        sight = 'LZ_Sight_Thawed_Step', price = 24000,
        flag = function() return false end,
        zone = '', segment = -1, roam = false, ready = false
    },
    {
        key = 'high_conductor', species = 'zapdos',
        name = 'LZ_Name_High_Conductor', blurb = 'LZ_Blurb_High_Conductor',
        sight = 'LZ_Sight_High_Conductor', price = 24000,
        flag = function() return false end,
        zone = '', segment = -1, roam = false, ready = false
    },
    {
        key = 'long_ash', species = 'moltres',
        name = 'LZ_Name_Long_Ash', blurb = 'LZ_Blurb_Long_Ash',
        sight = 'LZ_Sight_Long_Ash', price = 24000,
        flag = function() return false end,
        zone = '', segment = -1, roam = false, ready = false
    },
    {
        key = 'quiet_ledger', species = 'uxie',
        name = 'LZ_Name_Quiet_Ledger', blurb = 'LZ_Blurb_Quiet_Ledger',
        sight = 'LZ_Sight_Quiet_Ledger', price = 27000,
        flag = function() return false end,
        zone = '', segment = -1, roam = false, ready = false
    },
    {
        key = 'kept_feeling', species = 'mesprit',
        name = 'LZ_Name_Kept_Feeling', blurb = 'LZ_Blurb_Kept_Feeling',
        sight = 'LZ_Sight_Kept_Feeling', price = 27000,
        flag = function() return false end,
        zone = '', segment = -1, roam = true, ready = false
    },
    {
        key = 'last_resolve', species = 'azelf',
        name = 'LZ_Name_Last_Resolve', blurb = 'LZ_Blurb_Last_Resolve',
        sight = 'LZ_Sight_Last_Resolve', price = 27000,
        flag = function() return false end,
        zone = '', segment = -1, roam = false, ready = false
    },
    {
        key = 'sunken_choir', species = 'lugia',
        name = 'LZ_Name_Sunken_Choir', blurb = 'LZ_Blurb_Sunken_Choir',
        sight = 'LZ_Sight_Sunken_Choir', price = 36000,
        flag = function() return false end,
        zone = '', segment = -1, roam = false, ready = false
    },
    {
        key = 'rainbow_ash', species = 'ho_oh',
        name = 'LZ_Name_Rainbow_Ash', blurb = 'LZ_Blurb_Rainbow_Ash',
        sight = 'LZ_Sight_Rainbow_Ash', price = 36000,
        flag = function() return false end,
        zone = '', segment = -1, roam = false, ready = false
    },
    {
        key = 'stone_argument', species = 'terrakion',
        name = 'LZ_Name_Stone_Argument', blurb = 'LZ_Blurb_Stone_Argument',
        sight = 'LZ_Sight_Stone_Argument', price = 25000,
        flag = function() return false end,
        zone = '', segment = -1, roam = false, ready = false
    },
    {
        key = 'ninth_summit', species = 'rayquaza',
        name = 'LZ_Name_Ninth_Summit', blurb = 'LZ_Blurb_Ninth_Summit',
        sight = 'LZ_Sight_Ninth_Summit', price = 45000,
        flag = function() return false end,
        zone = '', segment = -1, roam = false, ready = false
    },
    {
        key = 'borrowed_light', species = 'necrozma',
        name = 'LZ_Name_Borrowed_Light', blurb = 'LZ_Blurb_Borrowed_Light',
        sight = 'LZ_Sight_Borrowed_Light', price = 48000,
        flag = function() return false end,
        zone = '', segment = -1, roam = false, ready = false
    },
    {
        key = 'given_life', species = 'xerneas',
        name = 'LZ_Name_Given_Life', blurb = 'LZ_Blurb_Given_Life',
        sight = 'LZ_Sight_Given_Life', price = 44000,
        flag = function() return false end,
        zone = '', segment = -1, roam = false, ready = false
    }
}

--------------------------------------------------------------------
-- Etat de sauvegarde
--------------------------------------------------------------------
-- SV.LegendZones est declare dans scriptvars.lua. Ce garde-fou couvre les
-- sauvegardes creees AVANT l'ajout du systeme : sans lui, toute partie
-- existante planterait a la premiere interaction avec le stand.
function LegendZones.EnsureSV()
    if SV.LegendZones == nil then
        SV.LegendZones = { Purchased = {}, Defeated = {}, MetMerchant = false }
    end
    if SV.LegendZones.Purchased == nil then SV.LegendZones.Purchased = {} end
    if SV.LegendZones.Defeated  == nil then SV.LegendZones.Defeated  = {} end
end

function LegendZones.IsPurchased(key)
    LegendZones.EnsureSV()
    return SV.LegendZones.Purchased[key] == true
end

function LegendZones.SetPurchased(key)
    LegendZones.EnsureSV()
    SV.LegendZones.Purchased[key] = true
end

--Le legendaire a-t-il ete vaincu dans sa zone ?
function LegendZones.IsDefeated(key)
    LegendZones.EnsureSV()
    return SV.LegendZones.Defeated[key] == true
end

function LegendZones.SetDefeated(key)
    LegendZones.EnsureSV()
    SV.LegendZones.Defeated[key] = true
end

function LegendZones.Get(key)
    for _, entry in ipairs(LegendZones.LIST) do
        if entry.key == key then return entry end
    end
    return nil
end

--Verrou 1 : l'histoire a-t-elle deja presente ce legendaire ?
--pcall protege des flags dont la table SV n'existe pas encore.
function LegendZones.StoryUnlocked(entry)
    if entry.ready ~= true then return false end
    local ok, result = pcall(entry.flag)
    return ok and result == true
end

--Zones que Grodoudou peut proposer aujourd'hui.
function LegendZones.GetAvailable()
    local out = {}
    for _, entry in ipairs(LegendZones.LIST) do
        if LegendZones.StoryUnlocked(entry) and not LegendZones.IsPurchased(entry.key) then
            table.insert(out, entry)
        end
    end
    return out
end

--Zones deja achetees : Grodoudou peut y conduire l'equipe.
function LegendZones.GetOwned()
    local out = {}
    for _, entry in ipairs(LegendZones.LIST) do
        if LegendZones.IsPurchased(entry.key) and entry.ready then
            table.insert(out, entry)
        end
    end
    return out
end

function LegendZones.ZoneName(entry)
    return STRINGS:Format(STRINGS.MapStrings[entry.name])
end

--Nom colore de l'espece, tel que le jeu l'affiche partout ailleurs.
function LegendZones.SpeciesName(entry)
    return _DATA:GetMonster(entry.species):GetColoredName()
end

return LegendZones
