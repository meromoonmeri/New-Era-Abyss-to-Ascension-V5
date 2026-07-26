--[[ Celestial Peak — Escouade Fulgur ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
local celestial_peak_fulgur = {}
function celestial_peak_fulgur.Init(map) DEBUG.EnableDbgCoro() end
function celestial_peak_fulgur.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(40)
  SOUND:PlayBGM("Boss Battle!.ogg", false)
  local luxray = CharacterEssentials.MakeCharactersFromList({{'Luxray', 120, 140, Direction.Down}})
  local lucario = CharacterEssentials.MakeCharactersFromList({{'Lucario', 156, 140, Direction.Down}})
  local heliolisk = CharacterEssentials.MakeCharactersFromList({{'Heliolisk', 192, 140, Direction.Down}})
  UI:SetSpeaker(luxray)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPF_001']))
  UI:SetSpeaker(lucario)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPF_002']))
  UI:SetSpeaker(heliolisk)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPF_003']))
  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("celestial_peak", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end
function celestial_peak_fulgur.Update(map, time) end
function celestial_peak_fulgur.GameSave(map) end
function celestial_peak_fulgur.GameLoad(map) end
return celestial_peak_fulgur