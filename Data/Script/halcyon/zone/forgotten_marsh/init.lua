--[[
    init.lua
    Marais de l'Oubli (Forgotten Marsh) — Chapitre 9
    18 etages en 4 segments : 10 berges + relais + 8 abysses + boss Mega-Blastoise
    Premiere apparition du Cercle du Suaire (Banette, Ectoplasma, Nosferalto)
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local forgotten_marsh = {}
local RELAY_MAP = 70
local BOSS_MAP = 71
local FALLBACK_ENTRANCE_MAP = 64 -- entree valide la plus proche dans master_zone tant qu'aucune entree dediee n'existe.

function forgotten_marsh.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_forgotten_marsh")
  SV.TemporaryFlags.LastDungeonEntered = 'forgotten_marsh'
end

function forgotten_marsh.EnterSegment(zone, rescuing, segmentID, mapID)
    GeneralFunctions.CheckAllowSetRescue(zone.ID)
    if rescuing ~= true then
        COMMON.BeginDungeon(zone.ID, segmentID, mapID)
    end
end

function forgotten_marsh.Rescued(zone, name, mail)
    COMMON.Rescued(zone, name, mail)
end

local function ReturnToMasterGround(result, map_id)
  GAME:EndDungeonRun(result, "master_zone", -1, map_id, 0, true, true)
  GAME:WaitFrames(20)
  GAME:EnterZone("master_zone", -1, map_id, 0)
end

function forgotten_marsh.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_forgotten_marsh result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then return end

  if segmentID == 0 then
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and SV.ChapterProgression.Chapter == 9 then
          SV.Chapter9.ReachedMarshRelay = true
          GAME:EnterGroundMap('forgotten_marsh_relay', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter9.LostMarshBanks = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              GAME:EndDungeonRun(result, "master_zone", -1, FALLBACK_ENTRANCE_MAP, 0, true, true)
              GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1),
                  "La vase...[pause=0] elle nous aspire...[pause=20] vers le fond...", "Pain")
              GAME:WaitFrames(20)
              GAME:EnterZone("master_zone", -1, FALLBACK_ENTRANCE_MAP, 0)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, FALLBACK_ENTRANCE_MAP, 0, true, true)
          end
      end
  elseif segmentID == 1 then
      if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:EnterGroundMap('forgotten_marsh_relay', 'Main_Entrance_Marker')
      end
  elseif segmentID == 2 then
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and SV.ChapterProgression.Chapter == 9 then
          SV.Chapter9.ReachedMarshDepths = true
          SV.Chapter9.SawCercleDuSuaire = true
          GAME:EnterGroundMap('forgotten_marsh_boss', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter9.LostMarshDepths = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              ReturnToMasterGround(result, RELAY_MAP)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, FALLBACK_ENTRANCE_MAP, 0, true, true)
          end
      end
  elseif segmentID == 3 then
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
          SV.Chapter9.DefeatedMegaBlastoise = true
          SV.Chapter9.PurifiedMarshCore = true
          SV.Chapter9.ForgottenMarshComplete = true
          GeneralFunctions.EndDungeonRun(result, "master_zone", -1, FALLBACK_ENTRANCE_MAP, 0, true, true)
      else
          SV.Chapter9.DiedToMegaBlastoise = true
          ReturnToMasterGround(result, RELAY_MAP)
      end
  end
end

return forgotten_marsh
