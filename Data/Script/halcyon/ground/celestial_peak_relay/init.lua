--[[ Celestial Peak Relay ]]
require 'origin.common'
local celestial_peak_relay = {}
function celestial_peak_relay.Init(map) DEBUG.EnableDbgCoro() end
function celestial_peak_relay.Enter(map)
  DEBUG.EnableDbgCoro()
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPR_001']))
  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPR_002']))
end
function celestial_peak_relay.Update(map, time) end
function celestial_peak_relay.GameSave(map) end
function celestial_peak_relay.GameLoad(map) end
return celestial_peak_relay