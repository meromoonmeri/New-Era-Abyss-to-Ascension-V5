--[[
    metano_town_ch_10.lua
    Chapitre 10 : Pic Celeste — Lugia, Escouade Fulgur, vision Necrozma
    ENRICHI (587->1500+ lignes)
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.npc_routines'

metano_town_ch_10 = {}

local function Ch10State()
    if SV.Chapter10.SawNecrozmaVision then return "post_vision"
    elseif SV.Chapter10.DefeatedLugia then return "post_boss"
    elseif SV.Chapter10.OutranEscouadeFulgur or SV.Chapter10.FulgurReachedSummitFirst then return "post_fulgur"
    elseif SV.Chapter10.ReachedCloudRelay then return "post_relay"
    elseif SV.Chapter10.MissionAccepted then return "during"
    elseif SV.Chapter10.PeakAddressGiven then return "pre"
    else return "early"
    end
end

function metano_town_ch_10.SetupGround()
    GROUND:Hide('Swap_Owner'); GROUND:Hide('Swap')
    NPCRoutines.SetupChapter8Ground()
    GAME:FadeIn(20)
end

function metano_town_ch_10.Noctowl_Action(chara, activator)
    local s = Ch10State()
    if s == "early" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_001']))
        UI:SetSpeakerEmotion("Normal"); UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_004']))
        UI:SetSpeakerEmotion("Worried"); UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_005']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_006']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_007']))
        UI:SetSpeakerEmotion("Normal"); UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_008']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_009']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_010']))
        UI:SetSpeakerEmotion("Shock"); UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_011']))
        UI:SetSpeakerEmotion("Determined"); UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_012']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_013']))
        UI:SetSpeakerEmotion("Normal"); UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_014']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Noctowl_015']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Tropius_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Tropius_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Tropius_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Tropius_003']))
        if SV.Chapter10.OutranEscouadeFulgur then
            UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Tropius_004']))
        end
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Tropius_005']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Tropius_006']), "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Audino_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Audino_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Audino_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Audino_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Audino_004']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Audino_005']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Audino_006']), "Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Audino_007']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Audino_008']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Snubbull_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Snubbull_001']), "Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Snubbull_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Snubbull_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_fulgur" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Snubbull_004']), "Shock")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Snubbull_005']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Snubbull_006']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Zigzagoon_Action(chara, activator)
    local s = Ch10State()
    if s == "post_fulgur" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Zigzagoon_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Zigzagoon_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "during" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Zigzagoon_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Zigzagoon_004']), "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Relicanth_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Relicanth_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Relicanth_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Relicanth_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Relicanth_004']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Relicanth_005']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Relicanth_006']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Bisharp_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Bisharp_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Bisharp_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Bisharp_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Bisharp_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Ledian_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Ledian_001']), "Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Ledian_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Ledian_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Ledian_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Luxray_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Luxray_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Luxray_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Luxray_003']), "Determined")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Luxray_004']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_fulgur" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Luxray_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Luxray_006']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Electrike_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Electrike_001']), "Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Electrike_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Electrike_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Electrike_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Manectric_Action(chara, activator)
    if Ch10State() == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Manectric_001']), "Normal")
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Manectric_002']), "Normal")
    end
    GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_10.Machamp_Action(chara, activator)
    local s = Ch10State()
    if s == "post_fulgur" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Machamp_001']), "Joyous")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Machamp_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Machamp_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Machamp_004']), "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Medicham_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Medicham_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Medicham_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Medicham_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Medicham_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Meditite_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Meditite_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Meditite_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Meditite_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Meditite_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Nidoqueen_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Nidoqueen_001']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Nidoqueen_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Nidoqueen_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Nidoking_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Nidoking_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Nidoking_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Nidoking_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Nidorina_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Nidorina_001']), "Determined")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Nidorina_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Nidorina_003']), "Sad")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Nidoran_Male_Action(chara, activator)
    if Ch10State() == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_NidoranM_001']), "Normal")
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_NidoranM_002']), "Normal")
    end
    GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_10.Numel_Action(chara, activator)
    if Ch10State() == "post_fulgur" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Numel_001']), "Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Numel_002']))
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Numel_003']), "Determined")
    end
    GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_10.Camerupt_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Camerupt_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Camerupt_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Camerupt_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Floatzel_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Floatzel_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Floatzel_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Floatzel_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_10.Quagsire_Action(chara, activator)
    if Ch10State() == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Quagsire_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Quagsire_002']))
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Quagsire_003']), "Normal")
    end
    GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_10.Mawile_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Mawile_001']), "Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Mawile_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Mawile_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_fulgur" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Mawile_004']), "Inspired")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Mawile_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Remaining NPCs with compact enrichened dialogues
function metano_town_ch_10.Vileplume_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Vileplume_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Bellossom_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Bellossom_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Gloom_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Gloom_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Oddish_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Oddish_001']), "Determined")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Furret_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Furret_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Linoone_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Linoone_001']), "Normal")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Sentret_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Sentret_001']), "Inspired")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Wooper_Girl_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_WooperG_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Wooper_Boy_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_WooperB_001']), "Normal")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Gulpin_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Gulpin_001']), "Normal")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Lickitung_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Lickitung_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Spinda_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Spinda_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Ludicolo_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Ludicolo_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Azumarill_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Azumarill_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Roselia_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Roselia_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Jigglypuff_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Jigglypuff_001']), "Normal")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Marill_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Marill_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Spheal_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Spheal_001']), "Normal")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Bagon_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Bagon_001']), "Inspired")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Doduo_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Doduo_001']), "Normal")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Metapod_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Metapod_001']), "Normal")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Silcoon_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Silcoon_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Mareep_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Mareep_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Cranidos_Action(chara, activator)
    local s = Ch10State()
    if s == "post_fulgur" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Cranidos_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Cranidos_002']))
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Cranidos_003']), "Determined")
    end
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Butterfree_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Butterfree_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Venipede_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Venipede_001']), "Determined")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Adagio_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Adagio_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Adagio_002']))
    elseif s == "post_fulgur" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Adagio_003']), "Normal")
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Adagio_004']), "Normal")
    end
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Aria_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Aria_001']), "Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Aria_002']))
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Aria_003']), "Inspired")
    end
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Sonata_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Sonata_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end
function metano_town_ch_10.Growlithe_Desk_Action(chara, activator)
    local s = Ch10State()
    if s == "post_vision" then
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Growlithe_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT10_Growlithe_002']))
    else
        GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT10_Growlithe_003']), "Determined")
    end
    GeneralFunctions.EndConversation(chara)
end

return metano_town_ch_10
