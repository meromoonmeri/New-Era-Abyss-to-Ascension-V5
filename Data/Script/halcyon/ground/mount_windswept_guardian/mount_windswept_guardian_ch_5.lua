--[[ 
    mount_windswept_guardian_ch_5.lua
    Mont Venteux — Gardien : Aerodactyl
    Apparition : Descend des nuages d'orage dans un cri perçant, fait trembler la montagne
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

mount_windswept_guardian_ch_5 = {}

function mount_windswept_guardian_ch_5.FirstPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GROUND:TeleportTo(hero, 240, 440, Direction.Up)
  GROUND:TeleportTo(partner, 208, 440, Direction.Up)
  GAME:MoveCamera(224, 240, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)

  -- Dramatic silence — wind howling
  SOUND:PlayBGM('Mt. Travail.ogg', false)

  GAME:WaitFrames(40)
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(partner, Direction.Up, 56, false, 1)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(hero, Direction.Up, 56, false, 1)
  end)
  local coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(15)
    GAME:MoveCamera(224, 180, 40, false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_001']))
  -- "Le sommet...[pause=15] On y est presque."

  GAME:WaitFrames(30)
  GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
  GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_002']))
  -- "Regarde le ciel...[pause=15] Ces nuages ne sont pas normaux."

  GAME:WaitFrames(30)

  GAME:WaitFrames(30)

  -- === STORM GATHERS — VOICE SPEAKS FIRST ===
  SOUND:FadeOutBGM(80)

  -- Dark clouds swirling overhead
  local darkCloud = RogueEssence.Content.FiniteOverlayEmitter()
  darkCloud.FadeIn = 60
  darkCloud.TotalTime = 140
  darkCloud.Layer = DrawLayer.Top
  darkCloud.Anim = RogueEssence.Content.BGAnimData("Cloudy_Sky", 0)
  GROUND:PlayVFX(darkCloud, 224, 100)

  GAME:WaitFrames(60)

  -- THE VOICE — before anything appears
  SOUND:PlayBattleSE('EVT_Emote_Shock_2')
  UI:SetSpeaker(STRINGS.Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS.Format(STRINGS.MapStrings['MWG_005']))
  -- "Le Prédateur Ancestral du Ciel..."

  GAME:WaitFrames(20)
  local coro_voice1 = TASK:BranchCoroutine(function()
    GeneralFunctions.LookAround(partner, 3, 4, true, true, false, Direction.UpLeft)
  end)
  local coro_voice2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GeneralFunctions.LookAround(hero, 3, 4, false, false, false, Direction.UpRight)
  end)
  TASK:JoinCoroutines({coro_voice1, coro_voice2})

  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS.Format(STRINGS.MapStrings['MWG_006']))
  -- "Toi...[pause=10] Tu savais qu'il était là !"

  GAME:WaitFrames(30)

  UI:SetSpeaker(STRINGS.Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS.Format(STRINGS.MapStrings['MWG_007']))
  -- "L'ultime gardien de la montagne..."

  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS.Format(STRINGS.MapStrings['MWG_008']))
  -- "Si tu triomphes ici..."

  GAME:WaitFrames(15)
  UI:WaitShowDialogue(STRINGS.Format(STRINGS.MapStrings['MWG_009']))
  -- "Échoue... et ton voyage s'arrête ici."

  GAME:WaitFrames(30)

  -- === WHITE FLASH + LIGHTNING STRIKE ===
  local center_flash = GAME:GetCameraCenter()
  local megaFlash = RogueEssence.Content.FlashEmitter()
  megaFlash.FadeInTime = 2
  megaFlash.HoldTime = 4
  megaFlash.FadeOutTime = 15
  megaFlash.StartColor = Color(255, 255, 255, 0)
  megaFlash.Layer = DrawLayer.Top
  megaFlash.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(megaFlash, center_flash.X, center_flash.Y)
  SOUND:PlayBattleSE('EVT_Battle_Flash')
  GROUND:MoveScreen(RogueEssence.Content.ScreenMover(4, 8, 20))

  GAME:WaitFrames(10)

  -- === AERODACTYL DESCENDS FROM THE FLASH ===
  SOUND:PlayBattleSE('_UNK_EVT_003')

  local aerodactyl = CharacterEssentials.MakeCharactersFromList({
    {'Aerodactyl', 224, 192, Direction.Down}
  })
  GROUND:Hide('Aerodactyl')

  -- Aerodactyl materializes from the lightning strike
  local diveEffect = RogueEssence.Content.StaticAnim(
    RogueEssence.Content.AnimData("Sacred_Fire_Ranger", 3), 2)
  diveEffect:SetupEmitted(
    RogueElements.Loc(aerodactyl.Position.X + 12, aerodactyl.Position.Y),
    60, RogueElements.Dir8.Down)
  GROUND:PlayVFXAnim(diveEffect, RogueEssence.Content.DrawLayer.Front)

  SOUND:PlayBGM('Rising Fear.ogg', true)
  GAME:WaitFrames(15)
  GROUND:Unhide('Aerodactyl')
  GROUND:CharSetAnim(aerodactyl, "Charge", true)

  -- Impact — ground shakes, dust everywhere
  local impactDust = RogueEssence.Content.FiniteOverlayEmitter()
  impactDust.FadeIn = 5
  impactDust.TotalTime = 50
  impactDust.Movement = RogueElements.Loc(-40, 0)
  impactDust.Layer = DrawLayer.Front
  impactDust.Anim = RogueEssence.Content.BGAnimData("Sandstorm", 1)
  GROUND:PlayVFX(impactDust, aerodactyl.Position.X - 24, aerodactyl.Position.Y + 16)

  local impactDust2 = RogueEssence.Content.FiniteOverlayEmitter()
  impactDust2.FadeIn = 5
  impactDust2.TotalTime = 50
  impactDust2.Movement = RogueElements.Loc(40, 0)
  impactDust2.Layer = DrawLayer.Front
  impactDust2.Anim = RogueEssence.Content.BGAnimData("Sandstorm", 1)
  GROUND:PlayVFX(impactDust2, aerodactyl.Position.X + 24, aerodactyl.Position.Y + 16)

  GROUND:MoveScreen(RogueEssence.Content.ScreenMover(3, 5, 30))

  GAME:WaitFrames(15)
  SOUND:PlayBattleSE('EVT_Battle_Flash')

  -- Push the team back with the shockwave
  GAME:WaitFrames(20)
  local coro_push1 = TASK:BranchCoroutine(function()
    GROUND:AnimateInDirection(partner, "None", partner.Direction, Direction.Down, 8, 1, 1)
    GROUND:AnimateInDirection(partner, "Hurt", Direction.Down, Direction.Down, 8, 1, 2)
    BossFX.Impact(12)
  -- Signature ROCHE : l'impact fait s'ebouler la paroi, des blocs
  -- degringolent autour de l'arene.
  BossFX.RockFall(224, 200)
  BossFX.Particle("Rock_Pieces", 196, 208, 3)
  BossFX.Particle("Rock_Pieces", 252, 208, 3)
  end)
  local coro_push2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:AnimateInDirection(hero, "None", hero.Direction, Direction.Down, 8, 1, 1)
    GROUND:AnimateInDirection(hero, "Hurt", Direction.Down, Direction.Down, 8, 1, 2)
  end)
  TASK:JoinCoroutines({coro_push1, coro_push2})

  GAME:WaitFrames(30)
  GROUND:CharSetEmote(partner, "shock", 1)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS.Format(STRINGS.MapStrings['MWG_004']))
  -- "Un...[pause=10] UN AERODACTYL !"

  GAME:WaitFrames(30)
  -- Aerodactyl spreads its wings and roars
  GROUND:CharSetAnim(aerodactyl, "Charge", true)
  local wingWind = RogueEssence.Content.FiniteOverlayEmitter()
  wingWind.FadeIn = 10
  wingWind.TotalTime = 40
  wingWind.RepeatX = true
  wingWind.Movement = RogueElements.Loc(-180, 0)
  wingWind.Layer = DrawLayer.Front
  wingWind.Anim = RogueEssence.Content.BGAnimData("Ominous_Wind", 1)
  GROUND:PlayVFX(wingWind, aerodactyl.Position.X, aerodactyl.Position.Y)

  local wingWind2 = RogueEssence.Content.FiniteOverlayEmitter()
  wingWind2.FadeIn = 10
  wingWind2.TotalTime = 40
  wingWind2.RepeatX = true
  wingWind2.Movement = RogueElements.Loc(180, 0)
  wingWind2.Layer = DrawLayer.Front
  wingWind2.Anim = RogueEssence.Content.BGAnimData("Ominous_Wind", 1)
  GROUND:PlayVFX(wingWind2, aerodactyl.Position.X, aerodactyl.Position.Y)

  SOUND:PlayBattleSE('EVT_Battle_Transition')
  GAME:WaitFrames(20)

  coro1 = TASK:BranchCoroutine(function()
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(10)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_010']))
  -- "Alors on va lui montrer que notre voyage ne fait que commencer ! [hero], à nous deux !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  SV.Chapter5.MountGuardianSeen = true
  GAME:ContinueDungeon("mount_windswept", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function mount_windswept_guardian_ch_5.SecondPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local aerodactyl = CharacterEssentials.MakeCharactersFromList({
    {'Aerodactyl', 224, 192, Direction.Down}
  })

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()
  GROUND:CharSetAnim(aerodactyl, "Charge", true)

  GROUND:TeleportTo(hero, 240, 380, Direction.Up)
  GROUND:TeleportTo(partner, 208, 380, Direction.Up)
  GAME:MoveCamera(224, 240, 1, false)

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
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_011']))
  -- "Cette fois, on le terrasse. Promis, [hero]."

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("mount_windswept", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function mount_windswept_guardian_ch_5.DefeatedBoss()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local aerodactyl = CharacterEssentials.MakeCharactersFromList({
    {'Aerodactyl', 224, 192, Direction.Down}
  })
  GROUND:CharSetAnim(aerodactyl, "Charge", true)

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GROUND:TeleportTo(hero, 240, 340, Direction.Up)
  GROUND:TeleportTo(partner, 208, 340, Direction.Up)
  GAME:MoveCamera(224, 240, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  GAME:WaitFrames(40)

  -- Aerodactyl collapses dramatically
  SOUND:PlayBattleSE('EVT_CH03_Boss_Collapse')
  GROUND:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 20))
  GROUND:CharSetAction(aerodactyl, RogueEssence.Ground.PoseGroundAction(
    aerodactyl.Position, aerodactyl.Direction,
    RogueEssence.Content.GraphicsManager.GetAnimIndex("Faint")))

  GAME:WaitFrames(60)

  -- The storm clears
  SOUND:PlayBGM('In the Depths of the Pit.ogg', false)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_012']))
  -- "On...[pause=10] On l'a vaincu !"

  GAME:WaitFrames(30)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_013']))
  -- "Regarde ! L'orage se dissipe..."

  GAME:WaitFrames(20)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_014']))
  -- "Cette voix...[pause=15] Elle a dit quelque chose à propos de ruines ancestrales."

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWG_015']), "Determined")
  -- "C'est là qu'on va. Vers les Ruines du Cloven."

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_016']))
  -- "Alors allons-y ! La fin de l'expédition nous attend !"

  GAME:WaitFrames(30)
  SOUND:FadeOutBGM(60)

  -- Aerodactyl disappears in a whirlwind
  local whirlwind = RogueEssence.Content.FlashEmitter()
  whirlwind.FadeInTime = 2
  whirlwind.HoldTime = 2
  whirlwind.FadeOutTime = 20
  whirlwind.StartColor = Color(200, 200, 255, 0)
  whirlwind.Layer = DrawLayer.Top
  whirlwind.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(whirlwind, aerodactyl.Position.X, aerodactyl.Position.Y)
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  GAME:WaitFrames(16)
  GROUND:Hide('Aerodactyl')
  GAME:WaitFrames(40)

  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)
  GAME:CutsceneMode(false)

  --Le sommet est vaincu : l'expedition du chapitre 5 est terminee.
  --On renvoyait vers "cloven_ruins", carte qui n'existe pas (la zone est
  --Released=false, 0 segment) -> ecran noir apres la victoire finale.
  --On cloture proprement : bascule chapitre 6, fin de journee a la guilde.
  SV.Chapter5.FinishedExpedition = true
  SV.ChapterProgression.Chapter = 6
  SV.TemporaryFlags.Dinnertime = true
  SV.TemporaryFlags.Bedtime = true
  SV.TemporaryFlags.MorningWakeup = true
  SV.TemporaryFlags.MorningAddress = true

  local exit_ground = 6
  if SV.TemporaryFlags.MissionCompleted then exit_ground = 22 end
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    "master_zone", -1, exit_ground, 0, true, true)
end

