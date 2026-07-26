--[[ Crystal Sanctuary Boss — Diancie ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
local crystal_sanctuary_boss = {}
function crystal_sanctuary_boss.Init(map) DEBUG.EnableDbgCoro() end
function crystal_sanctuary_boss.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(40)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSB_001']))
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  local flash = RogueEssence.Content.FlashEmitter()
  flash.FadeInTime = 4; flash.HoldTime = 6; flash.FadeOutTime = 20
  flash.StartColor = Color(255, 220, 240, 0)
  flash.Layer = DrawLayer.Top
  flash.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(flash, 156, 140)
  GAME:WaitFrames(30)
  local diancie = CharacterEssentials.MakeCharactersFromList({{'Diancie', 156, 140, Direction.Down}})
  UI:SetSpeaker(diancie)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSB_002']))
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSB_003']))
  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("crystal_sanctuary", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end
function crystal_sanctuary_boss.Update(map, time) end
function crystal_sanctuary_boss.GameSave(map) end
function crystal_sanctuary_boss.GameLoad(map) end
return crystal_sanctuary_boss