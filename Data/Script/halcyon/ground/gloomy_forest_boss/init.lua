require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.gloomy_forest_boss.gloomy_forest_boss_ch_6'

local gloomy_forest_boss = {}

function gloomy_forest_boss.Init(map)
	DEBUG.EnableDbgCoro()
	print('=>> Init_gloomy_forest_boss <<=')
	COMMON.RespawnAllies(true)
	PartnerEssentials.InitializePartnerSpawn()
end

function gloomy_forest_boss.Enter(map)
	gloomy_forest_boss.PlotScripting()
end

function gloomy_forest_boss.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	gloomy_forest_boss.PlotScripting()
end

function gloomy_forest_boss.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function gloomy_forest_boss.PlotScripting()
	if SV.ChapterProgression.Chapter == 6 and not SV.Chapter6.GloomyBossEncountered then
		gloomy_forest_boss_ch_6.FirstBossScene()
	elseif SV.ChapterProgression.Chapter == 6 and not SV.Chapter6.DefeatedGloomyBoss then
		--Le joueur revient apres avoir perdu contre Zarude : GloomyBossEncountered est
		--deja vrai, donc la premiere scene ne rejouera pas. Sans cette branche la carte
		--n'a aucune sortie et le joueur reste bloque. On relance directement le combat.
		GAME:FadeIn(20)
		GAME:WaitFrames(20)
		COMMON.BossTransition()
		GAME:CutsceneMode(false)
		GAME:ContinueDungeon("gloomy_forest", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
	else
		GAME:FadeIn(20)
	end
end

function gloomy_forest_boss.Teammate1_Action(chara, activator)
	PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function gloomy_forest_boss.Zarude_Action(chara, activator)
	COMMON.GroundInteract(activator, chara, true)
end

return gloomy_forest_boss
