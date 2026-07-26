--[[ Forgotten Marsh Relay ]]
require 'origin.common'
local forgotten_marsh_relay = {}
function forgotten_marsh_relay.Init(map) DEBUG.EnableDbgCoro() end
function forgotten_marsh_relay.Enter(map)
  DEBUG.EnableDbgCoro()
  SV.checkpoint.Zone = "master_zone"
  SV.checkpoint.Segment = -1
  SV.checkpoint.Map = 70
  SV.checkpoint.Entry = 0
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FMR_001']))
  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FMR_002']))
end
function forgotten_marsh_relay.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo("Continuer vers les Abysses Vaseux ?", true); UI:WaitForChoice()
  if UI:ChoiceResult() then
    GAME:FadeOut(false, 60)
    SV.checkpoint.Zone = "master_zone"; SV.checkpoint.Segment = -1; SV.checkpoint.Map = 70; SV.checkpoint.Entry = 0
    GAME:EnterDungeon("forgotten_marsh", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end
function forgotten_marsh_relay.Update(map, time) end
function forgotten_marsh_relay.GameSave(map) end
function forgotten_marsh_relay.GameLoad(map) GAME:FadeIn(20) end
return forgotten_marsh_relay
