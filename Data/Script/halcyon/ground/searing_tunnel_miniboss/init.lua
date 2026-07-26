--[[
    init.lua
    Searing Tunnel Mini-Boss Ground Map
    Torkoal + Magmar encounter — Chapter 5
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.searing_tunnel_miniboss.searing_tunnel_miniboss_ch_5'

local searing_tunnel_miniboss = {}

function searing_tunnel_miniboss.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_searing_tunnel_miniboss")
end

function searing_tunnel_miniboss.Enter(map)
	if SV.Chapter5.TunnelMiniBossSeen == nil then SV.Chapter5.TunnelMiniBossSeen = false end
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Enter_searing_tunnel_miniboss")

  if SV.Chapter5.TunnelMiniBossSeen then
    searing_tunnel_miniboss_ch_5.SecondPreBossScene()
  else
    searing_tunnel_miniboss_ch_5.FirstPreBossScene()
  end
end

function searing_tunnel_miniboss.Update(map, time)
end

function searing_tunnel_miniboss.GameSave(map)
end

function searing_tunnel_miniboss.GameLoad(map)
end

return searing_tunnel_miniboss
