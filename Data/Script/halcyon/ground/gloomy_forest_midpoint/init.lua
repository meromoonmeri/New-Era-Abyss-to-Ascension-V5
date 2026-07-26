--[[
    init.lua
    Gloomy Forest midpoint — mid-dungeon relay (checkpoint) for chapter 6.
    Modeled on ground/crooked_cavern_midpoint/init.lua (itself modeled on searing_tunnel_midpoint).
    See docs/audit_checkpoint_crooked_cavern.md (reusable pattern).
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.ground.gloomy_forest_midpoint.gloomy_forest_midpoint_ch_6'

local gloomy_forest_midpoint = {}

-------------------------------
-- Map Callbacks
-------------------------------
function gloomy_forest_midpoint.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_gloomy_forest_midpoint <<=') 
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function gloomy_forest_midpoint.Enter(map)
	if SV.Chapter5.PlayedMidpointIntro == nil then SV.Chapter5.PlayedMidpointIntro = false end
  gloomy_forest_midpoint.PlotScripting()
end

function gloomy_forest_midpoint.Exit(map)
end

function gloomy_forest_midpoint.Update(map)
end

function gloomy_forest_midpoint.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function gloomy_forest_midpoint.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  gloomy_forest_midpoint.PlotScripting()
end

function gloomy_forest_midpoint.PlotScripting()
  if SV.ChapterProgression.Chapter == 6 then
    if not SV.Chapter6.GloomyPlayedMidpointIntro then
      gloomy_forest_midpoint_ch_6.FirstArrival()
    elseif SV.GloomyForest.DiedPastCheckpoint then
      gloomy_forest_midpoint_ch_6.WipedCutscene()
    else
      gloomy_forest_midpoint_ch_6.SetupGround()
    end
  else
    GAME:FadeIn(20)
  end
end

------------------------------- 
-- Entities Callbacks
-------------------------------
-- Forward exit (the ONLY way out). Continues into segment 1 (depth floors).
-- No backward exit (spec: no return to the first half). Leaving the run entirely
-- is done via the Kangaskhan Rock's "Sauvegarder et quitter." option.
function gloomy_forest_midpoint.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Souhaitez-vous continuer vers les profondeurs de la forêt ?", true)
  UI:WaitForChoice()
  local yesnoResult = UI:ChoiceResult()
  UI:SetCenter(false)
  if yesnoResult then
    gloomy_forest_midpoint_ch_6.ContinueScene()
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

-- Kangaskhan Rock: save + storage. Reuses the shared, already-French handler.
function gloomy_forest_midpoint.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

-- Partner dialogue.
function gloomy_forest_midpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  gloomy_forest_midpoint_ch_6.Partner_Action(chara, activator)
end

return gloomy_forest_midpoint
