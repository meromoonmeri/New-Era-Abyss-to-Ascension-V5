--[[ Forgotten Marsh Boss ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
local forgotten_marsh_boss = {}
function forgotten_marsh_boss.Init(map) DEBUG.EnableDbgCoro() end
function forgotten_marsh_boss.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(40)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FMB_001']))
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  local flash = RogueEssence.Content.FlashEmitter()
  flash.FadeInTime = 4; flash.HoldTime = 6; flash.FadeOutTime = 20
  flash.StartColor = Color(150, 200, 100, 0)
  flash.Layer = DrawLayer.Top
  flash.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(flash, 156, 140)
  GAME:WaitFrames(30)
  local boss = CharacterEssentials.MakeCharactersFromList({{'Swampert', 156, 140, Direction.Down}})
  UI:SetSpeaker(boss)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FMB_002']))
  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("forgotten_marsh", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end
function forgotten_marsh_boss.Update(map, time) end
function forgotten_marsh_boss.GameSave(map) end
function forgotten_marsh_boss.GameLoad(map) end
return forgotten_marsh_boss