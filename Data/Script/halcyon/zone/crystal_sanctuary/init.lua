--[[
    init.lua
    Sanctuaire de Cristal (Crystal Sanctuary) — Chapitre 8
    18 etages en 4 segments : 12 cristallins + relais + 6 glyphes + boss Diancie
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local crystal_sanctuary = {}
local RELAY_MAP = 68
local BOSS_MAP = 69
local FALLBACK_ENTRANCE_MAP = 64 -- entree valide la plus proche dans master_zone tant qu'aucune entree dediee n'existe.

function crystal_sanctuary.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_crystal_sanctuary")
  SV.TemporaryFlags.LastDungeonEntered = 'crystal_sanctuary'
end

function crystal_sanctuary.EnterSegment(zone, rescuing, segmentID, mapID)
    GeneralFunctions.CheckAllowSetRescue(zone.ID)
    if rescuing ~= true then
        COMMON.BeginDungeon(zone.ID, segmentID, mapID)
    end
end

function crystal_sanctuary.Rescued(zone, name, mail)
    COMMON.Rescued(zone, name, mail)
end

local function ReturnToMasterGround(result, map_id)
  GAME:EndDungeonRun(result, "master_zone", -1, map_id, 0, true, true)
  GAME:WaitFrames(20)
  GAME:EnterZone("master_zone", -1, map_id, 0)
end

function crystal_sanctuary.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_crystal_sanctuary result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then return end

  if segmentID == 0 then
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and SV.ChapterProgression.Chapter == 8 then
          SV.Chapter8.ReachedCrystalRelay = true
          GAME:EnterGroundMap('crystal_sanctuary_relay', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter8.LostCrystalGallery = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              GAME:EndDungeonRun(result, "master_zone", -1, FALLBACK_ENTRANCE_MAP, 0, true, true)
              GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1),
                  "Les cristaux...[pause=0] ils emprisonnent tout...[pause=15] meme la lumiere...", "Pain")
              GAME:WaitFrames(20)
              GAME:EnterZone("master_zone", -1, FALLBACK_ENTRANCE_MAP, 0)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, FALLBACK_ENTRANCE_MAP, 0, true, true)
          end
      end
  elseif segmentID == 1 then
      if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:EnterGroundMap('crystal_sanctuary_relay', 'Main_Entrance_Marker')
      end
  elseif segmentID == 2 then
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and SV.ChapterProgression.Chapter == 8 then
          SV.Chapter8.ReachedDiancieChamber = true
          GAME:EnterGroundMap('crystal_sanctuary_boss', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter8.LostGlyphHalls = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              ReturnToMasterGround(result, RELAY_MAP)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, FALLBACK_ENTRANCE_MAP, 0, true, true)
          end
      end
  elseif segmentID == 3 then
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
          SV.Chapter8.DefeatedDiancie = true
          SV.Chapter8.ObtainedCrystalFragment = true
          SV.Chapter8.CrystalSanctuaryComplete = true
          GeneralFunctions.EndDungeonRun(result, "master_zone", -1, FALLBACK_ENTRANCE_MAP, 0, true, true)
      else
          SV.Chapter8.DiedToDiancie = true
          ReturnToMasterGround(result, RELAY_MAP)
      end
  end
end

return crystal_sanctuary
