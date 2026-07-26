require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

gloomy_forest_midpoint_ch_6 = {}

------------------------------------------------------------------
-- IMPORTANT: every GROUND:TeleportTo / MoveToPosition / MoveCamera
-- coordinate below is a PLACEHOLDER. The gloomy_forest_midpoint ground map
-- layout must be authored in the PMDO Ground Map Editor (forest biome — see
-- docs/authoring_crooked_cavern_midpoint.md for the model). Tune these to the
-- real tile layout once the map exists. Named entities assumed on the map:
--   "Main_Entrance_Marker", "North_Exit", and a "Kangaskhan_Rock" object.
------------------------------------------------------------------

-- Quiet resting arrangement when arriving freely (not a cutscene).
function gloomy_forest_midpoint_ch_6.SetupGround()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  -- TODO_MAP: adjust to the relay's tile layout.
  if SV.Chapter6.GloomyMidpointState == 'DeathArrival' then
    GROUND:TeleportTo(hero, 188, 176, Direction.Left)
    GROUND:TeleportTo(partner, 208, 176, Direction.Right)
  else -- FirstArrival / RepeatArrival
    GROUND:TeleportTo(hero, 188, 256, Direction.Up)
    GROUND:TeleportTo(partner, 208, 256, Direction.Up)
  end

  GAME:FadeIn(20)
end


-- Talking to the partner at the relay.
function gloomy_forest_midpoint_ch_6.Partner_Action(chara, activator)
  if SV.Chapter6.GloomyMidpointState == 'DeathArrival' then
    GeneralFunctions.StartConversation(chara, "Nous sommes revenus à la clairière...[pause=0] il ne faut pas abandonner, Chenipent compte sur nous.", "Worried")
  elseif SV.Chapter6.GloomyMidpointState == 'FirstArrival' then
    GeneralFunctions.StartConversation(chara, "Le rocher de Kangourex permet de sauvegarder et de stocker nos objets.[pause=0] Reposons-nous avant les profondeurs.")
  else -- RepeatArrival
    GeneralFunctions.StartConversation(chara, "Reposons-nous un instant avant de continuer.")
  end
  GeneralFunctions.EndConversation(chara)
end


-- Leaving the relay forward into segment 1 (depth floors).
function gloomy_forest_midpoint_ch_6.ContinueScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GROUND:Hide('North_Exit') -- TODO_MAP: ensure a "North_Exit" entity exists on the map.

  UI:ResetSpeaker()
  UI:SetSpeaker(partner)
  if SV.Chapter6.GloomyMidpointState == 'FirstArrival' then
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_010']))
  elseif SV.Chapter6.GloomyMidpointState == 'DeathArrival' then
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_011']))
  else
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_012']))
  end

  -- TODO_MAP: walk the duo toward the north exit, then fade out.
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
    GROUND:MoveInDirection(partner, Direction.Up, 72, false, 1) end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
    GROUND:MoveInDirection(hero, Direction.Up, 72, false, 1) end)
  local coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(28)
    GAME:FadeOut(false, 40) end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  -- Continue the adventure into segment 1. PP/belly NOT restored (Halcyon convention).
  SV.checkpoint.Zone = "master_zone"
  SV.checkpoint.Segment = -1
  SV.checkpoint.Map = 61
  SV.checkpoint.Entry = 0
  GAME:EnterDungeon("gloomy_forest", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end


-- First time the duo reaches the relay: brief calm intro, then free control.
function gloomy_forest_midpoint_ch_6.FirstArrival()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  AI:DisableCharacterAI(partner)

  -- TODO_MAP: entry positions on the real map.
  GROUND:TeleportTo(hero, 188, 272, Direction.Up)
  GROUND:TeleportTo(partner, 208, 272, Direction.Up)
  GAME:MoveCamera(200, 200, 1, false)

  GAME:FadeIn(40)
  SOUND:PlayBGM('Sky Peak Forest.ogg', true) -- calm forest theme (tunable)
  GAME:WaitFrames(20)

  -- TODO_MAP: walk forward to the resting spot near the statue.
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveToPosition(hero, 188, 200, false, 1)
    GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GROUND:MoveToPosition(partner, 208, 200, false, 1)
    GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(10)

  UI:SetSpeaker(partner)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_001']))
  GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_002']))
  GAME:WaitFrames(10)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_003']))
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_004']))

  SV.Chapter6.GloomyPlayedMidpointIntro = true
  GeneralFunctions.PanCamera()
  AI:EnableCharacterAI(partner)
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
  GAME:CutsceneMode(false)
end


-- Returned after fainting past the checkpoint (depth floors or Zarude).
function gloomy_forest_midpoint_ch_6.WipedCutscene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  AI:DisableCharacterAI(partner)

  -- TODO_MAP: positions where the duo "wakes up" on the real map.
  GROUND:TeleportTo(hero, 188, 176, Direction.Left)
  GROUND:TeleportTo(partner, 208, 176, Direction.Right)

  GROUND:CharSetAnim(partner, "EventSleep", true)
  GROUND:CharSetAnim(hero, "EventSleep", true)
  GAME:MoveCamera(200, 176, 1, false)

  GAME:FadeIn(40)
  SOUND:PlayBGM('Sky Peak Forest.ogg', true)
  GAME:WaitFrames(100)

  local coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.DoAnimation(hero, 'Wake')
    GAME:WaitFrames(12)
    GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    GeneralFunctions.DoAnimation(partner, 'Wake')
    GAME:WaitFrames(12)
    GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(30)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Pain")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_020']))
  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_021']))

  -- GloomyBossEncountered distinguishes a Zarude wipe (true) from a depth-floors wipe (false).
  -- Unlike Crooked's LostToBoss, it must NOT be cleared here: gloomy_forest_boss uses it to
  -- pick the retry scene on the next visit.
  if SV.Chapter6.GloomyBossEncountered then
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_022']))
    UI:SetSpeakerEmotion("Determined")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_023']))
  else
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_024']))
    UI:SetSpeakerEmotion("Determined")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM6_025']))
  end

  -- Reset the death flag now that the wake-up scene has played.
  SV.GloomyForest.DiedPastCheckpoint = false
  GeneralFunctions.PanCamera()
  AI:EnableCharacterAI(partner)
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
  GAME:CutsceneMode(false)
end
