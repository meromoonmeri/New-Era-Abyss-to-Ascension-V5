require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_town_ch_6 = {}

local function RestorePartnerAI(partner)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
end

local function AddDazzlingPlazaTrigger()
	local plazaTrigger = RogueEssence.Ground.GroundObject(
		RogueEssence.Content.ObjAnimData("", 1),
		RogueElements.Rect(760, 736, 288, 224),
		RogueElements.Loc(0, 0),
		false,
		"Event_Trigger_9")
	plazaTrigger:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(plazaTrigger)
end

function metano_town_ch_6.SetupGround()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	GROUND:Hide('Swap_Owner')
	GROUND:Hide('Swap')

	if not SV.Chapter6.DazzlingIntroPlayed then
		AddDazzlingPlazaTrigger()
	end

	local butterfree, adagio, aria, sonata = CharacterEssentials.MakeCharactersFromList({
		{'Butterfree', 824, 816, Direction.Right},
		{'Adagio', 1080, 784, Direction.Left},
		{'Aria', 1112, 816, Direction.Left},
		{'Sonata', 1144, 848, Direction.Left}
	})
	local mawile, floatzel, quagsire = CharacterEssentials.MakeCharactersFromList({
		{'Mawile', 736, 960, Direction.Up},
		{'Floatzel', 928, 1040, Direction.UpLeft},
		{'Quagsire', 640, 1008, Direction.UpRight}
	})
	AI:SetCharacterAI(mawile, "halcyon.ai.ground_default", RogueElements.Loc(720, 944), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
	AI:SetCharacterAI(floatzel, "halcyon.ai.ground_default", RogueElements.Loc(912, 1024), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
	AI:SetCharacterAI(quagsire, "halcyon.ai.ground_default", RogueElements.Loc(624, 992), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)

	if SV.Chapter6.DazzlingIntroPlayed then
		GROUND:TeleportTo(butterfree, 824, 816, Direction.Right)
		GROUND:TeleportTo(adagio, 1008, 784, Direction.DownLeft)
		GROUND:TeleportTo(aria, 1040, 816, Direction.Left)
		GROUND:TeleportTo(sonata, 1072, 848, Direction.Left)
	end

	AI:SetCharacterAI(adagio, "halcyon.ai.ground_talking", false, 240, 60, 0, false, 'Default', {aria, sonata})
	AI:SetCharacterAI(aria, "halcyon.ai.ground_talking", false, 240, 60, 60, false, 'Default', {adagio, sonata})
	AI:SetCharacterAI(sonata, "halcyon.ai.ground_talking", false, 240, 60, 120, false, 'Default', {adagio, aria})

	if SV.Chapter6.MissionComplete and not SV.Chapter6.PostMissionScenePlayed then
		local venipede = CharacterEssentials.MakeCharactersFromList({
			{'Venipede', 864, 848, Direction.Left}
		})
		AI:DisableCharacterAI(butterfree)
		AI:DisableCharacterAI(venipede)
	end

	if SV.Chapter6.DefeatedByZarude and not SV.Chapter6.PostDefeatScenePlayed then
		-- Le joueur revient apres avoir perdu contre Zarude
		GROUND:TeleportTo(hero, 792, 896, Direction.Up)
		GROUND:TeleportTo(partner, 824, 896, Direction.Up)
	end

	GAME:FadeIn(20)
end

function metano_town_ch_6.Event_Trigger_9_Touch(obj, activator)
	if SV.Chapter6.DazzlingIntroPlayed then return end
	GROUND:Hide('Event_Trigger_9')
	metano_town_ch_6.DazzlingIntroduction()
end

function metano_town_ch_6.DazzlingIntroduction()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local butterfree = CH('Butterfree')
	local adagio = CH('Adagio')
	local aria = CH('Aria')
	local sonata = CH('Sonata')
	local mawile = CH('Mawile')
	local floatzel = CH('Floatzel')
	local quagsire = CH('Quagsire')

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	AI:DisableCharacterAI(butterfree)
	AI:DisableCharacterAI(adagio)
	AI:DisableCharacterAI(aria)
	AI:DisableCharacterAI(sonata)
	GAME:MoveCamera(896, 816, 1, false)

	local coro1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(butterfree, 872, 816, false, 1)
		GROUND:CharAnimateTurnTo(butterfree, Direction.Down, 4)
	end)
	local coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GROUND:MoveToPosition(hero, 792, 896, false, 1)
		GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
	end)
	local coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		GROUND:MoveToPosition(partner, 824, 896, false, 1)
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	end)
		TASK:JoinCoroutines({coro1, coro2, coro3})

		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_118']))
		UI:SetSpeaker(mawile)
		UI:SetSpeakerEmotion("Inspired")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_119']))
		UI:SetSpeaker(floatzel)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_120']))
		UI:SetSpeaker(quagsire)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_121']))

		-- The square notices the commotion before the rivals speak.  This gives
		-- the entrance the same lived-in rhythm as the guild scenes.
	local crowd1 = TASK:BranchCoroutine(function()
		GROUND:CharAnimateTurnTo(mawile, Direction.UpRight, 4)
		GROUND:CharSetEmote(mawile, "notice", 1)
	end)
	local crowd2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:CharAnimateTurnTo(floatzel, Direction.UpLeft, 4)
		GROUND:CharSetEmote(floatzel, "notice", 1)
	end)
	local crowd3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		GROUND:CharAnimateTurnTo(quagsire, Direction.Up, 4)
		GROUND:CharSetEmote(quagsire, "question", 1)
	end)
	TASK:JoinCoroutines({crowd1, crowd2, crowd3})
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	UI:SetSpeaker(mawile)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_042']))
	UI:SetSpeaker(floatzel)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_043']))
	UI:SetSpeaker(quagsire)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_044']))

		SOUND:FadeOutBGM(30)
		GAME:WaitFrames(20)
		SOUND:PlayBGM("Team_Dazzling.ogg", true)
		GAME:WaitFrames(12)

		coro1 = TASK:BranchCoroutine(function()
			GROUND:MoveToPosition(adagio, 1008, 784, false, 1)
			GROUND:CharAnimateTurnTo(adagio, Direction.DownLeft, 4)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:MoveToPosition(aria, 1040, 816, false, 1)
		GROUND:CharAnimateTurnTo(aria, Direction.Left, 4)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GROUND:MoveToPosition(sonata, 1072, 848, false, 1)
		GROUND:CharAnimateTurnTo(sonata, Direction.Left, 4)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GROUND:CharAnimateTurnTo(adagio, Direction.Down, 4)
	GROUND:CharAnimateTurnTo(aria, Direction.Down, 4)
	GROUND:CharAnimateTurnTo(sonata, Direction.Down, 4)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	UI:SetSpeaker(aria)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_045']))
	GeneralFunctions.Hop(aria, "None", 6, 6, true, true)
	UI:SetSpeaker(sonata)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_046']))
		GeneralFunctions.DoubleHop(sonata)
		UI:SetSpeaker(adagio)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_047']))

		UI:SetSpeaker(butterfree)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_001']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_002']))
		GAME:WaitFrames(12)

		UI:SetSpeaker(adagio)
		UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_003']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_004']))

	UI:SetSpeaker(aria)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_005']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_006']))

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Angry")
	GeneralFunctions.EmoteAndPause(partner, "angry", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_007']))

	-- Aria tests the partner physically, but backs off as soon as she has
	-- obtained the reaction she wanted.
	local bump1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(aria, 880, 864, false, 1)
		GROUND:MoveInDirection(partner, Direction.DownRight, 8, false, 1)
	end)
	local bump2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		SOUND:PlayBattleSE("EVT_Emote_Shock_2")
		GROUND:CharSetEmote(partner, "shock", 1)
	end)
	TASK:JoinCoroutines({bump1, bump2})
	UI:SetSpeaker(aria)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_048']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_049']))
	GROUND:MoveToPosition(aria, 1040, 816, false, 1)
	GROUND:CharAnimateTurnTo(aria, Direction.Left, 4)

	UI:SetSpeaker(sonata)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetEmote(sonata, "happy", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_008']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_009']))
	GROUND:CharSetEmote(sonata, "", 0)

	local trick = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(sonata, 848, 848, false, 1)
		GROUND:CharAnimateTurnTo(sonata, Direction.Right, 4)
	end)
	local trick2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		SOUND:PlayBattleSE("EVT_Emote_Confused_2")
		GROUND:CharSetEmote(partner, "question", 1)
	end)
	TASK:JoinCoroutines({trick, trick2})
	UI:SetSpeaker(sonata)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_050']))
	GROUND:MoveToPosition(sonata, 1072, 848, false, 1)
	GROUND:CharAnimateTurnTo(sonata, Direction.Left, 4)

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_010']))

	UI:SetSpeaker(hero)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_011']))

	UI:SetSpeaker(butterfree)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_012']))

	UI:SetSpeaker(aria)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_013']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_014']))

	UI:SetSpeaker(adagio)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_015']))
	GROUND:CharSetEmote(adagio, "happy", 0)
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(adagio, "", 0)

	UI:SetSpeaker(sonata)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_016']))

	UI:SetSpeaker(adagio)
	UI:SetSpeakerEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_017']))

	UI:SetSpeaker(floatzel)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_051']))
	UI:SetSpeaker(aria)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_052']))
	UI:SetSpeaker(sonata)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_053']))
	UI:SetSpeaker(adagio)
	UI:SetSpeakerEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_054']))

	local exit1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(aria, 1120, 816, false, 1)
		GROUND:CharAnimateTurnTo(aria, Direction.Right, 4)
	end)
	local exit2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:MoveToPosition(sonata, 1152, 848, false, 1)
		GROUND:CharAnimateTurnTo(sonata, Direction.Right, 4)
	end)
	local exit3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GROUND:MoveToPosition(adagio, 1080, 784, false, 1)
		GROUND:CharAnimateTurnTo(adagio, Direction.Right, 4)
	end)
	TASK:JoinCoroutines({exit1, exit2, exit3})
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_055']))
	UI:SetSpeaker(adagio)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_056']))

	SV.Chapter6.DazzlingIntroPlayed = true
	SV.Chapter6.MissionAvailable = true
	GAME:WaitFrames(20)
	GAME:CutsceneMode(false)
	RestorePartnerAI(partner)
	AI:SetCharacterAI(adagio, "halcyon.ai.ground_talking", false, 240, 60, 0, false, 'Default', {aria, sonata})
	AI:SetCharacterAI(aria, "halcyon.ai.ground_talking", false, 240, 60, 60, false, 'Default', {adagio, sonata})
	AI:SetCharacterAI(sonata, "halcyon.ai.ground_talking", false, 240, 60, 120, false, 'Default', {adagio, aria})
