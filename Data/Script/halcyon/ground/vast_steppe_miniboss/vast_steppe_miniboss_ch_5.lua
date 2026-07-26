--[[ 
    vast_steppe_miniboss_ch_5.lua
    Grande Steppe — Mini-Boss : Stantler + Mudbray
    Apparition : Mudbray surgit du sol, Stantler émerge de la brume
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

vast_steppe_miniboss_ch_5 = {}

function vast_steppe_miniboss_ch_5.FirstPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  -- Position the team entering the deep steppe
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

  -- Party walks forward into the misty steppe
  GAME:WaitFrames(30)
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(partner, Direction.Up, 80, false, 1)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(hero, Direction.Up, 80, false, 1)
  end)
  local coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    GAME:MoveCamera(184, 160, 60, false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_001']))
  -- "Cette brume est de plus en plus épaisse... On n'y voit presque rien."

  GAME:WaitFrames(20)
  GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
  GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_002']))
  -- "Hé, [hero]... Tu as l'impression qu'on est observés ?"

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['VSM_003']), "Worried")
  -- "...Oui. Depuis un moment déjà."

  GAME:WaitFrames(40)

  -- === SOUND: distant rumbling, the ground begins to shake ===
  SOUND:FadeOutBGM(60)
  SOUND:PlayBattleSE('_UNK_EVT_102')
  local continueShake = true
  coro1 = TASK:BranchCoroutine(function()
    while continueShake do
      GROUND:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 30))
      GAME:WaitFrames(30)
    end
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    GeneralFunctions.EmoteAndPause(partner, "Shock", true)
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("Surprised")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_004']))
    -- "Qu'est-ce que...?!
    continueShake = false
  end)
  coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(16)
    GeneralFunctions.EmoteAndPause(hero, "Exclaim", false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  GAME:WaitFrames(20)

  -- === VOICE OF THE ABYSS SPEAKS FIRST ===
  -- The tremors stop. An eerie silence falls.
  GAME:WaitFrames(30)

  SOUND:PlayBattleSE('EVT_Emote_Shock_2')
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_007']))
  -- "La harde protège son territoire..."

  GAME:WaitFrames(20)
  coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.LookAround(partner, 2, 4, true, true, false, Direction.Down)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GeneralFunctions.LookAround(hero, 2, 4, false, false, false, Direction.Left)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(10)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  GROUND:CharSetEmote(partner, "shock", 1)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_008']))
  -- "Qui... qui a dit ça ?!"

  GAME:WaitFrames(30)

  -- === WHITE FLASH ===
  local center = GAME:GetCameraCenter()
  BossFX.Flash(center.X, center.Y, 3, 4, 10)
  GAME:WaitFrames(20)

  -- === MUDBRAY ERUPTS FROM THE EARTH (BossFX type Sol) ===
  local mudbray = CharacterEssentials.MakeCharactersFromList({
    {'Mudbray', 184, 232, Direction.Down}
  })
  GROUND:Hide('Mudbray')

  -- Grondement + fissures, puis jaillissement facon Fouille
  BossFX.Rumble({hero, partner}, 3)
  BossFX.EmergeGround(mudbray, mudbray.Position.X + 8, mudbray.Position.Y + 12)
  GROUND:Unhide('Mudbray')
  GROUND:CharSetAnim(mudbray, "Idle", true)

  GAME:WaitFrames(15)
  BossFX.Impact(9, {mudbray})
  GAME:WaitFrames(10)

  GeneralFunctions.EmoteAndPause(partner, "Shock", true)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_005']))
  -- "Un Pokémon a surgi du sol !"

  GAME:WaitFrames(20)

  -- === SECOND WHITE FLASH — STANTLER EMERGES FROM THE MIST ===
  BossFX.Flash(center.X, center.Y, 2, 4, 18)

  local stantler = CharacterEssentials.MakeCharactersFromList({
    {'Stantler', 152, 200, Direction.DownRight}
  })
  GROUND:Hide('Stantler')

  -- Brume qui se condense, silhouette qui se materialise
  SOUND:PlayBGM('Rising Fear.ogg', true)
  BossFX.EmergeMist(stantler, stantler.Position.X + 8, stantler.Position.Y + 12)
  GROUND:Unhide('Stantler')
  GROUND:CharSetAnim(stantler, "Charge", true)

  -- Stantler steps forward through the mist
  GAME:WaitFrames(15)
  coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(stantler, Direction.Down, 28, false, 1)
    GROUND:CharAnimateTurnTo(stantler, Direction.Down, 4)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(15)
    GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
  end)
  coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  GAME:WaitFrames(20)
  GROUND:CharSetEmote(partner, "sweating", 1)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_006']))
  -- "Et celui-là... il nous attendait."

  GAME:WaitFrames(30)

  -- === VOICE SPEAKS AGAIN ===
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_009']))
  -- "Peu importe qui je suis. Ces créatures ne te laisseront pas passer sans combattre."

  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_010']))
  -- "Montre-leur ta détermination... ou péris."

  GAME:WaitFrames(40)

  -- === Mudbray stomps, Stantler roars ===
  coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.Hop(mudbray)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    SOUND:PlayBattleSE('EVT_Emote_Exclaim_2')
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_011']))
  -- "Pas le choix ! [hero], on se bat !"

  -- === BOSS TRANSITION ===
  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  SV.Chapter5.SteppeMiniBossSeen = true
  GAME:ContinueDungeon("vast_steppe", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

-- Second encounter (if player died and returns)
function vast_steppe_miniboss_ch_5.SecondPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  local mudbray = CharacterEssentials.MakeCharactersFromList({
    {'Mudbray', 184, 232, Direction.Down}
  })
  local stantler = CharacterEssentials.MakeCharactersFromList({
    {'Stantler', 152, 200, Direction.Down}
  })

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()
  GROUND:CharSetAnim(mudbray, "Idle", true)
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
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_012']))
  -- "Ils sont encore là... Cette fois, on ne perd pas !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("vast_steppe", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

-- Player defeated the mini-boss
function vast_steppe_miniboss_ch_5.DefeatedBoss()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  local mudbray = CharacterEssentials.MakeCharactersFromList({
    {'Mudbray', 184, 232, Direction.Down}
  })
  local stantler = CharacterEssentials.MakeCharactersFromList({
    {'Stantler', 152, 200, Direction.Down}
  })

  GROUND:CharSetAction(mudbray, RogueEssence.Ground.PoseGroundAction(
    mudbray.Position, mudbray.Direction,
    RogueEssence.Content.GraphicsManager.GetAnimIndex("Faint")))
  GROUND:CharSetAnim(stantler, "Charge", true)

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GROUND:TeleportTo(hero, 200, 300, Direction.Up)
  GROUND:TeleportTo(partner, 168, 300, Direction.Up)
  GAME:MoveCamera(184, 200, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  SOUND:PlayBGM('In the Depths of the Pit.ogg', false)

  GAME:WaitFrames(30)
  UI:SetSpeaker(partner)
  GeneralFunctions.Hop(partner)
  UI:SetSpeakerEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_013']))
  -- "On a réussi ! Ces deux-là étaient coriaces..."

  GAME:WaitFrames(20)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_014']))
  -- "Mais cette voix... Qui était-ce ?"

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['VSM_015']), "Worried")
  -- "Je ne sais pas. Continuons d'avancer."

  GAME:WaitFrames(30)
  -- Mudbray and Stantler fade/disappear into the mist
  SOUND:FadeOutBGM(60)
  local emitter = RogueEssence.Content.FlashEmitter()
  emitter.FadeInTime = 2
  emitter.HoldTime = 2
  emitter.FadeOutTime = 20
  emitter.StartColor = Color(255, 255, 255, 0)
  emitter.Layer = DrawLayer.Top
  emitter.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(emitter, mudbray.Position.X, mudbray.Position.Y)
  GROUND:PlayVFX(emitter, stantler.Position.X, stantler.Position.Y)
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  GAME:WaitFrames(16)
  GROUND:Hide('Mudbray')
  GROUND:Hide('Stantler')
  GAME:WaitFrames(40)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_016']))
  -- "Ils ont disparu... Allez, on continue la mission."

  GAME:WaitFrames(60)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)
  GAME:CutsceneMode(false)
  GAME:EnterGroundMap("vast_steppe_midpoint", "Main_Entrance_Marker")
