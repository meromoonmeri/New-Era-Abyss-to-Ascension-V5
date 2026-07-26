--[[
    cloven_ruins_boss_ch_7.lua
    Ruines Tordues — Boss : Regigigas
    Apparition : les veines dorees de l'arene s'animent, le colosse s'eveille
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

cloven_ruins_boss_ch_7 = {}

function cloven_ruins_boss_ch_7.FirstPreBossScene()
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

  SOUND:PlayBGM('In the Depths of the Pit.ogg', false)

  GAME:WaitFrames(30)
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(partner, Direction.Up, 56, false, 1)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(hero, Direction.Up, 56, false, 1)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_001']))
  -- "Le cœur des ruines... Il bat encore."

  GAME:WaitFrames(20)
  GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
  GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_002']))
  -- "Regarde ces veines dorées... Elles palpitent."

  GAME:WaitFrames(30)

  -- === VOIX DE L'ABYSSE ===
  SOUND:FadeOutBGM(60)
  GAME:WaitFrames(30)

  BossFX.Voice('CRB_003')
  -- "Le Titan déchu... Il attend depuis des millénaires."

  GAME:WaitFrames(20)
  coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.LookAround(partner, 2, 4, true, true, false, Direction.Up)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GeneralFunctions.LookAround(hero, 2, 4, false, false, false, Direction.Up)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(10)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_004']))
  -- "Toi... Tu nous as suivis jusqu'ici ?"

  GAME:WaitFrames(30)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_005']))
  -- "Je suis partout où la vie des Cœurs s'affaiblit."

  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_006']))
  -- "Et ici... le Cœur ne bat presque plus."

  GAME:WaitFrames(30)

  -- === FLASH + EMERGENCE DE REGIGIGAS ===
  local center = GAME:GetCameraCenter()
  BossFX.Flash(center.X, center.Y, 3, 6, 18)

  local regigigas = CharacterEssentials.MakeCharactersFromList({
    {'Regigigas', 224, 200, Direction.Down}
  })
  GROUND:Hide('Regigigas')

  -- Signature ROCHE : eboulement, le colosse se reveille
  BossFX.RockFall(224, 200)
  BossFX.Rumble({hero, partner}, 3)

  SOUND:PlayBGM('Rising Fear.ogg', true)
  GAME:WaitFrames(20)
  GROUND:Unhide('Regigigas')
  GROUND:CharSetAnim(regigigas, "Idle", true)

  -- Les veines dorees de Regigigas pulsent
  BossFX.Overlay("White", regigigas.Position.X, regigigas.Position.Y, 5, 40, 10, DrawLayer.Front)

  BossFX.Impact(14)
  GAME:WaitFrames(20)

  coro1 = TASK:BranchCoroutine(function()
    GROUND:AnimateInDirection(partner, "None", partner.Direction, Direction.Down, 6, 1, 1)
    GeneralFunctions.Recoil(partner, "Hurt", 14, 14, false, false)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:AnimateInDirection(hero, "None", hero.Direction, Direction.Down, 6, 1, 1)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_007']))
  -- "REGIGIGAS ! Le Titan des Ruines !"

  GAME:WaitFrames(30)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_008']))
  -- "Il protège ce qui reste du Cœur. Si tu le vaines, le Cœur est à toi."

  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_009']))
  -- "Si tu échoues... ce Cœur s'éteindra pour toujours."

  GAME:WaitFrames(30)

  -- Regigigas émet un grondement, le sol tremble
  BossFX.ShakeScreen(8, 30)
  SOUND:PlayBattleSE('_UNK_EVT_102')
  GAME:WaitFrames(20)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_010']))
  -- "Alors on ne peut pas perdre. [hero], à nous !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("cloven_ruins", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function cloven_ruins_boss_ch_7.SecondPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local regigigas = CharacterEssentials.MakeCharactersFromList({
    {'Regigigas', 224, 200, Direction.Down}
  })

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()
  GROUND:CharSetAnim(regigigas, "Idle", true)

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
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_011']))
  -- "Cette fois, on le terrasse !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("cloven_ruins", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function cloven_ruins_boss_ch_7.DefeatedBoss()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local regigigas = CharacterEssentials.MakeCharactersFromList({
    {'Regigigas', 224, 200, Direction.Down}
  })
  GROUND:CharSetAnim(regigigas, "Idle", true)

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GROUND:TeleportTo(hero, 240, 340, Direction.Up)
  GROUND:TeleportTo(partner, 208, 340, Direction.Up)
  GAME:MoveCamera(224, 240, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  SOUND:PlayBGM('In the Depths of the Pit.ogg', false)

  GAME:WaitFrames(40)
  SOUND:PlayBattleSE('EVT_CH03_Boss_Collapse')
  BossFX.ShakeScreen(6, 20)
  GROUND:CharSetAction(regigigas, RogueEssence.Ground.PoseGroundAction(
    regigigas.Position, regigigas.Direction,
    RogueEssence.Content.GraphicsManager.GetAnimIndex("Faint")))

  GAME:WaitFrames(60)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_012']))
  -- "On a vaincu le Titan !"

  GAME:WaitFrames(20)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_013']))
  -- "Le Cœur... il bat plus fort maintenant."

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CRB_014']), "Worried")
  -- "(Cette voix... elle nous a guidés jusqu'ici exprès.)"

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_015']))
  -- "On doit parler à Phileas. Il en sait plus qu'il ne le dit."

  GAME:WaitFrames(30)
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)

  SV.Chapter7.SawAnimaCoreCorruption = true
  GAME:CutsceneMode(false)
  GAME:EnterGroundMap("guild_third_floor_lobby", "Main_Entrance_Marker")
end

function cloven_ruins_boss_ch_7.DiedToBoss()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local regigigas = CharacterEssentials.MakeCharactersFromList({
    {'Regigigas', 224, 200, Direction.Down}
  })
  GROUND:CharSetAnim(regigigas, "Idle", true)

  GROUND:Hide(partner.EntName)
  -- Le Titan te regarde, sans colere
  GROUND:CharEndAnim(regigigas)
  GROUND:CharSetAnim(regigigas, "Idle", true)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_023']))

  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_024']))

  UI:SetSpeaker(partner)
  GeneralFunctions.Hop(partner)
  UI:SetSpeakerEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_026']))

  -- Le Titan se fige en pierre
  BossFX.Flash(regigigas.Position.X, regigigas.Position.Y, 3, 4, 25)
  GAME:WaitFrames(15)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_025']))
  GROUND:Hide(hero.EntName)

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GAME:MoveCamera(224, 240, 1, false)
  GAME:CutsceneMode(true)

  GAME:WaitFrames(60)
  GAME:FadeIn(40)
  GAME:WaitFrames(40)

  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_016']))
  -- "Le Titan ne pardonne pas..."

  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_017']))
  -- "Mais ce Cœur t'attend. Reviens quand tu seras prêt."

  GAME:WaitFrames(40)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_027']))
  -- Le Titan se redresse, inebranlable
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_019']))

  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_020']))

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Pain")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_021']))
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)

  SV.TemporaryFlags.Dinnertime = true
  SV.TemporaryFlags.Bedtime = true
  SV.TemporaryFlags.MorningWakeup = true
  SV.TemporaryFlags.MorningAddress = true

  GAME:CutsceneMode(false)
  GAME:EnterGroundMap("cloven_ruins_entrance", "Main_Entrance_Marker")
end

return cloven_ruins_boss_ch_7
