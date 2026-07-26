--[[
    init.lua
    Mount Windswept Midpoint — checkpoint entre la première moitie et la seconde.
    Miroir de searing_tunnel_midpoint/init.lua.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.ground.mount_windswept_midpoint.mount_windswept_midpoint_ch_5'

local mount_windswept_midpoint = {}

function mount_windswept_midpoint.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_mount_windswept_midpoint <<=')
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function mount_windswept_midpoint.Enter(map)
	if SV.Chapter5.PlayedMountMidpointIntro == nil then SV.Chapter5.PlayedMountMidpointIntro = false end
  mount_windswept_midpoint.PlotScripting()
end

function mount_windswept_midpoint.Update(map)
end

function mount_windswept_midpoint.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function mount_windswept_midpoint.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  mount_windswept_midpoint.PlotScripting()
end

function mount_windswept_midpoint.PlotScripting()
  if SV.ChapterProgression.Chapter == 5 then
    if not SV.Chapter5.PlayedMountMidpointIntro then
      mount_windswept_midpoint_ch_5.FirstArrival()
    else
      GAME:FadeIn(20)
    end
  else
    GAME:FadeIn(20)
  end
end

-- North exit : continue higher up the mountain (segment 2)
function mount_windswept_midpoint.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Souhaitez-vous continuer l'ascension ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    GAME:EnterDungeon("mount_windswept", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

-- South exit : return to Mount Windswept entrance
function mount_windswept_midpoint.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("mount_windswept")
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Souhaitez-vous redescendre\nà l'entrée de " .. zone:GetColoredName() .. " ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SV.adventure.Thief = false
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    GAME:WaitFrames(60)
    GAME:EnterGroundMap("mount_windswept_entrance", "Main_Entrance_Marker")
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

-- Kangaskhan Rock: save + storage
function mount_windswept_midpoint.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function mount_windswept_midpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function mount_windswept_midpoint.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end

function mount_windswept_midpoint.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end

return mount_windswept_midpoint