end

function metano_town_ch_6.Butterfree_Action(chara, activator)
	if not SV.Chapter6.DazzlingIntroPlayed then return end
	if SV.Chapter6.MissionComplete then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_018']), "Happy")
		GeneralFunctions.EndConversation(chara)
		return
	end

	local partner = CH('Teammate1')
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_019']), "Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_020']))
	UI:ChoiceMenuYesNo(STRINGS:Format(STRINGS.MapStrings['MT6_021']), true)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	if result then
		SV.Chapter6.MissionAccepted = true
		GeneralFunctions.EndConversation(chara)
		AI:DisableCharacterAI(partner)
		SOUND:FadeOutBGM(40)
		GAME:FadeOut(false, 40)
		GAME:EnterGroundMap("gloomy_forest_entrance", "Main_Entrance_Marker")
	else
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_022']))
		GeneralFunctions.EndConversation(chara)
	end
end

function metano_town_ch_6.Venipede_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_035']), "Happy")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Adagio_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_023']), "Normal")
	UI:SetSpeakerEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_024']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Aria_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_025']), "Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_026']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Sonata_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_027']), "Happy")
	GROUND:CharSetEmote(chara, "happy", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_028']))
	GROUND:CharSetEmote(chara, "", 0)
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.PostMissionCutscene()
	if SV.Chapter6.PostMissionScenePlayed ~= false or not SV.Chapter6.MissionComplete then return end
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local butterfree = CH('Butterfree')
	local venipede = CH('Venipede')
	local adagio = CH('Adagio')
	local aria = CH('Aria')
	local sonata = CH('Sonata')

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	AI:DisableCharacterAI(butterfree)
	AI:DisableCharacterAI(venipede)
	AI:DisableCharacterAI(adagio)
	AI:DisableCharacterAI(aria)
	AI:DisableCharacterAI(sonata)
	GAME:MoveCamera(896, 816, 1, false)

	UI:SetSpeaker(butterfree)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_029']))
	UI:SetSpeaker(venipede)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_030']))
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_031']))
	UI:SetSpeaker(aria)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_032']))
	UI:SetSpeaker(sonata)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_033']))
	UI:SetSpeaker(adagio)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_034']))

	SV.Chapter6.PostMissionScenePlayed = true
	GAME:WaitFrames(20)
	GAME:CutsceneMode(false)
	RestorePartnerAI(partner)
	AI:EnableCharacterAI(butterfree)
	AI:EnableCharacterAI(venipede)
	AI:SetCharacterAI(adagio, "halcyon.ai.ground_talking", false, 240, 60, 0, false, 'Default', {aria, sonata})
	AI:SetCharacterAI(aria, "halcyon.ai.ground_talking", false, 240, 60, 60, false, 'Default', {adagio, sonata})
	AI:SetCharacterAI(sonata, "halcyon.ai.ground_talking", false, 240, 60, 120, false, 'Default', {adagio, aria})
end

function metano_town_ch_6.Mawile_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_036']), "Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_037']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Floatzel_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_038']), "Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_039']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Quagsire_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_040']), "Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_041']))
	GeneralFunctions.EndConversation(chara)
