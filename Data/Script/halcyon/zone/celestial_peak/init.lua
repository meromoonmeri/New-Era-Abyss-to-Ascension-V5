--[[
    init.lua
    Pic Celeste (Celestial Peak) — Chapitre 10
    22 etages en 6 segments : 8 contreforts + relais + 6 nuages + Escouade Fulgur + 4 sommet + boss Lugia
    Course contre l'Escouade Fulgur (Luxray, Lucario, Heliolisk)
    Premiere vision de Necrozma
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local celestial_peak = {}
local RELAY_MAP = 72
local FULGUR_MAP = 73
local BOSS_MAP = 74
local FALLBACK_ENTRANCE_MAP = 64 -- entree valide la plus proche dans master_zone tant qu'aucune entree dediee n'existe.

function celestial_peak.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_celestial_peak")
  SV.TemporaryFlags.LastDungeonEntered = 'celestial_peak'
end

function celestial_peak.EnterSegment(zone, rescuing, segmentID, mapID)
    GeneralFunctions.CheckAllowSetRescue(zone.ID)
    if rescuing ~= true then
        COMMON.BeginDungeon(zone.ID, segmentID, mapID)
    end
end

function celestial_peak.Rescued(zone, name, mail)
    COMMON.Rescued(zone, name, mail)
end

local function ReturnToMasterGround(result, map_id)
  GAME:EndDungeonRun(result, "master_zone", -1, map_id, 0, true, true)
  GAME:WaitFrames(20)
  GAME:EnterZone("master_zone", -1, map_id, 0)
end

function celestial_peak.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_celestial_peak result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then return end

  if segmentID == 0 then
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and SV.ChapterProgression.Chapter == 10 then
          SV.Chapter10.ReachedCloudRelay = true
          GAME:EnterGroundMap('celestial_peak_relay', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter10.LostFoothills = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              GAME:EndDungeonRun(result, "master_zone", -1, FALLBACK_ENTRANCE_MAP, 0, true, true)
              GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1),
                  "Le vent...[pause=0] il est trop fort...[pause=20] on ne peut plus avancer...", "Pain")
              GAME:WaitFrames(20)
              GAME:EnterZone("master_zone", -1, FALLBACK_ENTRANCE_MAP, 0)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, FALLBACK_ENTRANCE_MAP, 0, true, true)
          end
      end
  elseif segmentID == 1 then
      if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:EnterGroundMap('celestial_peak_relay', 'Main_Entrance_Marker')
      end
  elseif segmentID == 2 then
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and SV.ChapterProgression.Chapter == 10 then
          SV.Chapter10.ReachedFulgurEncounter = true
          GAME:EnterGroundMap('celestial_peak_fulgur', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter10.LostCloudSea = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              ReturnToMasterGround(result, RELAY_MAP)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, FALLBACK_ENTRANCE_MAP, 0, true, true)
          end
      end
  elseif segmentID == 3 then
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
          SV.Chapter10.OutranEscouadeFulgur = true
          GAME:EnterGroundMap('celestial_peak_relay', 'Main_Entrance_Marker')
      else
          SV.Chapter10.FulgurReachedSummitFirst = true
          ReturnToMasterGround(result, RELAY_MAP)
      end
  elseif segmentID == 4 then
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and SV.ChapterProgression.Chapter == 10 then
          SV.Chapter10.ReachedLugiaAltar = true
          GAME:EnterGroundMap('celestial_peak_boss', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter10.LostSummit = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              ReturnToMasterGround(result, RELAY_MAP)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, FALLBACK_ENTRANCE_MAP, 0, true, true)
          end
      end
  elseif segmentID == 5 then
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
          SV.Chapter10.DefeatedLugia = true
          SV.Chapter10.CelestialPeakComplete = true
          GeneralFunctions.EndDungeonRun(result, "master_zone", -1, FALLBACK_ENTRANCE_MAP, 0, true, true)
      else
          SV.Chapter10.DiedToLugia = true
          ReturnToMasterGround(result, RELAY_MAP)
      end
  end
end

return celestial_peak
