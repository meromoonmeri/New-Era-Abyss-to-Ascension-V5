--[[
    init.lua
    Ruines Tordues (Cloven Ruins) — Chapitre 7
    20 etages en 4 segments : 15 normaux + relais + 5 profondeurs + boss Regigigas
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local cloven_ruins = {}

function cloven_ruins.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_cloven_ruins")
  SV.TemporaryFlags.LastDungeonEntered = 'cloven_ruins'
end

function cloven_ruins.EnterSegment(zone, rescuing, segmentID, mapID)
    GeneralFunctions.CheckAllowSetRescue(zone.ID)
    if rescuing ~= true then
        COMMON.BeginDungeon(zone.ID, segmentID, mapID)
    end
end

function cloven_ruins.Rescued(zone, name, mail)
    COMMON.Rescued(zone, name, mail)
end

function cloven_ruins.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_cloven_ruins result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
      return
  end

  if segmentID == 0 then
      -- Ruines Tordues : 15 etages
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and SV.ChapterProgression.Chapter == 7 then
          -- Go to relay checkpoint
          GAME:EnterGroundMap('cloven_ruins_midpoint', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter7.LostRuins = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              GAME:EndDungeonRun(result, "master_zone", -1, 46, 0, true, true)
              GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1), "Les ruines...[pause=0] c'est trop pour nous...", "Pain")
              GAME:WaitFrames(20)
              GAME:EnterZone("master_zone", -1, 46, 0)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 46, 0, true, true)
          end
      end
  elseif segmentID == 1 then
      -- Relais
      if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:EnterGroundMap('cloven_ruins_midpoint', 'Main_Entrance_Marker')
      end
  elseif segmentID == 2 then
      -- Profondeurs : 5 etages
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and SV.ChapterProgression.Chapter == 7 then
          GAME:EnterGroundMap('cloven_ruins_boss', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter7.LostDepths = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              GAME:EndDungeonRun(result, "master_zone", -1, 46, 0, true, true)
              GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1), "Les profondeurs...[pause=0] on n'aurait pas du...", "Pain")
              GAME:WaitFrames(20)
              GAME:EnterZone("master_zone", -1, 46, 0)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 46, 0, true, true)
          end
      end
  elseif segmentID == 3 then
      -- Boss Regigigas
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
          SV.Chapter7.DefeatedRuinsBoss = true
      else
          SV.Chapter7.DiedToRuinsBoss = true
      end
      GAME:EnterGroundMap('cloven_ruins_boss', 'Main_Entrance_Marker')
  end
end

return cloven_ruins
