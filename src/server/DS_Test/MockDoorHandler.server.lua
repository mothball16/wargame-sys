local source = require(game.ServerScriptService.Server.DS_Server.Directory)
local DoorRoot = require(source.Modules.Core.DoorRoot)
local DoorManager = require(source.Modules.Core.DoorManager)
local DoorTest = script.Parent.Door.Value
task.wait(4)

--[[

warn("= = = = door manager single interaction = = = =")

warn("explicit open test")
DoorManager:SetDoorState(DoorTest, DoorRoot.State.Opened)
task.wait(2)

warn("explicit close test before animation is done")
DoorManager:SetDoorState(DoorTest, DoorRoot.State.Closed)
task.wait(2)



warn("= = = = direct interaction with door object = = = =")

warn("lock test")
DoorManager:GetDoor(DoorTest):SetLock(true)
task.wait(2)

warn("unlock test")
DoorManager:GetDoor(DoorTest):SetLock(false)
task.wait(2)

]]
warn("= = = = door manager interaction by tag = = = =")


warn("= = = = door manager interaction by attribute = = = =")

-- open by attribute value test
warn("open by attribute test")
DoorManager:SetDoorStates(DoorManager:QueryForValue("DoorTest"), DoorRoot.State.Opened)
task.wait(2)

-- close by attribute value test
warn("close by attribute test")
DoorManager:SetDoorStates(DoorManager:QueryForValue("DoorTest"), DoorRoot.State.Closed)
