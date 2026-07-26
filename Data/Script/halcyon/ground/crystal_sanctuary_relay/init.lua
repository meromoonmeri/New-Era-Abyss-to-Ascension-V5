--[[ Crystal Sanctuary Relay ]]
require 'origin.common'
local crystal_sanctuary_relay = {}
function crystal_sanctuary_relay.Init(map) DEBUG.EnableDbgCoro() end
function crystal_sanctuary_relay.Enter(map)
  DEBUG.EnableDbgCoro()
  SV.checkpoint.Zone = "master_zone"
  SV.checkpoint.Segment = -1
  SV.checkpoint.Map = 68
  SV.checkpoint.Entry = 0
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSR_001']))
  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSR_002']))
end
function crystal_sanctuary_relay.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo("Continuer vers les Salles des Glyphes ?", true); UI:WaitForChoice()
  if UI:ChoiceResult() then
    GAME:FadeOut(false, 60)
    SV.checkpoint.Zone = "master_zone"; SV.checkpoint.Segment = -1; SV.checkpoint.Map = 68; SV.checkpoint.Entry = 0
    GAME:EnterDungeon("crystal_sanctuary", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end
function crystal_sanctuary_relay.Update(map, time) end
function crystal_sanctuary_relay.GameSave(map) end
function crystal_sanctuary_relay.GameLoad(map) GAME:FadeIn(20) end
return crystal_sanctuary_relay
