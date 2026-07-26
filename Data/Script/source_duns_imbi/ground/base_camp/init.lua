require 'origin.common'

local base_camp_resource_pack = {}

local base_junc = CURMAPSCR.North_Exit_Touch

function base_camp_resource_pack.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:UnlockDungeon('berry_grove')
  local dungeon_entrances = { 'tropical_path', 'faultline_ridge', 'guildmaster_trail', 'berry_grove'}
  local ground_entrances = {{Flag=SV.forest_camp.ExpositionComplete,Zone='guildmaster_island',ID=3,Entry=0},
  {Flag=SV.cliff_camp.ExpositionComplete,Zone='guildmaster_island',ID=4,Entry=0},
  {Flag=SV.canyon_camp.ExpositionComplete,Zone='guildmaster_island',ID=5,Entry=0},
  {Flag=SV.rest_stop.ExpositionComplete,Zone='guildmaster_island',ID=6,Entry=0},
  {Flag=SV.final_stop.ExpositionComplete,Zone='guildmaster_island',ID=7,Entry=0},
  {Flag=SV.guildmaster_summit.GameComplete,Zone='guildmaster_island',ID=8,Entry=0}}
  COMMON.ShowDestinationMenu(dungeon_entrances,ground_entrances)
end

return base_camp_resource_pack