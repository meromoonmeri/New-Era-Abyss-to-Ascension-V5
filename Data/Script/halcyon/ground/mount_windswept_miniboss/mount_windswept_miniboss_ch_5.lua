--[[ 
    mount_windswept_miniboss_ch_5.lua
    Mont Venteux — Mini-Boss : Gligar + Skarmory
    Apparition : Gligar sort d'une crevasse, Skarmory fond du ciel en piqué
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

mount_windswept_miniboss_ch_5 = {}

function mount_windswept_miniboss_ch_5.FirstPreBossScene()
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

  SOUND:PlayBGM('Mt. Travail.ogg', false)

  GAME:WaitFrames(30)
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(partner, Direction.Up, 72, false, 1)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(hero, Direction.Up, 72, false, 1)
  end)
  local coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    GAME:MoveCamera(224, 180, 60, false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_001']))
  -- "Ce vent est impitoyable... On doit être sacrément haut maintenant."

  GAME:WaitFrames(20)
  GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
  GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_002']))
  -- "Hé...[pause=10] tu as senti ça ? Le sol a tremblé."

  GAME:WaitFrames(30)

  -- === WIND INTENSIFIES, ROCKS START FALLING ===
  SOUND:FadeOutBGM(60)

  local windEmitter = RogueEssence.Content.FiniteOverlayEmitter()
  windEmitter.FadeIn = 30
  windEmitter.TotalTime = 90
  windEmitter.RepeatX = true
  windEmitter.Movement = RogueElements.Loc(-360, 0)
  windEmitter.Layer = DrawLayer.Back
  windEmitter.Anim = RogueEssence.Content.BGAnimData("Ominous_Wind", 0)
  GROUND:PlayVFX(windEmitter, 224, 160)

  SOUND:LoopSE("Heavy Earthquake")
  local continueShake = true
  coro1 = TASK:BranchCoroutine(function()
    while continueShake do
      GROUND:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 30))
      GAME:WaitFrames(30)
    end
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    GeneralFunctions.EmoteAndPause(partner, "Shock", true)
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("Surprised")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_003']))
    -- "Un éboulement !"
    continueShake = false
  end)
  coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(26)
    GeneralFunctions.EmoteAndPause(hero, "Exclaim", false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  SOUND:FadeOutSE("Heavy Earthquake", 40)
  GAME:WaitFrames(20)

  -- === LA VOIX DE L'ABYSSE PARLE EN PREMIER ===
  -- Ordre impose : Voix -> Flash -> Emergence thematique. Avant, les deux
  -- boss apparaissaient puis la Voix commentait apres coup.
  BossFX.Voice('MWM_006')
  -- "Les Sentinelles du Pic..."
  GAME:WaitFrames(20)

  -- === FLASH BLANC ===
  BossFX.Flash(224, 220)
  GAME:WaitFrames(10)

  -- === GLIGAR JAILLIT DE LA CREVASSE (signature SOL) ===
  -- Le sol se fissure, gerbes de terre, emergence facon Fouille.
  local gligar = CharacterEssentials.MakeCharactersFromList({
    {'Gligar', 180, 240, Direction.DownRight}
  })
  GROUND:Hide('Gligar')
  BossFX.EmergeGround(gligar, 180, 240)
  SOUND:PlayBattleSE('_UNK_EVT_102')
  GROUND:CharSetAnim(gligar, "Idle", true)
  -- le souffle repousse toute l'equipe, pas seulement le partenaire
  BossFX.Impact(9)

  GAME:WaitFrames(20)
  coro1 = TASK:BranchCoroutine(function()
    GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
    GROUND:AnimateInDirection(partner, "None", partner.Direction, Direction.Right, 4, 1, 1)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_004']))
  -- "Un Gligar est sorti de la paroi !"

  GAME:WaitFrames(20)

  -- === SKARMORY DIVE-BOMBS FROM THE SKY ===
  local skarmory = CharacterEssentials.MakeCharactersFromList({
    {'Skarmory', 268, 192, Direction.DownLeft}
  })
  GROUND:Hide('Skarmory')

  -- === SKARMORY FOND DU CIEL (signature VOL / ACIER) ===
  -- Descente verticale reelle depuis hors-ecran, plumes, impact au sol,
  -- puis recul de toute l'equipe.
  BossFX.DescendSky(skarmory, 268, 192, 150)
  BossFX.Particle("Steel_Wing", 268, 196, 3)
  GROUND:CharSetAnim(skarmory, "Idle", true)

  SOUND:PlayBGM('Rising Fear.ogg', true)

  GAME:WaitFrames(20)
  coro1 = TASK:BranchCoroutine(function()
    GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
    GeneralFunctions.EmoteAndPause(hero, "Exclaim", false)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(15)
  GROUND:CharSetEmote(partner, "shock", 1)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_005']))
  -- "Un Skarmory en piqué ! Ils sont deux !"

  GAME:WaitFrames(30)

  GAME:WaitFrames(20)
  coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.LookAround(partner, 2, 4, true, false, false, Direction.UpRight)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GeneralFunctions.LookAround(hero, 2, 4, false, false, false, Direction.UpLeft)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_007']))
  -- "Encore toi ! Qui es-tu ?!"

  GAME:WaitFrames(30)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_008']))
  -- "L'un maîtrise la terre, l'autre les cieux. Ensemble, ils sont presque invincibles."

  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_009']))
  -- "Mais chaque sentinelle a sa faiblesse... Trouve-la."

  GAME:WaitFrames(30)

  -- Gligar snaps its claws, Skarmory screeches
  coro1 = TASK:BranchCoroutine(function()
    GROUND:CharSetAnim(gligar, "Idle", true)
    GeneralFunctions.Hop(gligar)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    GROUND:CharSetAnim(skarmory, "Idle", true)
    SOUND:PlayBattleSE('EVT_Emote_Exclaim_2')
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_010']))
  -- "On va leur montrer de quel bois on se chauffe ! À l'attaque !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  SV.Chapter5.MountMiniBossSeen = true
  GAME:ContinueDungeon("mount_windswept", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function mount_windswept_miniboss_ch_5.SecondPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local gligar = CharacterEssentials.MakeCharactersFromList({
    {'Gligar', 180, 240, Direction.Down}
  })
  local skarmory = CharacterEssentials.MakeCharactersFromList({
    {'Skarmory', 268, 192, Direction.Down}
  })

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()
  GROUND:CharSetAnim(gligar, "Idle", true)
  GROUND:CharSetAnim(skarmory, "Idle", true)

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
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_011']))
  -- "On n'abandonne pas. Cette fois, on passe !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("mount_windswept", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function mount_windswept_miniboss_ch_5.DefeatedBoss()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local gligar = CharacterEssentials.MakeCharactersFromList({
    {'Gligar', 180, 240, Direction.Down}
  })
  local skarmory = CharacterEssentials.MakeCharactersFromList({
    {'Skarmory', 268, 192, Direction.Down}
  })

  GROUND:CharSetAction(gligar, RogueEssence.Ground.PoseGroundAction(
    gligar.Position, gligar.Direction,
    RogueEssence.Content.GraphicsManager.GetAnimIndex("Faint")))
  GROUND:CharSetAction(skarmory, RogueEssence.Ground.PoseGroundAction(
    skarmory.Position, skarmory.Direction,
    RogueEssence.Content.GraphicsManager.GetAnimIndex("Faint")))

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GROUND:TeleportTo(hero, 240, 340, Direction.Up)
  GROUND:TeleportTo(partner, 208, 340, Direction.Up)
  GAME:MoveCamera(224, 240, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Mt. Travail.ogg', false)

  GAME:WaitFrames(30)
  UI:SetSpeaker(partner)
  GeneralFunctions.Hop(partner)
  UI:SetSpeakerEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_012']))
  -- "On a eu le dessus ! Ces deux-là ne nous arrêteront plus."

  GAME:WaitFrames(20)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_013']))
  -- "Cette voix...[pause=15] Elle nous a donné un indice, tu crois ?"

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWM_014']), "Worried")
  -- "Peut-être. Ou peut-être qu'elle veut juste nous voir réussir."

  GAME:WaitFrames(20)

  local fadeEmitter = RogueEssence.Content.FlashEmitter()
  fadeEmitter.FadeInTime = 2
  fadeEmitter.HoldTime = 2
  fadeEmitter.FadeOutTime = 20
  fadeEmitter.StartColor = Color(255, 255, 255, 0)
  fadeEmitter.Layer = DrawLayer.Top
  fadeEmitter.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(fadeEmitter, 224, 220)
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  GAME:WaitFrames(16)
  GROUND:Hide('Gligar')
  GROUND:Hide('Skarmory')
  GAME:WaitFrames(40)

  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)
  GAME:CutsceneMode(false)
  GAME:EnterGroundMap("mount_windswept_midpoint", "Main_Entrance_Marker")
end

function mount_windswept_miniboss_ch_5.DiedToBoss()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local gligar = CharacterEssentials.MakeCharactersFromList({
    {'Gligar', 180, 240, Direction.Down}
  })
  local skarmory = CharacterEssentials.MakeCharactersFromList({
    {'Skarmory', 268, 192, Direction.Down}
  })
  GROUND:CharSetAnim(gligar, "Idle", true)
  GROUND:CharSetAnim(skarmory, "Idle", true)

  GROUND:Hide(partner.EntName)
  -- Gligar te regarde, reconnait ta force
  GROUND:CharSetAnim(gligar, "Idle", true)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_022']))

  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_023']))

  UI:SetSpeaker(partner)
  GeneralFunctions.Hop(partner)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_025']))
  GROUND:Hide(hero.EntName)

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GAME:MoveCamera(224, 240, 1, false)
  GAME:CutsceneMode(true)

  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  GAME:WaitFrames(40)

  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_015']))
  -- "Les sentinelles t'ont repoussé..."

  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_016']))
  -- "Apprends de cette défaite. Le sommet n'attend que les plus forts."

  GAME:WaitFrames(40)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_026']))
  -- Gligar triomphe, Skarmory plane
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_018']))

  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_019']))

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Pain")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWM_020']))
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)

  SV.TemporaryFlags.Dinnertime = true
  SV.TemporaryFlags.Bedtime = true
  SV.TemporaryFlags.MorningWakeup = true
  SV.TemporaryFlags.MorningAddress = true

  GAME:CutsceneMode(false)
  GAME:EnterGroundMap("mount_windswept_entrance", "Main_Entrance_Marker")
end

return mount_windswept_miniboss_ch_5
