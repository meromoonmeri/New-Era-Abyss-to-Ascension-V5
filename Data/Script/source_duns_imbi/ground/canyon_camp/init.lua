require 'origin.common'

local canyon_camp_resource_pack = {}
local base_junc = CURMAPSCR.East_Exit_Touch

function canyon_camp_resource_pack.East_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:UnlockDungeon('ashen_geode')
  local dungeon_entrances = { 'copper_quarry', 'depleted_basin', 'forsaken_desert', 'relic_tower', 'sleeping_caldera', 'royal_halls', 'starfall_heights', 'wisdom_road', 'sacred_tower', 'ashen_geode'}
  local ground_entrances = {{Flag=SV.rest_stop.ExpositionComplete,Zone='guildmaster_island',ID=6,Entry=0},
  {Flag=SV.final_stop.ExpositionComplete,Zone='guildmaster_island',ID=7,Entry=0},
  {Flag=SV.guildmaster_summit.GameComplete,Zone='guildmaster_island',ID=8,Entry=0}}
  COMMON.ShowDestinationMenu(dungeon_entrances,ground_entrances)
end

return canyon_camp_resource_pack