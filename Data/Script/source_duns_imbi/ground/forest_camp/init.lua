require 'origin.common'

local forest_camp_resource_pack = {}

local base_junc = CURMAPSCR.North_Exit_Touch

function forest_camp_resource_pack.North_Exit_Touch(obj, activator)
	DEBUG.EnableDbgCoro() --Enable debugging this coroutine
	 
	GAME:UnlockDungeon('gourmet_jungle')
  local dungeon_entrances = { 'faded_trail', 'bramble_woods', 'trickster_woods', 'overgrown_wilds', 'moonlit_courtyard', 'ambush_forest', 'tiny_tunnel', 'energy_garden', 'sickly_hollow', 'secret_garden', 'gourmet_jungle'}
  local ground_entrances = {{Flag=SV.cliff_camp.ExpositionComplete,Zone='guildmaster_island',ID=4,Entry=0},
  {Flag=SV.canyon_camp.ExpositionComplete,Zone='guildmaster_island',ID=5,Entry=0},
  {Flag=SV.rest_stop.ExpositionComplete,Zone='guildmaster_island',ID=6,Entry=0},
  {Flag=SV.final_stop.ExpositionComplete,Zone='guildmaster_island',ID=7,Entry=0},
  {Flag=SV.guildmaster_summit.GameComplete,Zone='guildmaster_island',ID=8,Entry=0}}
  COMMON.ShowDestinationMenu(dungeon_entrances,ground_entrances)
end

return forest_camp_resource_pack