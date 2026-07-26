--[[
    init.lua — Cloven Ruins Boss Ground Map
    Chapter 7 — Arene Regigigas
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.ground.cloven_ruins_boss.cloven_ruins_boss_ch_7'
local cloven_ruins_boss = {}
function cloven_ruins_boss.Init(map) COMMON.RespawnAllies(); PartnerEssentials.InitializePartnerSpawn() end
function cloven_ruins_boss.Enter(map)
  if SV.Chapter7.DefeatedRuinsBoss then
    SV.Chapter7.DefeatedRuinsBoss = false
    cloven_ruins_boss_ch_7.DefeatedBoss()
  elseif SV.Chapter7.DiedToRuinsBoss then
    SV.Chapter7.DiedToRuinsBoss = false
    cloven_ruins_boss_ch_7.DiedToBoss()
  else
    cloven_ruins_boss_ch_7.FirstPreBossScene()
  end
end
function cloven_ruins_boss.Update(map) end
function cloven_ruins_boss.GameSave(map) PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end
function cloven_ruins_boss.GameLoad(map) PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1')) end
return cloven_ruins_boss
