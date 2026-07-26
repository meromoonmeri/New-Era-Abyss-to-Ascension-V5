--[[ Crystal Sanctuary Relay ]]
require 'origin.common'
local crystal_sanctuary_relay = {}
function crystal_sanctuary_relay.Init(map) DEBUG.EnableDbgCoro() end
function crystal_sanctuary_relay.Enter(map)
  DEBUG.EnableDbgCoro()
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSR_001']))
  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSR_002']))
end
function crystal_sanctuary_relay.Update(map, time) end
function crystal_sanctuary_relay.GameSave(map) end
function crystal_sanctuary_relay.GameLoad(map) end
return crystal_sanctuary_relay