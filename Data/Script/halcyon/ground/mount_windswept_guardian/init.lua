--[[
    init.lua
    Mount Windswept Guardian Ground Map
    Aerodactyl encounter — Chapter 5
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.mount_windswept_guardian.mount_windswept_guardian_ch_5'

local mount_windswept_guardian = {}

function mount_windswept_guardian.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_mount_windswept_guardian")
end

function mount_windswept_guardian.Enter(map)
	if SV.Chapter5.MountGuardianDefeated == nil then SV.Chapter5.MountGuardianDefeated = false end
	if SV.Chapter5.MountGuardianLost == nil then SV.Chapter5.MountGuardianLost = false end
	if SV.Chapter5.MountGuardianSeen == nil then SV.Chapter5.MountGuardianSeen = false end
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Enter_mount_windswept_guardian")

  if SV.Chapter5.MountGuardianDefeated then
    SV.Chapter5.MountGuardianDefeated = false
    mount_windswept_guardian_ch_5.DefeatedBoss()
  elseif SV.Chapter5.MountGuardianLost then
    SV.Chapter5.MountGuardianLost = false
    mount_windswept_guardian_ch_5.DiedToBoss()
  elseif SV.Chapter5.MountGuardianSeen then
    mount_windswept_guardian_ch_5.SecondPreBossScene()
  else
    mount_windswept_guardian_ch_5.FirstPreBossScene()
  end
end

function mount_windswept_guardian.Update(map, time)
end

function mount_windswept_guardian.GameSave(map)
end

function mount_windswept_guardian.GameLoad(map)
end

return mount_windswept_guardian
