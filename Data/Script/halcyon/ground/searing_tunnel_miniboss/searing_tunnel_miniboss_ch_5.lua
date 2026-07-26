--[[ 
    searing_tunnel_miniboss_ch_5.lua
    Tunnel Incandescent — Mini-Boss : Torkoal + Magmar
    Apparition : Torkoal émerge de la vapeur, Magmar tombe du plafond en flammes
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

searing_tunnel_miniboss_ch_5 = {}

function searing_tunnel_miniboss_ch_5.FirstPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GROUND:TeleportTo(hero, 240, 440, Direction.Up)
  GROUND:TeleportTo(partner, 272, 440, Direction.Up)
  GAME:MoveCamera(256, 240, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Spring Cave.ogg', false)

  -- Team walks through the tunnel
  GAME:WaitFrames(30)
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(partner, Direction.Up, 64, false, 1)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(hero, Direction.Up, 64, false, 1)
  end)
  local coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    GAME:MoveCamera(256, 200, 60, false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_001']))
  -- "Cette chaleur devient étouffante... On doit approcher d'une poche de magma."

  GAME:WaitFrames(20)
  GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
  GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_002']))
  -- "Tu entends ça, [hero] ? On dirait... de la vapeur sous pression."

  GAME:WaitFrames(30)

  -- === STEAM BEGINS TO FILL THE CHAMBER ===
  SOUND:FadeOutBGM(40)
  SOUND:LoopSE("Light Earthquake")

  local steamEmitter = RogueEssence.Content.FiniteOverlayEmitter()
  steamEmitter.FadeIn = 40
  steamEmitter.TotalTime = 120
  steamEmitter.Layer = DrawLayer.Back
  steamEmitter.Anim = RogueEssence.Content.BGAnimData("Steam", 2)
  GROUND:PlayVFX(steamEmitter, 256, 200)

  local continueSteam = true
  coro1 = TASK:BranchCoroutine(function()
    while continueSteam do
      GROUND:MoveScreen(RogueEssence.Content.ScreenMover(1, 3, 30))
      GAME:WaitFrames(30)
    end
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_003']))
    -- "De la vapeur ! Elle vient de partout !"
    continueSteam = false
  end)
  coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(26)
    GeneralFunctions.EmoteAndPause(hero, "Sweatdrop", false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  SOUND:FadeOutSE("Light Earthquake", 30)
  GAME:WaitFrames(30)

  -- === LA VOIX DE L'ABYSSE PARLE EN PREMIER ===
  -- Ordre impose : Voix -> Flash -> Emergence thematique.
  BossFX.Voice('STM_006')
  GAME:WaitFrames(20)

  -- === FLASH BLANC ===
  BossFX.Flash(256, 220)
  GAME:WaitFrames(10)

  -- === TORKOAL EMERGE DE LA LAVE (signature FEU) ===
  -- Vapeur sous pression, panache de lave, braises : pas un simple flash.
  local torkoal = CharacterEssentials.MakeCharactersFromList({
    {'Torkoal', 220, 232, Direction.DownRight}
  })
  GROUND:Hide('Torkoal')
  BossFX.EmergeFire(torkoal, 220, 232)
  SOUND:PlayBattleSE('_UNK_EVT_102')
  BossFX.Impact(8)

  -- Braises jaillissant de la carapace de Torkoal.
  -- "Ember" est une PARTICULE (Content/Particle) : elle doit passer par un
  -- SingleEmitter/AnimData. En BGAnimData l'effet ne s'affichait pas du tout.
  BossFX.Particle("Ember", 220, 232, 4)
  BossFX.Particle("Ember", 204, 238, 5)
  BossFX.Particle("Ember", 236, 238, 5)

  GAME:WaitFrames(20)

  coro1 = TASK:BranchCoroutine(function()
    GROUND:AnimateInDirection(partner, "None", partner.Direction, Direction.Down, 4, 1, 1)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GROUND:AnimateInDirection(hero, "None", hero.Direction, Direction.Left, 4, 1, 1)
    GeneralFunctions.EmoteAndPause(hero, "Exclaim", false)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_004']))
  -- "Un Torkoal ! Il nous barre la route !"

  GAME:WaitFrames(20)

  -- === MAGMAR TOMBE DU PLAFOND EN FLAMMES (signature FEU) ===
  local magmar = CharacterEssentials.MakeCharactersFromList({
    {'Magmar', 292, 208, Direction.DownLeft}
  })
  GROUND:Hide('Magmar')
  GROUND:TeleportTo(magmar, 292, 208 - 140, Direction.Down)
  GROUND:Unhide('Magmar')
  BossFX.Particle("Lava_Plume_Fire", 292, 208 - 120, 3)
  SOUND:PlayBattleSE('DUN_Fire_Spin')
  GROUND:MoveToPosition(magmar, 292, 208, false, 7)
  BossFX.Particle("Fire_Blast", 292, 212, 3)
  BossFX.Particle("Ember", 276, 214, 4)
  BossFX.Particle("Ember", 308, 214, 4)
  BossFX.Flash(292, 208)
  BossFX.Impact(10)
  GROUND:CharSetAnim(magmar, "Idle", true)

  GAME:WaitFrames(20)
  coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.LookAround(partner, 2, 4, true, false, false, Direction.Down)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GeneralFunctions.LookAround(hero, 2, 4, false, false, false, Direction.Right)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  GROUND:CharSetEmote(partner, "shock", 1)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_007']))
  -- "Cette voix, encore !"

  GAME:WaitFrames(30)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_008']))
  -- "Ils gardent les fournaises depuis des siècles. Leur chaleur te consumera."

  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_009']))
  -- "À moins que tu ne prouves ta propre flamme..."

  GAME:WaitFrames(30)

  -- Torkoal releases smoke, Magmar crackles with fire
  coro1 = TASK:BranchCoroutine(function()
    GROUND:CharSetAnim(torkoal, "Idle", true)
    local smoke = RogueEssence.Content.FiniteOverlayEmitter()
    smoke.FadeIn = 10
    smoke.TotalTime = 50
    smoke.Layer = DrawLayer.Front
    smoke.Anim = RogueEssence.Content.BGAnimData("Fog", 0)
    GROUND:PlayVFX(smoke, torkoal.Position.X, torkoal.Position.Y - 16)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    BossFX.Particle("Ember", magmar.Position.X, magmar.Position.Y, 4)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_010']))
  -- "On n'a pas fait tout ce chemin pour rien ! [hero], en avant !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  SV.Chapter5.TunnelMiniBossSeen = true
  GAME:ContinueDungeon("searing_tunnel", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function searing_tunnel_miniboss_ch_5.SecondPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local torkoal = CharacterEssentials.MakeCharactersFromList({
    {'Torkoal', 220, 232, Direction.Down}
  })
  local magmar = CharacterEssentials.MakeCharactersFromList({
    {'Magmar', 292, 208, Direction.Down}
  })

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()
  GROUND:CharSetAnim(torkoal, "Idle", true)
  GROUND:CharSetAnim(magmar, "Idle", true)

  GROUND:TeleportTo(hero, 240, 380, Direction.Up)
  GROUND:TeleportTo(partner, 272, 380, Direction.Up)
  GAME:MoveCamera(256, 240, 1, false)

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
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_011']))
  -- "De retour. Cette fois, on est prêts !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("searing_tunnel", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function searing_tunnel_miniboss_ch_5.DefeatedBoss()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local torkoal = CharacterEssentials.MakeCharactersFromList({
    {'Torkoal', 220, 232, Direction.Down}
  })
  local magmar = CharacterEssentials.MakeCharactersFromList({
    {'Magmar', 292, 208, Direction.Down}
  })

  GROUND:CharSetAction(torkoal, RogueEssence.Ground.PoseGroundAction(
    torkoal.Position, torkoal.Direction,
    RogueEssence.Content.GraphicsManager.GetAnimIndex("Faint")))
  GROUND:CharSetAction(magmar, RogueEssence.Ground.PoseGroundAction(
    magmar.Position, magmar.Direction,
    RogueEssence.Content.GraphicsManager.GetAnimIndex("Faint")))

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GROUND:TeleportTo(hero, 240, 320, Direction.Up)
  GROUND:TeleportTo(partner, 272, 320, Direction.Up)
  GAME:MoveCamera(256, 240, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Spring Cave.ogg', false)

  GAME:WaitFrames(30)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_012']))
  -- "On a survécu à la fournaise !"

  GAME:WaitFrames(20)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_013']))
  -- "Cette voix...[pause=15] Elle semble tout savoir de ce donjon."

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['STM_014']), "Normal")
  -- "C'est comme si elle nous testait. Continuons."

  GAME:WaitFrames(20)

  -- Torkoal and Magmar fade into steam
  local fadeSteam = RogueEssence.Content.FlashEmitter()
  fadeSteam.FadeInTime = 2
  fadeSteam.HoldTime = 2
  fadeSteam.FadeOutTime = 20
  fadeSteam.StartColor = Color(255, 200, 100, 0)
  fadeSteam.Layer = DrawLayer.Top
  fadeSteam.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(fadeSteam, 256, 220)
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  GAME:WaitFrames(16)
  GROUND:Hide('Torkoal')
  GROUND:Hide('Magmar')
  GAME:WaitFrames(40)

  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("searing_tunnel", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function searing_tunnel_miniboss_ch_5.DiedToBoss()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local torkoal = CharacterEssentials.MakeCharactersFromList({
    {'Torkoal', 220, 232, Direction.Down}
  })
  local magmar = CharacterEssentials.MakeCharactersFromList({
    {'Magmar', 292, 208, Direction.Down}
  })
  GROUND:CharSetAnim(torkoal, "Idle", true)
  GROUND:CharSetAnim(magmar, "Idle", true)

  GROUND:Hide(partner.EntName)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_022']))

  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_023']))

  UI:SetSpeaker(partner)
  GeneralFunctions.Hop(partner)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_025']))
  GROUND:Hide(hero.EntName)

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GAME:MoveCamera(256, 240, 1, false)
  GAME:CutsceneMode(true)

  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  GAME:WaitFrames(40)

  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_015']))
  -- "Les flammes t'ont consumé..."

  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_016']))
  -- "Mais le feu forge l'acier. Reviens, plus fort."

  GAME:WaitFrames(40)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_026']))
  -- Torkoal triomphe, Magmar ricane
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_018']))

  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_019']))

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Pain")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_020']))
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)

  SV.TemporaryFlags.Dinnertime = true
  SV.TemporaryFlags.Bedtime = true
  SV.TemporaryFlags.MorningWakeup = true
  SV.TemporaryFlags.MorningAddress = true

  GAME:CutsceneMode(false)
  GAME:EnterGroundMap("searing_tunnel_entrance", "Main_Entrance_Marker")
end

return searing_tunnel_miniboss_ch_5
