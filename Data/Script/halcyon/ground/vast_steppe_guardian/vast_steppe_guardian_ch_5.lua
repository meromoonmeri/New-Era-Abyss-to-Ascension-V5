--[[ 
    vast_steppe_guardian_ch_5.lua
    Grande Steppe — Gardien : Stantler Alpha
    Apparition silencieuse depuis la brume, bois luminescents
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

vast_steppe_guardian_ch_5 = {}

function vast_steppe_guardian_ch_5.FirstPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GROUND:TeleportTo(hero, 200, 400, Direction.Up)
  GROUND:TeleportTo(partner, 168, 400, Direction.Up)
  GAME:MoveCamera(184, 200, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Sky Peak Prairie.ogg', false)

  GAME:WaitFrames(40)
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(partner, Direction.Up, 60, false, 1)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(hero, Direction.Up, 60, false, 1)
  end)
  local coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(15)
    GAME:MoveCamera(184, 160, 60, false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_001']))
  -- "La brume est encore plus dense ici... C'est presque irréel."

  GAME:WaitFrames(30)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_002']))
  -- "C'est le cœur de la steppe. Il doit y avoir quelque chose qui protège cet endroit."

  GAME:WaitFrames(30)

  -- === VOIX → FLASH → EMERGENCE (BossFX standardise) ===
  SOUND:FadeOutBGM(60)
  GAME:WaitFrames(30)

  -- Brume montante
  BossFX.Overlay("Fog", 0, 0, 20, 70, 25, DrawLayer.Bottom, -1, 0)

  -- Voix de l'Abysse
  BossFX.Voice('VSG_004')

  -- Flash blanc
  local center = GAME:GetCameraCenter()
  BossFX.Flash(center.X, center.Y, 3, 5, 15)

  -- Tremblement puis materialisation depuis la brume
  local stantler = CharacterEssentials.MakeCharactersFromList({
    {'Stantler', 184, 200, Direction.Down}
  })
  GROUND:Hide('Stantler')
  BossFX.Rumble({hero, partner}, 2)
  BossFX.EmergeMist(stantler, stantler.Position.X + 8, stantler.Position.Y + 12)
  SOUND:PlayBGM('Rising Fear.ogg', true)
  GROUND:Unhide('Stantler')
  GROUND:CharSetAnim(stantler, "Charge", true)
  BossFX.Impact(9)

  coro1 = TASK:BranchCoroutine(function()
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
    GeneralFunctions.EmoteAndPause(partner, "Shock", true)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
    GeneralFunctions.EmoteAndPause(hero, "Exclaim", false)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_003']))
  -- "Ses bois...[pause=10] ils brillent !"

  GAME:WaitFrames(30)

  -- Voix a nouveau
  BossFX.Voice('VSG_006')
  GAME:WaitFrames(20)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_007']))
  -- "Prouve ta valeur, voyageur..."

  GAME:WaitFrames(30)

  -- Le Stantler frappe du sabot, le sol tremble
  BossFX.ShakeScreen(4, 20)
  GAME:WaitFrames(20)

  coro1 = TASK:BranchCoroutine(function()
    GROUND:AnimateInDirection(partner, "None", partner.Direction, Direction.Down, 2, 1, 1)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(5)
    GROUND:AnimateInDirection(hero, "None", hero.Direction, Direction.Down, 2, 1, 1)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_008']))
  -- "C'est le dernier obstacle avant la sortie de la steppe ! On y va !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  SV.Chapter5.SteppeGuardianSeen = true
  GAME:ContinueDungeon("vast_steppe", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function vast_steppe_guardian_ch_5.SecondPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local stantler = CharacterEssentials.MakeCharactersFromList({
    {'Stantler', 184, 200, Direction.Down}
  })

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()
  GROUND:CharSetAnim(stantler, "Charge", true)

  GROUND:TeleportTo(hero, 200, 360, Direction.Up)
  GROUND:TeleportTo(partner, 168, 360, Direction.Up)
  GAME:MoveCamera(184, 200, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Rising Fear.ogg', false)

  GAME:WaitFrames(30)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_009']))
  -- "On revient à la charge. Cette fois, c'est la bonne !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("vast_steppe", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function vast_steppe_guardian_ch_5.DefeatedBoss()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local stantler = CharacterEssentials.MakeCharactersFromList({
    {'Stantler', 184, 200, Direction.Down}
  })
  GROUND:CharSetAnim(stantler, "Charge", true)

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GROUND:TeleportTo(hero, 200, 300, Direction.Up)
  GROUND:TeleportTo(partner, 168, 300, Direction.Up)
  GAME:MoveCamera(184, 200, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Sky Peak Prairie.ogg', false)

  GAME:WaitFrames(30)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_010']))
  -- "On a vaincu le gardien de la steppe !"

  GAME:WaitFrames(20)

  -- The Stantler collapses, its antlers stop glowing
  local flash = RogueEssence.Content.FlashEmitter()
  flash.FadeInTime = 2
  flash.HoldTime = 2
  flash.FadeOutTime = 10
  flash.StartColor = Color(180, 220, 255, 0)
  flash.Layer = DrawLayer.Top
  flash.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(flash, stantler.Position.X, stantler.Position.Y)
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  GROUND:CharSetAction(stantler, RogueEssence.Ground.PoseGroundAction(
    stantler.Position, stantler.Direction,
    RogueEssence.Content.GraphicsManager.GetAnimIndex("Faint")))

  GAME:WaitFrames(60)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_011']))
  -- "La brume commence à se dissiper..."

  GAME:WaitFrames(20)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_012']))
  -- "Cette voix...[pause=15] Elle savait qu'il était là."

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['VSG_013']), "Normal")
  -- "On trouvera des réponses plus tard. Allons de l'avant."

  GAME:WaitFrames(60)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)
  GAME:CutsceneMode(false)
  -- Return to the expedition camp / next area
  GAME:EnterGroundMap("searing_tunnel_entrance", "Main_Entrance_Marker")
end

function vast_steppe_guardian_ch_5.DiedToBoss()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local stantler = CharacterEssentials.MakeCharactersFromList({
    {'Stantler', 184, 200, Direction.Down}
  })
  GROUND:CharSetAnim(stantler, "Idle", true)

  GROUND:Hide(partner.EntName)
  -- Le Gardien s'effondre, ses bois s'eteignent
  SOUND:PlayBattleSE('EVT_CH03_Boss_Collapse')
  BossFX.ShakeScreen(6, 20)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_021']))

  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_022']))

  UI:SetSpeaker(partner)
  GeneralFunctions.Hop(partner)
  UI:SetSpeakerEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_024']))
  GROUND:Hide(hero.EntName)

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GAME:MoveCamera(184, 200, 1, false)
  GAME:CutsceneMode(true)

  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  GAME:WaitFrames(40)

  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_014']))
  -- "Le Gardien ne pardonne pas la faiblesse."

  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_015']))
  -- "Retourne d'où tu viens. Reviens quand tu seras prêt."

  GAME:WaitFrames(40)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_025']))
  -- Le Gardien impavide
  GROUND:CharSetAnim(stantler, "Charge", true)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_018']))

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Pain")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSG_019']))
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)

  SV.TemporaryFlags.Dinnertime = true
  SV.TemporaryFlags.Bedtime = true
  SV.TemporaryFlags.MorningWakeup = true
  SV.TemporaryFlags.MorningAddress = true

  GAME:CutsceneMode(false)
  GAME:EnterGroundMap("vast_steppe_entrance", "Main_Entrance_Marker")
end

return vast_steppe_guardian_ch_5