end

-- TOWN NPCS — Chapter 6 dialogues (Pre/During/Post Forest)
-- Each NPC has multiple dialogue variants depending on mission progress

local function Ch6State()
  if SV.Chapter6.MissionComplete then return "post"
  elseif SV.Chapter6.MissionAccepted then return "during"
  elseif SV.Chapter6.DazzlingIntroPlayed then return "pre"
  else return "early"
  end
end

function metano_town_ch_6.Luxray_Action(chara, activator)
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_077']), "Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_079']))
  elseif s == "during" then
    GeneralFunctions.StartConversation(chara, "Allez, [player].[pause=15] La foret n'attend pas.", "Determined")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_057']), "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Electrike_Action(chara, activator)
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_082']), "Inspired")
  elseif s == "pre" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_059']), "Normal")
  else
    GeneralFunctions.StartConversation(chara, "Vous partez en mission ?[pause=15] Trop cool !", "Happy")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Manectric_Action(chara, activator)
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_080']), "Normal")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_065']), "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Bellossom_Action(chara, activator)
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_081']), "Happy")
  elseif s == "pre" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_068']), "Worried")
  else
    GeneralFunctions.StartConversation(chara, "La foret...[pause=20] elle a besoin d'aide. Je le sens.", "Sad")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Vileplume_Action(chara, activator)
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_070']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_061']), "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Gloom_Action(chara, activator)
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_078']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, "Chenipent...[pause=25] il est si petit.", "Sad")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Oddish_Action(chara, activator)
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, "Chenipent dit que vous etes ses heros ![pause=15] Il le dit a TOUT le monde !", "Happy")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_064']), "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Numel_Action(chara, activator)
  GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_062']), "Angry")
  UI:WaitShowDialogue("Pourquoi les equipes d'elite ne font rien ?![pause=15] C'est pas juste !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Camerupt_Action(chara, activator)
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_076']), "Normal")
  else
    GeneralFunctions.StartConversation(chara, "Numel est enerve.[pause=20] Il a raison.[pause=25] Mais on ne peut pas forcer les autres.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Machamp_Action(chara, activator)
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_095']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_064']), "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Meditite_Action(chara, activator)
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_096']), "Normal")
  else
    GeneralFunctions.StartConversation(chara, "La Team Dazzling...[pause=20] elles font peur.[pause=15] Mais elles sont fascinantes.", "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Medicham_Action(chara, activator)
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_097']), "Normal")
  else
    GeneralFunctions.StartConversation(chara, "L'entrainement est la cle.[pause=25] Surtout avant d'affronter l'inconnu.", "Determined")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Furret_Action(chara, activator)
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_094']), "Happy")
  elseif s == "pre" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_058']), "Inspired")
  else
    GeneralFunctions.StartConversation(chara, "La foret...[pause=25] faites attention a vous.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Linoone_Action(chara, activator)
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, "Mon petit veut etre comme vous plus tard.[pause=25] J'espere que vous serez un bon modele.", "Normal")
  else
    GeneralFunctions.StartConversation(chara, "Les enfants ne comprennent pas le danger.[pause=20] Vous, si.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Sentret_Action(chara, activator)
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, "Vous avez vu Zarude de PRES ?![pause=15] Waaaah ![pause=20] Racontez-moi TOUT !", "Inspired")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_066']), "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Wooper_Girl_Action(chara, activator)
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, "Chenipent m'a raconte que vous l'aviez porte sur votre dos ![pause=15] C'est vrai ?", "Happy")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_063']), "Sad")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Wooper_Boy_Action(chara, activator)
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_075']), "Shock")
  else
    GeneralFunctions.StartConversation(chara, "La foret fait peur...[pause=30] Vous n'avez pas peur, vous ?", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Nidorina_Action(chara, activator)
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_069']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_067']), "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Nidoran_Male_Action(chara, activator)
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, "Ma soeur veut etre comme vous.[pause=20] Moi aussi.[pause=25] Mais je le dirai pas.", "Normal")
  else
    GeneralFunctions.StartConversation(chara, "Allez-y ![pause=15] Sauvez Chenipent ![pause=20] Et revenez vite !", "Determined")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Nidoking_Action(chara, activator)
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_079']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, "Protegez les petits.[pause=25] C'est tout ce qui compte.", "Determined")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Azumarill_Action(chara, activator)
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_084']), "Normal")
  else
    GeneralFunctions.StartConversation(chara, "La riviere est calme aujourd'hui.[pause=20] Trop calme.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Gulpin_Action(chara, activator)
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, "Un festin ![pause=15] Il faut celebrer ca avec un festin ![pause=20] Qui paye ?", "Happy")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_068']), "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Lickitung_Action(chara, activator)
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_093']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, "Le Cafe a un nouveau jus de Baie Mepris.[pause=25] Pour se donner du courage.", "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Roselia_Action(chara, activator)
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_081']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, "Mes epines sont affutees.[pause=20] Mais la foret...[pause=25] elle est plus tranchante.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Spinda_Action(chara, activator)
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_093']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, "Un cafe avant de partir ?[pause=15] Pour la route ?[pause=25] Je vous l'offre !", "Happy")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Ludicolo_Action(chara, activator)
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, "La musique est plus joyeuse aujourd'hui ![pause=15] Vous voulez danser ?", "Happy")
  else
    GeneralFunctions.StartConversation(chara, "La pluie va tomber.[pause=25] Je le sens dans mes os.", "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Jigglypuff_Action(chara, activator)
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, "Je vous chante une berceuse ?[pause=20] Pour feter votre victoire ?", "Happy")
  else
    GeneralFunctions.StartConversation(chara, "Je peux vous endormir avant la mission...[pause=30] Non ?[pause=15] Dommage.", "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Marill_Action(chara, activator)
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_070']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, "J'aimerais pouvoir vous aider.[pause=25] Mais je suis trop petit.", "Sad")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Spheal_Action(chara, activator)
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_078']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, "Roulez, roulez jusqu'a la foret ![pause=10] Enfin, pas moi. Vous.", "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Bagon_Action(chara, activator)
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_076']), "Inspired")
  else
    GeneralFunctions.StartConversation(chara, "Un jour, je volerai ![pause=15] Et je pourrai vous aider !", "Determined")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Doduo_Action(chara, activator)
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_077']), "Normal")
  else
    GeneralFunctions.StartConversation(chara, "Courir, toujours courir.[pause=20] C'est comme ca qu'on avance.", "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Metapod_Action(chara, activator)
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, "...[pause=30] (Metapod semble plus brillant qu'avant.)", "Normal")
  else
    GeneralFunctions.StartConversation(chara, "...[pause=40] (Metapod vous fixe sans cligner.)", "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Silcoon_Action(chara, activator)
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, "Chenipent est passe me voir ![pause=15] Il m'a parle de vous.", "Happy")
  else
    GeneralFunctions.StartConversation(chara, "Papilusion est ma voisine.[pause=20] Aidez-la,[pause=10] s'il vous plait.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Mareep_Action(chara, activator)
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_098']), "Worried")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_063']), "Sad")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Cranidos_Action(chara, activator)
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_095']), "Normal")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_062']), "Angry")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Snubbull_Action(chara, activator)
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_085']), "Inspired")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_057']), "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Audino_Action(chara, activator)
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_092']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, "Prenez des Baies Oran.[pause=15] Et des Baies Sitrus.[pause=25] Et... prenez tout.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Zigzagoon_Action(chara, activator)
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_094']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_064']), "Determined")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Growlithe_Desk_Action(chara, activator)
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_091']), "Normal")
  else
    GeneralFunctions.StartConversation(chara, "La guilde vous soutient.[pause=15] Toujours. N'oubliez jamais ca.", "Determined")
  end
  GeneralFunctions.EndConversation(chara)
