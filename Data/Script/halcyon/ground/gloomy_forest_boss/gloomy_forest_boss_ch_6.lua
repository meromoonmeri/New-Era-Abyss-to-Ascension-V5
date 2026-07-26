--[[
    gloomy_forest_boss_ch_6.lua
    Coeur de la Foret Lugubre — apparition de Zarude (Tenebres / Plante).

    Mise en scene propre au type, comme pour les boss du chapitre 5 :
      1. la foret se tait, l'ombre s'epaissit
      2. la Voix de l'Abysse parle AVANT toute apparition
      3. flash blanc
      4. Zarude sort de l'ombre en ecartant les lianes (signature Tenebres/Plante)
      5. le souffle repousse le heros, le partenaire et les allies presents
      6. dialogue, puis combat
]]--

require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

gloomy_forest_boss_ch_6 = {}

function gloomy_forest_boss_ch_6.FirstBossScene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GAME:MoveCamera(276, 232, 1, false)
	GAME:FadeOut(false, 1)
	GROUND:TeleportTo(hero, 276, 416, Direction.Up)
	GROUND:TeleportTo(partner, 308, 416, Direction.Up)
	GAME:FadeIn(40)
	SOUND:PlayBGM('Mystifying Forest.ogg', true)

	-- L'equipe s'avance au coeur de la clairiere
	local coro1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(hero, 276, 288, false, 1)
		GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	end)
	local coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:MoveToPosition(partner, 308, 288, false, 1)
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_001']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_002']))

	UI:SetSpeaker(hero)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_003']))

	-- === LA FORET SE TAIT, L'OMBRE S'EPAISSIT ===
	SOUND:FadeOutBGM(60)
	GAME:WaitFrames(40)
	BossFX.Overlay("Fog_2", 0, 0, 30, 110, 30, DrawLayer.Bottom, -1, 0)
	SOUND:PlayBattleSE("DUN_Tall_Grass")
	GAME:WaitFrames(20)

	-- Le duo remarque que quelque chose ne va pas
	local c1 = TASK:BranchCoroutine(function()
		GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	end)
	local c2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GeneralFunctions.EmoteAndPause(hero, "Sweatdrop", false)
	end)
	TASK:JoinCoroutines({c1, c2})

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_011']))

	-- Le sol vibre, les lianes fremissent
	BossFX.Rumble({ hero, partner }, 2)
	BossFX.Particle("Grass_Whistle", 276, 240, 4)
	GAME:WaitFrames(20)

	-- === LA VOIX DE L'ABYSSE PARLE AVANT TOUTE APPARITION ===
	BossFX.Voice('GF6B_012')
	GAME:WaitFrames(20)
	BossFX.Voice('GF6B_013')
	GAME:WaitFrames(24)

	-- === FLASH BLANC ===
	BossFX.Flash(276, 220)
	GAME:WaitFrames(12)

	-- === ZARUDE SORT DE L'OMBRE EN ECARTANT LES LIANES ===
	-- Signature Tenebres/Plante : nappe d'ombre, lianes qui s'ecartent,
	-- pulsation sombre. Aucune apparition neutre.
	local zarude = CharacterEssentials.MakeCharactersFromList({
		{'Zarude', 276, 208, Direction.Down}
	})
	GROUND:Hide('Zarude')
	AI:DisableCharacterAI(zarude)
	BossFX.EmergeShadow(zarude, 276, 208)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")

	-- Le souffle repousse toute l'equipe
	BossFX.Impact(11)
	SOUND:PlayBGM('Rising Fear.ogg', true)

	GAME:WaitFrames(16)
	GROUND:CharSetEmote(zarude, "notice", 1)
	GAME:MoveCamera(276, 208, 20, false)
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_004']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_005']))

	UI:SetSpeaker(zarude)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_006']))
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Angry")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_007']))
	UI:SetSpeaker(hero)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_008']))

	-- Zarude entre en fureur : lianes et ombre se dechainent
	GROUND:CharSetEmote(zarude, "angry", 1)
	SOUND:PlayBattleSE("EVT_Emote_Shock_2")
	BossFX.Particle("Leaf_Storm_Leaf", 250, 208, 3)
	BossFX.Particle("Leaf_Storm_Leaf", 302, 208, 3)
	BossFX.Particle("Dark_Pulse_Front", 276, 208, 3)
	BossFX.ShakeScreen(8, 24)
	UI:SetSpeaker(zarude)
	UI:SetSpeakerEmotion("Shouting")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_009']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_010']))
	GROUND:CharSetEmote(zarude, "", 0)

	SV.Chapter6.GloomyBossEncountered = true
	-- COMMON.BossTransition : double flash blanc + fondu vers l'arene.
	COMMON.BossTransition()
	GAME:CutsceneMode(false)
	GAME:ContinueDungeon("gloomy_forest", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

return gloomy_forest_boss_ch_6
