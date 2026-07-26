--[[
    init.lua — Cloven Ruins Entrance
    Chapter 7 — Entree des Ruines Tordues
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
local cloven_ruins_entrance = {}
function cloven_ruins_entrance.Init(map) COMMON.RespawnAllies(); PartnerEssentials.InitializePartnerSpawn() end
function cloven_ruins_entrance.Enter(map) GAME:FadeIn(20) end
function cloven_ruins_entrance.Update(map) end
function cloven_ruins_entrance.GameSave(map) PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end
function cloven_ruins_entrance.GameLoad(map) PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1')); GAME:FadeIn(20) end
function cloven_ruins_entrance.Dungeon_Entrance_Touch(obj, activator)
    UI:ResetSpeaker(false); UI:SetCenter(true)
    local partner = CH('Teammate1'); partner.IsInteracting = true
    GROUND:CharSetAnim(partner, 'None', true); GROUND:CharSetAnim(CH('PLAYER'), 'None', true)
    UI:ChoiceMenuYesNo("Entrer dans les Ruines Tordues ?", true); UI:WaitForChoice()
    if UI:ChoiceResult() then GAME:FadeOut(false, 60); partner.IsInteracting = false
        GROUND:CharEndAnim(partner); GROUND:CharEndAnim(CH('PLAYER'))
        GAME:EnterDungeon("cloven_ruins", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    end
    partner.IsInteracting = false; GROUND:CharEndAnim(partner); GROUND:CharEndAnim(CH('PLAYER'))
end
function cloven_ruins_entrance.Kangaskhan_Rock_Action(obj, activator) GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator) end
function cloven_ruins_entrance.Teammate1_Action(chara, activator) PartnerEssentials.GetPartnerDialogue(CH('Teammate1')) end
return cloven_ruins_entrance
