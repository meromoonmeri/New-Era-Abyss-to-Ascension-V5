--[[ Forgotten Marsh Relay ]]
require 'origin.common'
local forgotten_marsh_relay = {}
function forgotten_marsh_relay.Init(map) DEBUG.EnableDbgCoro() end
function forgotten_marsh_relay.Enter(map)
  DEBUG.EnableDbgCoro()
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FMR_001']))
  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FMR_002']))
end
function forgotten_marsh_relay.Update(map, time) end
function forgotten_marsh_relay.GameSave(map) end
function forgotten_marsh_relay.GameLoad(map) end
return forgotten_marsh_relay