--[[
    init.lua
    Cloven Ruins Midpoint — relais / checkpoint du chapitre 7.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'

local cloven_ruins_midpoint = {}

function cloven_ruins_midpoint.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_cloven_ruins_midpoint <<=')
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function cloven_ruins_midpoint.Enter(map)
  SV.checkpoint.Zone = "master_zone"
  SV.checkpoint.Segment = -1
  SV.checkpoint.Map = 66
  SV.checkpoint.Entry = 0
  GAME:FadeIn(20)
end

function cloven_ruins_midpoint.Update(map) end
function cloven_ruins_midpoint.GameSave(map) PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end
function cloven_ruins_midpoint.GameLoad(map) PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1')); GAME:FadeIn(20) end

function cloven_ruins_midpoint.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ChoiceMenuYesNo("Continuer dans les profondeurs des Ruines Tordues ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    GAME:FadeOut(false, 60)
    SV.checkpoint.Zone = "master_zone"
    SV.checkpoint.Segment = -1
    SV.checkpoint.Map = 66
    SV.checkpoint.Entry = 0
    GAME:EnterDungeon("cloven_ruins", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end

function cloven_ruins_midpoint.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ChoiceMenuYesNo("Revenir a l'entree des Ruines Tordues ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    GAME:EnterGroundMap("cloven_ruins_entrance", "Main_Entrance_Marker")
  end
end

function cloven_ruins_midpoint.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function cloven_ruins_midpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function cloven_ruins_midpoint.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end

function cloven_ruins_midpoint.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end

return cloven_ruins_midpoint