end


-- ============================================================
-- CINEMATIQUE DEFAITE — Team Dazzling se moque du joueur
-- Joue quand le joueur revient en ville apres avoir perdu contre Zarude
-- ============================================================
function metano_town_ch_6.PostDefeatCutscene()
	if SV.Chapter6.PostDefeatScenePlayed ~= false then return end
	if not SV.Chapter6.DefeatedByZarude then return end
	if SV.Chapter6.MissionComplete then return end
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local adagio = CH('Adagio')
	local aria = CH('Aria')
	local sonata = CH('Sonata')
	local mawile = CH('Mawile')
	local floatzel = CH('Floatzel')
	local quagsire = CH('Quagsire')
	local luxray = CH('Luxray')

	SOUND:PlayBGM('Team_Dazzling.ogg', true)
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	AI:DisableCharacterAI(adagio)
	AI:DisableCharacterAI(aria)
	AI:DisableCharacterAI(sonata)
	GAME:MoveCamera(896, 816, 1, false)

	-- Le heros et partenaire arrivent, tete basse
	GAME:WaitFrames(10)
	GROUND:CharSetEmote(partner, "sweating", 1)
	GAME:WaitFrames(10)
	GROUND:CharSetEmote(hero, "sweatdrop", 1)
	GAME:WaitFrames(20)

	-- Team Dazzling arrive deja au courant
	local c1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(adagio, 1008, 784, false, 1)
		GROUND:CharAnimateTurnTo(adagio, Direction.DownLeft, 4)
	end)
	local c2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:MoveToPosition(aria, 1040, 816, false, 1)
		GROUND:CharAnimateTurnTo(aria, Direction.Left, 4)
	end)
	local c3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GROUND:MoveToPosition(sonata, 1072, 848, false, 1)
		GROUND:CharAnimateTurnTo(sonata, Direction.Left, 4)
	end)
	TASK:JoinCoroutines({c1, c2, c3})

	-- La foule regarde, genee
	GROUND:CharAnimateTurnTo(mawile, Direction.UpLeft, 4)
	GROUND:CharSetEmote(mawile, "question", 1)
	GROUND:CharAnimateTurnTo(floatzel, Direction.Up, 4)
	GROUND:CharSetEmote(floatzel, "sweating", 1)
	GROUND:CharAnimateTurnTo(quagsire, Direction.UpRight, 4)
	GROUND:CharSetEmote(quagsire, "sad", 1)

	-- Aria se moque
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	UI:SetSpeaker(aria)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_102']))
	GeneralFunctions.Hop(aria, "None", 4, 4, true, true)

	-- Sonata rencherit
	UI:SetSpeaker(sonata)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_103']))

	-- Le partenaire explose
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Angry")
	GROUND:CharSetEmote(partner, "angry", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_104']))

	-- Adagio, glaciale
	UI:SetSpeaker(adagio)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_105']))
	UI:SetSpeakerEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_106']))

	-- Aria, coup de grace
	UI:SetSpeaker(aria)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_107']))

	-- Luxray intervient
	if luxray then
		GROUND:CharAnimateTurnTo(luxray, Direction.Up, 4)
		GROUND:CharSetEmote(luxray, "notice", 1)
		UI:SetSpeaker(luxray)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_108']))
	end

	-- Adagio conclut
	UI:SetSpeaker(adagio)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_109']))

	-- Elles repartent
	local d1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(aria, 1120, 816, false, 1)
		GROUND:CharAnimateTurnTo(aria, Direction.Right, 4)
	end)
	local d2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:MoveToPosition(sonata, 1152, 848, false, 1)
		GROUND:CharAnimateTurnTo(sonata, Direction.Right, 4)
	end)
	local d3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GROUND:MoveToPosition(adagio, 1080, 784, false, 1)
		GROUND:CharAnimateTurnTo(adagio, Direction.Right, 4)
	end)
	TASK:JoinCoroutines({d1, d2, d3})

	-- Village glace, gene
	GROUND:CharAnimateTurnTo(mawile, Direction.Down, 4)
	GROUND:CharSetEmote(mawile, "sweating", 1)
	UI:SetSpeaker(mawile)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_110']))

	-- Le partenaire, resolu
	GROUND:CharSetEmote(partner, "determined", 1)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_111']))

	SV.Chapter6.PostDefeatScenePlayed = true
	GAME:WaitFrames(20)
	GAME:CutsceneMode(false)
	RestorePartnerAI(partner)
	AI:SetCharacterAI(adagio, "halcyon.ai.ground_talking", false, 240, 60, 0, false, 'Default', {aria, sonata})
	AI:SetCharacterAI(aria, "halcyon.ai.ground_talking", false, 240, 60, 60, false, 'Default', {adagio, sonata})
	AI:SetCharacterAI(sonata, "halcyon.ai.ground_talking", false, 240, 60, 120, false, 'Default', {adagio, aria})
	SOUND:PlayBGM('Treasure Town.ogg', true)
end

return metano_town_ch_6
