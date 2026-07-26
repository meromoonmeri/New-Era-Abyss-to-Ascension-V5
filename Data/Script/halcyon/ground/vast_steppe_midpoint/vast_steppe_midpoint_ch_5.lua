--[[
    vast_steppe_midpoint_ch_5.lua
    Scene de mi-parcours de la Grande Steppe — Chapitre 5.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

vast_steppe_midpoint_ch_5 = {}

function vast_steppe_midpoint_ch_5.FirstArrival()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GROUND:TeleportTo(hero, 200, 380, Direction.Up)
  GROUND:TeleportTo(partner, 208, 380, Direction.Up)
  GAME:MoveCamera(184, 200, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Sky Peak Prairie.ogg', false)

  GAME:WaitFrames(30)

  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(partner, Direction.Up, 48, false, 1)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(hero, Direction.Up, 48, false, 1)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSMID_001']))
  -- "On a traversé la première moitié de la steppe."

  GAME:WaitFrames(15)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSMID_002']))
  -- "Cette brume ne se lève toujours pas... et cette voix."

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['VSMID_003']), "Worried")
  -- "(On doit rester sur nos gardes. La steppe n'a pas dit son dernier mot.)"

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSMID_004']))
  -- "Reposons-nous un peu. On repartira quand on sera prêts."

  GAME:WaitFrames(40)
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 60)

  SV.Chapter5.PlayedSteppeMidpointIntro = true

  GAME:CutsceneMode(false)
  GAME:EnterGroundMap("vast_steppe_midpoint", "Main_Entrance_Marker")
end

return vast_steppe_midpoint_ch_5