function mount_windswept_guardian_ch_5.DiedToBoss()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local aerodactyl = CharacterEssentials.MakeCharactersFromList({
    {'Aerodactyl', 224, 192, Direction.Down}
  })
  GROUND:CharSetAnim(aerodactyl, "Idle", true)

  GROUND:Hide(partner.EntName)
  -- L'Aerodactyl te regarde avec respect
  GROUND:CharEndAnim(aerodactyl)
  GROUND:CharSetAnim(aerodactyl, "Idle", true)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_025']))

  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_026']))

  UI:SetSpeaker(partner)
  GeneralFunctions.Hop(partner)
  UI:SetSpeakerEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_028']))
  GROUND:Hide(hero.EntName)

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GAME:MoveCamera(224, 240, 1, false)
  GAME:CutsceneMode(true)

  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  GAME:WaitFrames(40)

  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_017']))
  -- "L'ancien prédateur ne fait pas de quartier..."

  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_018']))
  -- "Mais la proie d'aujourd'hui est le chasseur de demain."

  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_019']))
  -- "Repose-toi. Le sommet t'attendra."

  GAME:WaitFrames(40)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_029']))
  -- L'Aerodactyl crie sa domination
  GROUND:CharSetAnim(aerodactyl, "Charge", true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_021']))

  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_022']))

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Pain")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_023']))
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)

  SV.TemporaryFlags.Dinnertime = true
  SV.TemporaryFlags.Bedtime = true
  SV.TemporaryFlags.MorningWakeup = true
  SV.TemporaryFlags.MorningAddress = true

  GAME:CutsceneMode(false)
  GAME:EnterGroundMap("mount_windswept_entrance", "Main_Entrance_Marker")
end

return mount_windswept_guardian_ch_5
