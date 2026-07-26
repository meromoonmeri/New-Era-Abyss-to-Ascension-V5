--[[
  main.lua
  
  This file is loaded persistently.
  Its main purpose is to include anything that needs to stay persistently in the lua state.
  Things like services.
]]--

--------------------------------------------------------------------------------------------------------------
-- Service Packages
--------------------------------------------------------------------------------------------------------------
require 'halcyon.services.debug_tools'
require 'halcyon.services.menu_tools'
require 'halcyon.services.upgrade_tools'
require 'halcyon.services.config_tools'

math.randomseed(os.time())