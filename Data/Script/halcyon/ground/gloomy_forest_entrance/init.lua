require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.gloomy_forest_entrance.gloomy_forest_entrance_ch_6'

local gloomy_forest_entrance = {}

function gloomy_forest_entrance.Init(map)
	DEBUG.EnableDbgCoro()
	print('=>> Init_gloomy_forest_entrance <<=')
	COMMON.RespawnAllies()
	PartnerEssentials.InitializePartnerSpawn()
end

function gloomy_forest_entrance.Enter(map)
	gloomy_forest_entrance.PlotScripting()
end

function gloomy_forest_entrance.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	gloomy_forest_entrance.PlotScripting()
end

function gloomy_forest_entrance.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function gloomy_forest_entrance.PlotScripting()
	if SV.ChapterProgression.Chapter == 6 and not SV.Chapter6.FinishedGloomyForestIntro then
		gloomy_forest_entrance_ch_6.ArrivalCutscene()
	else
		gloomy_forest_entrance_ch_6.SetupGround()
		GAME:FadeIn(20)
	end
end

function gloomy_forest_entrance.Teammate1_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function gloomy_forest_entrance.Butterfree_Action(obj, activator)
	DEBUG.EnableDbgCoro()
	gloomy_forest_entrance_ch_6.Butterfree_Action(obj, activator)
end

function gloomy_forest_entrance.Kangaskhan_Rock_Action(obj, activator)
	GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function gloomy_forest_entrance.Dungeon_Entrance_Touch(obj, activator)
	if SV.Chapter6.MissionAccepted and not SV.Chapter6.MissionComplete then
		SV.Chapter6.EnteredGloomyForest = true
		SOUND:FadeOutBGM(40)
		GAME:FadeOut(false, 40)
		SV.checkpoint.Zone = "master_zone"
		SV.checkpoint.Segment = -1
		SV.checkpoint.Map = 51
		SV.checkpoint.Entry = 0
		GAME:EnterDungeon("gloomy_forest", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
	end
end

return gloomy_forest_entrance
