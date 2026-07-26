--[[
    init.lua
    Mount Windswept Mini-Boss Ground Map
    Gligar + Skarmory encounter — Chapter 5
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.mount_windswept_miniboss.mount_windswept_miniboss_ch_5'

local mount_windswept_miniboss = {}

function mount_windswept_miniboss.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_mount_windswept_miniboss")
end

function mount_windswept_miniboss.Enter(map)
	if SV.Chapter5.MountMiniBossDefeated == nil then SV.Chapter5.MountMiniBossDefeated = false end
	if SV.Chapter5.MountMiniBossLost == nil then SV.Chapter5.MountMiniBossLost = false end
	if SV.Chapter5.MountMiniBossSeen == nil then SV.Chapter5.MountMiniBossSeen = false end
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Enter_mount_windswept_miniboss")

  if SV.Chapter5.MountMiniBossDefeated then
    SV.Chapter5.MountMiniBossDefeated = false
    mount_windswept_miniboss_ch_5.DefeatedBoss()
  elseif SV.Chapter5.MountMiniBossLost then
    SV.Chapter5.MountMiniBossLost = false
    mount_windswept_miniboss_ch_5.DiedToBoss()
  elseif SV.Chapter5.MountMiniBossSeen then
    mount_windswept_miniboss_ch_5.SecondPreBossScene()
  else
    mount_windswept_miniboss_ch_5.FirstPreBossScene()
  end
end

function mount_windswept_miniboss.Update(map, time)
end

function mount_windswept_miniboss.GameSave(map)
end

function mount_windswept_miniboss.GameLoad(map)
end

return mount_windswept_miniboss
