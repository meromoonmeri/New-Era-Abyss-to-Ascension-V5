require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

gloomy_forest_entrance_ch_6 = {}

function gloomy_forest_entrance_ch_6.SetupGround()
	local butterfree = CharacterEssentials.MakeCharactersFromList({
		{'Butterfree', 244, 240, Direction.DownRight}
	})
	AI:SetCharacterAI(butterfree, "halcyon.ai.ground_default", RogueElements.Loc(224, 224), RogueElements.Loc(48, 48), 1, 16, 32, 40, 180)
end

function gloomy_forest_entrance_ch_6.ArrivalCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local butterfree = CharacterEssentials.MakeCharactersFromList({
		{'Butterfree', 244, 240, Direction.DownRight}
	})

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	AI:DisableCharacterAI(butterfree)
	GAME:MoveCamera(276, 232, 1, false)
	GAME:FadeOut(false, 1)

	GROUND:TeleportTo(hero, 276, 416, Direction.Up)
	GROUND:TeleportTo(partner, 308, 416, Direction.Up)
	GAME:FadeIn(40)
	SOUND:PlayBGM('Mystifying Forest.ogg', true)

	local coro1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(hero, 276, 288, false, 1)
		GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	end)
	local coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GROUND:MoveToPosition(partner, 308, 288, false, 1)
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	UI:SetSpeaker(butterfree)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_001']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_002']))
	GAME:WaitFrames(16)

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_003']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_004']))

	UI:SetSpeaker(hero)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_005']))

	UI:SetSpeaker(butterfree)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_006']))
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_007']))

	GROUND:CharAnimateTurnTo(butterfree, Direction.Up, 4)
	GROUND:CharSetEmote(butterfree, "notice", 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	GROUND:MoveToPosition(butterfree, 276, 216, false, 1)
	UI:SetSpeaker(butterfree)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_009']))

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_010']))
	GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_011']))

	UI:SetSpeaker(hero)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_012']))

	UI:SetSpeaker(butterfree)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_013']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_014']))
	GAME:MoveCamera(276, 184, 24, false)

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_015']))
	UI:SetSpeaker(hero)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_016']))
	UI:SetSpeaker(butterfree)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_017']))
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_018']))

	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_019']))
	UI:SetSpeaker(butterfree)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_020']))

	SV.Chapter6.FinishedGloomyForestIntro = true
	GAME:WaitFrames(20)
	GAME:FadeOut(false, 40)
	SOUND:FadeOutBGM(40)
	GAME:WaitFrames(40)
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GAME:FadeIn(40)
	SOUND:PlayBGM('Mystifying Forest.ogg', true)
end

function gloomy_forest_entrance_ch_6.Butterfree_Action(chara, activator)
	if SV.Chapter6.MissionAccepted then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['GF6E_008']), "Worried")
		GeneralFunctions.EndConversation(chara)
	end
end

return gloomy_forest_entrance_ch_6
