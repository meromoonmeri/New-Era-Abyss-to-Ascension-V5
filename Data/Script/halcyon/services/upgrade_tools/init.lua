--[[
    Example Service
    
    This is an example to demonstrate how to use the BaseService class to implement a game service.
    
    **NOTE:** After declaring you service, you have to include your package inside the main.lua file!
]]--
require 'origin.common'
require 'origin.services.baseservice'

--Declare class UpgradeTools
local UpgradeTools = Class('UpgradeTools', BaseService)


--[[---------------------------------------------------------------
    UpgradeTools:initialize()
      UpgradeTools class constructor
---------------------------------------------------------------]]
function UpgradeTools:initialize()
  BaseService.initialize(self)
  PrintInfo('UpgradeTools:initialize()')
end

--[[---------------------------------------------------------------
    UpgradeTools:__gc()
      UpgradeTools class gc method
      Essentially called when the garbage collector collects the service.
	  TODO: Currently causes issues.  debug later.
  ---------------------------------------------------------------]]
--function UpgradeTools:__gc()
--  PrintInfo('*****************UpgradeTools:__gc()')
--end

--[[---------------------------------------------------------------
    UpgradeTools:OnUpgrade()
      When a save file in an old version is loaded this is called!
---------------------------------------------------------------]]
function UpgradeTools:OnUpgrade()

end

---Summary
-- Subscribe to all channels this service wants callbacks from
function UpgradeTools:Subscribe(med)
  med:Subscribe("UpgradeTools", EngineServiceEvents.UpgradeSave,        function() self.OnUpgrade(self) end )
end

---Summary
-- un-subscribe to all channels this service subscribed to
function UpgradeTools:UnSubscribe(med)
end

--Add our service
SCRIPT:AddService("UpgradeTools", UpgradeTools:new())
return UpgradeTools