end

-- Player died to the mini-boss
function vast_steppe_miniboss_ch_5.DiedToBoss()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  local mudbray = CharacterEssentials.MakeCharactersFromList({
    {'Mudbray', 184, 232, Direction.Down}
  })
  local stantler = CharacterEssentials.MakeCharactersFromList({
    {'Stantler', 152, 200, Direction.Down}
  })

  GROUND:CharSetAnim(mudbray, "Idle", true)
  GROUND:CharSetAnim(stantler, "Idle", true)

  GROUND:Hide(partner.EntName)
  -- Stantler te fixe longuement, puis s'incline
  GROUND:CharSetAnim(stantler, "Idle", true)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_024']))

  -- La Voix de l'Abysse
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_025']))

  UI:SetSpeaker(partner)
  GeneralFunctions.Hop(partner)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_027']))
  GROUND:Hide(hero.EntName)

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GAME:MoveCamera(184, 200, 1, false)
  GAME:CutsceneMode(true)

  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  GAME:WaitFrames(40)

  -- The Voice of the Abyss comments on the defeat
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_017']))
  -- "Pas encore assez fort..."

  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_018']))
  -- "Mais tu te relèveras. Ils se relèvent toujours."

  GAME:WaitFrames(40)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_028']))
  -- Mudbray triomphe, Stantler observe
  GROUND:CharSetEmote(mudbray, "happy", 1)
  GeneralFunctions.Hop(mudbray)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_020']))

  -- La Voix commente
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_021']))

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Pain")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_022']))
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)

  SV.TemporaryFlags.Dinnertime = true
  SV.TemporaryFlags.Bedtime = true
  SV.TemporaryFlags.MorningWakeup = true
  SV.TemporaryFlags.MorningAddress = true

  GAME:CutsceneMode(false)
  GAME:EnterGroundMap("vast_steppe_entrance", "Main_Entrance_Marker")
end

return vast_steppe_miniboss_ch_5
