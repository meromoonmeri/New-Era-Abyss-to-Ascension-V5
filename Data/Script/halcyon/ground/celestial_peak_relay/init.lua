--[[ Celestial Peak Relay ]]
require 'origin.common'
local celestial_peak_relay = {}
function celestial_peak_relay.Init(map) DEBUG.EnableDbgCoro() end
function celestial_peak_relay.Enter(map)
  DEBUG.EnableDbgCoro()
  SV.checkpoint.Zone = "master_zone"
  SV.checkpoint.Segment = -1
  SV.checkpoint.Map = 72
  SV.checkpoint.Entry = 0
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPR_001']))
  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPR_002']))
end
function celestial_peak_relay.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo("Continuer vers la Mer de Nuages ?", true); UI:WaitForChoice()
  if UI:ChoiceResult() then
    GAME:FadeOut(false, 60)
    SV.checkpoint.Zone = "master_zone"; SV.checkpoint.Segment = -1; SV.checkpoint.Map = 72; SV.checkpoint.Entry = 0
    GAME:EnterDungeon("celestial_peak", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end
function celestial_peak_relay.Update(map, time) end
function celestial_peak_relay.GameSave(map) end
function celestial_peak_relay.GameLoad(map) GAME:FadeIn(20) end
return celestial_peak_relay
