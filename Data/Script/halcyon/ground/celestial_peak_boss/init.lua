--[[ Celestial Peak Boss — Lugia ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
local celestial_peak_boss = {}
function celestial_peak_boss.Init(map) DEBUG.EnableDbgCoro() end
function celestial_peak_boss.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(60)
  GAME:WaitFrames(40)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_001']))
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  local flash = RogueEssence.Content.FlashEmitter()
  flash.FadeInTime = 6; flash.HoldTime = 8; flash.FadeOutTime = 30
  flash.StartColor = Color(200, 220, 255, 0)
  flash.Layer = DrawLayer.Top
  flash.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(flash, 156, 120)
  GAME:WaitFrames(40)
  local lugia = CharacterEssentials.MakeCharactersFromList({{'Lugia', 156, 100, Direction.Down}})
  GROUND:TeleportTo(lugia, 156, 100, Direction.Down)
  GROUND:MoveInDirection(lugia, Direction.Down, 40, 20)
  GAME:WaitFrames(30)
  UI:SetSpeaker(lugia)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_002']))
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_003']))
  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("celestial_peak", 5, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end
function celestial_peak_boss.Update(map, time) end
function celestial_peak_boss.GameSave(map) end
function celestial_peak_boss.GameLoad(map) end
return celestial_peak_boss