--[[
    init.lua
    Vast Steppe Midpoint — checkpoint entre la première moitie et la seconde.
    Miroir de searing_tunnel_midpoint/init.lua.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.ground.vast_steppe_midpoint.vast_steppe_midpoint_ch_5'

local vast_steppe_midpoint = {}

function vast_steppe_midpoint.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_vast_steppe_midpoint <<=')
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function vast_steppe_midpoint.Enter(map)
	if SV.Chapter5.PlayedSteppeMidpointIntro == nil then SV.Chapter5.PlayedSteppeMidpointIntro = false end
  vast_steppe_midpoint.PlotScripting()
end

function vast_steppe_midpoint.Update(map)
end

function vast_steppe_midpoint.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function vast_steppe_midpoint.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  vast_steppe_midpoint.PlotScripting()
end

function vast_steppe_midpoint.PlotScripting()
  if SV.ChapterProgression.Chapter == 5 then
    if not SV.Chapter5.PlayedSteppeMidpointIntro then
      vast_steppe_midpoint_ch_5.FirstArrival()
    else
      GAME:FadeIn(20)
    end
  else
    GAME:FadeIn(20)
  end
end

-- North exit : continue deeper into the steppe (segment 2)
function vast_steppe_midpoint.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Souhaitez-vous continuer ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    GAME:EnterDungeon("vast_steppe", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

-- South exit : return to Vast Steppe entrance
function vast_steppe_midpoint.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("vast_steppe")
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Souhaitez-vous revenir\nà l'entrée de " .. zone:GetColoredName() .. " ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SV.adventure.Thief = false
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    GAME:WaitFrames(60)
    GAME:EnterGroundMap("vast_steppe_entrance", "Main_Entrance_Marker")
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

-- Kangaskhan Rock: save + storage
function vast_steppe_midpoint.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function vast_steppe_midpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function vast_steppe_midpoint.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end

function vast_steppe_midpoint.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end

return vast_steppe_midpoint
