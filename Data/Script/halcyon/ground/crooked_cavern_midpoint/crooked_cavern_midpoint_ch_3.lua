require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

crooked_cavern_midpoint_ch_3 = {}

------------------------------------------------------------------
-- IMPORTANT: every GROUND:TeleportTo / MoveToPosition / MoveCamera
-- coordinate below is a PLACEHOLDER. The crooked_cavern_midpoint ground
-- map layout must still be authored in the PMDO Ground Map Editor (see
-- docs/authoring_crooked_cavern_midpoint.md). Tune these to the real
-- tile layout once the map exists. Named entities assumed on the map:
--   "Main_Entrance_Marker" (entry), "North_Exit" (forward touch-zone),
--   and a "Kangaskhan_Rock" object.
------------------------------------------------------------------

-- Quiet resting arrangement when arriving freely (not a cutscene).
function crooked_cavern_midpoint_ch_3.SetupGround()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  -- TODO_MAP: adjust to the relay's tile layout.
  if SV.Chapter3.CrookedMidpointState == 'DeathArrival' then
    GROUND:TeleportTo(hero, 188, 176, Direction.Left)
    GROUND:TeleportTo(partner, 208, 176, Direction.Right)
  else -- FirstArrival / RepeatArrival
    GROUND:TeleportTo(hero, 188, 256, Direction.Up)
    GROUND:TeleportTo(partner, 208, 256, Direction.Up)
  end

  GAME:FadeIn(20)
end


-- Talking to the partner at the relay.
function crooked_cavern_midpoint_ch_3.Partner_Action(chara, activator)
  if SV.Chapter3.CrookedMidpointState == 'DeathArrival' then
    GeneralFunctions.StartConversation(chara, "Nous sommes revenus au point de relais...[pause=0] il ne faut pas baisser les bras.", "Worried")
  elseif SV.Chapter3.CrookedMidpointState == 'FirstArrival' then
    GeneralFunctions.StartConversation(chara, "Le rocher de Kangourex permet de sauvegarder et de stocker nos objets.[pause=0] Préparons-nous bien avant la suite.")
  else -- RepeatArrival
    GeneralFunctions.StartConversation(chara, "Reposons-nous un instant avant de continuer.")
  end
  GeneralFunctions.EndConversation(chara)
end


-- Leaving the relay forward into segment 1 (Profondeurs).
function crooked_cavern_midpoint_ch_3.ContinueScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GROUND:Hide('North_Exit') -- TODO_MAP: ensure a "North_Exit" entity exists on the map.

  UI:ResetSpeaker()
  UI:SetSpeaker(partner)
  if SV.Chapter3.CrookedMidpointState == 'FirstArrival' then
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCM3_010']))
  elseif SV.Chapter3.CrookedMidpointState == 'DeathArrival' then
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCM3_011']))
  else
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCM3_012']))
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

  -- Continue the adventure into segment 1. PP/belly are NOT restored
  -- (Halcyon checkpoint convention — audit §9.1, decision: halcyon_coherence).
  GAME:EnterDungeon("crooked_cavern", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end


-- First time the duo reaches the relay: brief calm intro, then free control.
function crooked_cavern_midpoint_ch_3.FirstArrival()
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
  SOUND:PlayBGM('Heartwarming.ogg', true) -- calm relay theme (confirmed present)
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
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCM3_001']))
  GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCM3_002']))
  GAME:WaitFrames(10)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCM3_003']))
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCM3_004']))

  SV.Chapter3.CrookedPlayedMidpointIntro = true
  GeneralFunctions.PanCamera()
  AI:EnableCharacterAI(partner)
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
  GAME:CutsceneMode(false)
end


-- Returned after fainting past the checkpoint (Profondeurs or boss).
function crooked_cavern_midpoint_ch_3.WipedCutscene()
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
  SOUND:PlayBGM('Heartwarming.ogg', true)
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
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCM3_020']))
  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCM3_021']))

  if SV.Chapter3.LostToBoss then
    -- Wipe was against the boss (Team Style).
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCM3_022']))
    UI:SetSpeakerEmotion("Determined")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCM3_023']))
    -- Clear LostToBoss so the next crooked_den visit plays SecondPreBossScene (retry)
    -- instead of DiedToBoss (which would send the duo back to town and break the
    -- checkpoint loop). Mirrors crooked_den_ch_3.DiedToBoss() line 601.
    SV.Chapter3.LostToBoss = false
  else
    -- Wipe was in the Profondeurs (second half).
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCM3_024']))
    UI:SetSpeakerEmotion("Determined")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCM3_025']))
  end

  -- Reset the death flag now that the wake-up scene has played.
  SV.CrookedCavern.DiedPastCheckpoint = false
  GeneralFunctions.PanCamera()
  AI:EnableCharacterAI(partner)
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
  GAME:CutsceneMode(false)
end
