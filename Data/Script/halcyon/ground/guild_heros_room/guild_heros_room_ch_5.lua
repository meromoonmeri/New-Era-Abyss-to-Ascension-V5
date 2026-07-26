--[[
    guild_heros_room_ch_5.lua
    Chapter 5 hero room scenes: Title Card + Post-Expedition Bedtalk
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.guild_heros_room.guild_heros_room_helper'

guild_heros_room_ch_5 = {}


function guild_heros_room_ch_5.ShowTitleCard()
  GAME:FadeOut(false, 1)
  GAME:CutsceneMode(true)
  AI:DisableCharacterAI(CH('Teammate1'))
  UI:ResetSpeaker()
  SOUND:StopBGM()
  GAME:WaitFrames(60)
  local coro1 = TASK:BranchCoroutine(function()
    UI:WaitShowTitle("Chapitre 5\n\nL'Expédition\n", 20)
    GAME:WaitFrames(180)
    UI:WaitHideTitle(20)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    UI:WaitShowBG("Chapter_4", 180, 20)
    GAME:WaitFrames(180)
    UI:WaitHideBG(20)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(120)
  SV.Chapter5.ShowedTitleCard = true
  guild_heros_room_helper.Morning(true)
end


--[[
  PostExpeditionBedtalk
  Plays when the hero and partner return from the expedition (Mount Windswept cleared).
  They reflect on their journey, the mysterious voice, and look forward to what comes next.
  Sets DaysToReach to force 2 days of missions before Chapter 6 starts.
]]
function guild_heros_room_ch_5.PostExpeditionBedtalk()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  guild_heros_room_helper.Bedtime(false)
  UI:ResetSpeaker()
  GAME:FadeIn(40)

  SOUND:PlayBGM('Goodnight.ogg', true)
  GAME:WaitFrames(40)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_001'], hero:GetDisplayName()))
  -- "On l'a fait, [hero]... L'expédition est terminée !"

  GAME:WaitFrames(20)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_002']))
  -- "La Grande Steppe, le Tunnel Incandescent, le Mont Venteux..."

  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_003']))
  -- "On a traversé tellement d'endroits dangereux. Et on est toujours debout !"

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR5_004']), "Happy")
  -- "(Oui. C'était dur, mais on a réussi ensemble.)"

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_005']))
  -- "Mais... cette voix qu'on a entendue. Plusieurs fois."

  GAME:WaitFrames(10)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_006']))
  -- "Elle semblait tout savoir. Les boss, les lieux... et nous."

  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_007']))
  -- "Qui peut bien être derrière tout ça ?"

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR5_008']), "Worried")
  -- "(Je ne sais pas. Mais cette présence... elle n'est pas hostile.)"

  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR5_009']), "Normal")
  -- "(Elle nous observait. Comme si elle attendait quelque chose de nous.)"

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_010']))
  -- "En tout cas, on a prouvé qu'on était de vrais aventuriers !"

  GAME:WaitFrames(15)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_011']))
  -- "La guilde va être fière de nous. Surtout Penticus !"

  GAME:WaitFrames(20)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_012']))
  -- "Bon... on devrait se reposer un peu. Ces derniers jours ont été épuisants."

  GAME:WaitFrames(20)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_013']))
  -- "Mais dès qu'on est prêts, on devrait continuer à explorer."

  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_014']))
  -- "Il y a sûrement d'autres donjons à découvrir, d'autres missions à accomplir."

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR5_015']), "Happy")
  -- "(Tu as raison. Prenons quelques jours pour nous entraîner.)"

  GAME:WaitFrames(40)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_016'], hero:GetDisplayName()))
  -- "Bonne nuit, [hero]. À demain !"

  GAME:WaitFrames(40)
  GROUND:CharSetAnim(partner, "Laying", true)
  GAME:WaitFrames(60)
  GROUND:CharSetAnim(hero, "Laying", true)
  GAME:WaitFrames(40)
  UI:SetSpeaker(partner:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_017']))
  -- "Zzz..."

  GAME:WaitFrames(40)
  GROUND:CharSetAnim(partner, "EventSleep", true)
  GAME:WaitFrames(40)
  GROUND:CharSetAnim(hero, "EventSleep", true)
  GAME:WaitFrames(180)
  SOUND:FadeOutBGM(120)
  GAME:FadeOut(false, 120)

  SV.Chapter5.FinishedBedtimeCutscene = true
  SV.ChapterProgression.CurrentStoryDungeon = ''
  SV.TemporaryFlags.MorningAddress = true
  SV.TemporaryFlags.MorningWakeup = true
  GeneralFunctions.EndOfDay()
  -- 2 days of missions before Chapter 6 starts
  SV.ChapterProgression.DaysToReach = SV.ChapterProgression.DaysPassed + 2
  GAME:CutsceneMode(false)
  GAME:EnterGroundMap('guild_heros_room', 'Main_Entrance_Marker')
end


-- Chapter 5 bedtime dialogue strings for the resx
-- These will be registered by the resx files
return guild_heros_room_ch_5
