--[[
    guild_heros_room_ch_6.lua
    Chapter 6 hero room scenes: Title Card
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.ground.guild_heros_room.guild_heros_room_helper'

guild_heros_room_ch_6 = {}


function guild_heros_room_ch_6.ShowTitleCard()
  GAME:FadeOut(false, 1)
  GAME:CutsceneMode(true)
  AI:DisableCharacterAI(CH('Teammate1'))
  UI:ResetSpeaker()
  SOUND:StopBGM()
  GAME:WaitFrames(60)
  local coro1 = TASK:BranchCoroutine(function()
    UI:WaitShowTitle("Chapitre 6\n\nLa Forêt Lugubre\n", 20)
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
  SV.Chapter6.ShowedTitleCard = true
  guild_heros_room_helper.Morning(true)
end


return guild_heros_room_ch_6
