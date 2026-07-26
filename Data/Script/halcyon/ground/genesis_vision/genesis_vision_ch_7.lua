--[[
    genesis_vision_ch_7.lua
    Cinematique de la Genese — narration de Phileas
    Format flipbook 5 actes / 64 frames / ~4 min
    Declencheur : Phileas au 3e etage de la guilde (Chapitre 7)
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

genesis_vision_ch_7 = {}

-- Montre une planche avec narration voiceover et mouvements de camera
local function ShowAct(mapStrings, voiceKey1, voiceKey2, voiceKey3, voiceKey4, 
                       bgName, duration, camFn, spriteFn)
    -- Changer le fond
    UI:WaitShowBG(bgName, duration, 20)
    
    -- Narration sans boite de dialogue (voiceover)
    if voiceKey1 then
        UI:WaitShowVoiceOver(STRINGS:Format((mapStrings or STRINGS.MapStrings)[voiceKey1]), -1)
    end
    if voiceKey2 then
        GAME:WaitFrames(20)
        UI:WaitShowVoiceOver(STRINGS:Format((mapStrings or STRINGS.MapStrings)[voiceKey2]), -1)
    end
    if voiceKey3 then
        GAME:WaitFrames(20)
        UI:WaitShowVoiceOver(STRINGS:Format((mapStrings or STRINGS.MapStrings)[voiceKey3]), -1)
    end
    if voiceKey4 then
        GAME:WaitFrames(20)
        UI:WaitShowVoiceOver(STRINGS:Format((mapStrings or STRINGS.MapStrings)[voiceKey4]), -1)
    end
end


function genesis_vision_ch_7.PlayGenesis()
    local hero = CH('PLAYER')
    local partner = CH('Teammate1')
    local phileas = CH('Noctowl')
    
    GAME:CutsceneMode(true)
    if partner then AI:DisableCharacterAI(partner) end
    SOUND:StopBGM()
    GAME:FadeOut(false, 1)
    GAME:WaitFrames(30)
    
    ---------------------------------------------------------------
    -- ACTE 1 — Le monde avant la vie (Genesis_Void, 12 frames, ~40s)
    ---------------------------------------------------------------
    ShowAct(STRINGS.MapStrings, 'GENV_001', 'GENV_002', 'GENV_003', nil,
            'Genesis_Void', 720, 
            function() 
                -- Immobile 12s, puis travelling lateral tres lent
                GAME:WaitFrames(360)
                GAME:MoveCamera(160 + 180, 120, 900, false)
            end, nil)
    
    GAME:WaitFrames(40)
    
    ---------------------------------------------------------------
    -- ACTE 2 — Mew (Genesis_Mew, 16 frames, ~50s)
    ---------------------------------------------------------------
    -- Creation du sprite de Mew
    local mew = CharacterEssentials.MakeCharactersFromList({
        {'Mew', 160, -40, Direction.Down}
    })
    GROUND:Hide('Mew')
    
    ShowAct(STRINGS.MapStrings, 'GENV_004', 'GENV_005', 'GENV_006', 'GENV_007',
            'Genesis_Mew', 900,
            function()
                -- Zoom progressif sur la silhouette
                GAME:WaitFrames(60)
                GAME:MoveCamera(160, 120, 300, false)
            end,
            function()
                -- Mew descend du ciel en flottant
                GAME:WaitFrames(120)
                GROUND:Unhide('Mew')
                GROUND:TeleportTo(mew, 160, 20, Direction.Down)
                GROUND:MoveToPosition(mew, 160, 110, false, 8)
                GROUND:CharSetAnim(mew, "Idle", true)
                -- Twirl au moment exact de "elle a danse"
                GAME:WaitFrames(180)
                GROUND:CharSetAnim(mew, "Twirl", false)
                BossFX.Flash(160, 110, 4, 3, 20)
            end)
    
    GAME:WaitFrames(40)
    
    ---------------------------------------------------------------
    -- ACTE 3 — La diversite du vivant (Genesis_Life, 16 frames, ~60s)
    ---------------------------------------------------------------
    -- 9 silhouettes d'especes (toutes deja dans le projet)
    local species_list = {'Bulbizarre', 'Salameche', 'Carapuce', 'Germignon', 
                          'Hericendre', 'Kaiminus', 'Vipelierre', 'Gruikui', 'Metamorph'}
    local spawned = {}
    
    for i, sp in ipairs(species_list) do
        local sx = 40 + (i-1) * 30
        local sy = 170
        local ch = CharacterEssentials.MakeCharactersFromList({{sp, sx, sy, Direction.Down}})
        GROUND:Hide(ch.EntName)
        table.insert(spawned, ch)
    end
    
    ShowAct(STRINGS.MapStrings, 'GENV_008', 'GENV_009', 'GENV_010', 'GENV_011',
            'Genesis_Life', 1080,
            function()
                -- Dezoom continu a mesure que le monde se remplit
                GAME:WaitFrames(60)
                GAME:MoveCamera(160, 120, 720, false)
            end,
            function()
                -- Les 9 silhouettes apparaissent une a une
                for i, ch in ipairs(spawned) do
                    GAME:WaitFrames(25)
                    GROUND:Unhide(ch.EntName)
                    GeneralFunctions.Hop(ch)
                end
            end)
    
    GAME:WaitFrames(40)
    
    ---------------------------------------------------------------
    -- ACTE 4 — Les Coeurs des Anima (Genesis_Cores, 12 frames, ~50s)
    ---------------------------------------------------------------
    ShowAct(STRINGS.MapStrings, 'GENV_012', 'GENV_013', 'GENV_014', 'GENV_015',
            'Genesis_Cores', 900,
            function()
                -- Mew s'eloigne, la camera la suit
                GAME:WaitFrames(40)
                GROUND:MoveInDirection(mew, Direction.Up, 160, false, 1)
                GAME:MoveCamera(160, 40, 600, false)
            end,
            function()
                -- Cacher Mew quand elle sort du cadre
                GAME:WaitFrames(300)
                GROUND:Hide('Mew')
            end)
    
    GAME:WaitFrames(40)
    
    ---------------------------------------------------------------
    -- ACTE 5 — Retour au present (Genesis_Fade, 8 frames, ~35s)
    ---------------------------------------------------------------
    ShowAct(STRINGS.MapStrings, 'GENV_016', 'GENV_017', 'GENV_018', nil,
            'Genesis_Fade', 640,
            function()
                -- Immobilite totale
            end,
            function()
                -- Cacher tous les sprites restants
                for _, ch in ipairs(spawned) do
                    GROUND:Hide(ch.EntName)
                end
            end)
    
    -- Silence marque — 60 frames sans texte
    GAME:WaitFrames(60)
    
    -- Derniere replique : "Ce qui soutient la vie... peut aussi etre vide."
    UI:WaitShowVoiceOver(STRINGS:Format(STRINGS.MapStrings['GENV_019']), -1)
    
    GAME:WaitFrames(60)
    
    ---------------------------------------------------------------
    -- RETOUR
    ---------------------------------------------------------------
    GAME:FadeOut(false, 120)
    GAME:WaitFrames(120)
    
    SV.Chapter7.HeardGenesisTale = true
    GAME:CutsceneMode(false)
    GAME:EnterGroundMap('guild_third_floor_lobby', 'Main_Entrance_Marker')
end

return genesis_vision_ch_7
