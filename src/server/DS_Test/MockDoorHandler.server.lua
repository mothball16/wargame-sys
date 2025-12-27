local source = require(game.ServerScriptService.Server.DS_Server.Directory)
local DoorRoot = require(source.Modules.Core.DoorRoot)
local DoorService = require(source.Modules.Core.DoorService)
local DoorTest = script.Parent.Door.Value


local function SetLockdown(active)
    local doors = DoorService:QueryAll()
    if active then
        for _, v in pairs(doors) do
            DoorService:SetDoorState(v, DoorRoot.State.Closed)
            DoorService:SetDoorLock(v, true)
        end
    else
        for _, v in pairs(doors) do
            DoorService:SetDoorLock(v, false)
        end
    end
end


task.wait(4)


warn("= = = = door manager single interaction = = = =")

warn("explicit open test")
DoorService:SetDoorState(DoorTest, DoorRoot.State.Opened)
task.wait(2)

warn("explicit close test before animation is done")
DoorService:SetDoorState(DoorTest, DoorRoot.State.Closed)
task.wait(2)



warn("= = = = direct interaction with door object = = = =")
local DoorTestObject = DoorService:GetDoor(DoorTest) :: typeof(DoorRoot)
warn("lock test")
DoorTestObject:SetLock(true)
task.wait(2)

warn("unlock test")
DoorTestObject:SetLock(false)
task.wait(2)


warn("= = = = door manager interaction by attribute = = = =")

-- open by attribute value test
warn("open by attribute test")
local doorTestDoors = DoorService:QueryForValue("DoorTest")
for _, v in pairs(doorTestDoors) do
    DoorService:SetDoorState(v, DoorRoot.State.Opened)
end
task.wait(2)

-- close by attribute value test
warn("close by attribute test")
for _, v in pairs(doorTestDoors) do
    DoorService:SetDoorState(v, DoorRoot.State.Closed)
end
task.wait(2)


-- mock lockdown
warn("mock lockdown")
SetLockdown(true)
task.wait(5)

-- mock lockdown
warn("mock un-lockdown")
SetLockdown(false)
