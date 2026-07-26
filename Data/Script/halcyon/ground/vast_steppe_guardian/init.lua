--[[
    init.lua
    Vast Steppe Guardian Ground Map
    Alpha Stantler encounter — Chapter 5
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.vast_steppe_guardian.vast_steppe_guardian_ch_5'

local vast_steppe_guardian = {}

function vast_steppe_guardian.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_vast_steppe_guardian")
end

function vast_steppe_guardian.Enter(map)
	if SV.Chapter5.SteppeGuardianDefeated == nil then SV.Chapter5.SteppeGuardianDefeated = false end
	if SV.Chapter5.SteppeGuardianLost == nil then SV.Chapter5.SteppeGuardianLost = false end
	if SV.Chapter5.SteppeGuardianSeen == nil then SV.Chapter5.SteppeGuardianSeen = false end
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Enter_vast_steppe_guardian")

  if SV.Chapter5.SteppeGuardianDefeated then
    SV.Chapter5.SteppeGuardianDefeated = false
    vast_steppe_guardian_ch_5.DefeatedBoss()
  elseif SV.Chapter5.SteppeGuardianLost then
    SV.Chapter5.SteppeGuardianLost = false
    vast_steppe_guardian_ch_5.DiedToBoss()
  elseif SV.Chapter5.SteppeGuardianSeen then
    vast_steppe_guardian_ch_5.SecondPreBossScene()
  else
    vast_steppe_guardian_ch_5.FirstPreBossScene()
  end
end

function vast_steppe_guardian.Update(map, time)
end

function vast_steppe_guardian.GameSave(map)
end

function vast_steppe_guardian.GameLoad(map)
end

return vast_steppe_guardian
