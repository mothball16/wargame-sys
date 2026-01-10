local dirServer = require(game.ServerScriptService.Server.DS_Server.Directory)
local dir = dirServer.Main



local DoorRoot = require(dirServer.Modules.Core.DoorRoot)
local DoorService = require(dirServer.Modules.Core.DoorService)
local DoorTest = script.Parent.Door.Value
local DisplayTest = script.Parent.Display.Value

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

local lockdown = false
local singleDoorOpen = false
local singleDoorLocked = false
local attributeDoorOpen = false

local DoorTestObject = DoorService:GetDoor(DoorTest) :: typeof(DoorRoot)
local doorTestDoors = DoorService:QueryForValue("DoorTest")

local function SetString()
    local statusString = string.format([[
[T] lockdown: %*
[Y] attr. open: %*
[G] single open: %*
[H] single lock: %*
(R -> toggle promptrotate style)
follow this label for StreamingEnabled test
    ]], lockdown, attributeDoorOpen, singleDoorOpen, singleDoorLocked)

    DisplayTest.Text = statusString
end

dir.Net:Connect(dir.Events.Reliable.RunTest, function(plr, evt, args)
    warn("executing " .. evt .. "...")
    dir.Helpers:Switch (evt) {
        ["ToggleLockdown"] = function()
            lockdown = not lockdown
            game.ServerScriptService:SetAttribute(dir.Consts.LOCKDOWN_ATTR, lockdown and "Lockdown" or "none")
            SetLockdown(lockdown)
        end,
        ["ToggleByAttribute"] = function()
            attributeDoorOpen = not attributeDoorOpen
            for _, v in pairs(doorTestDoors) do
                DoorService:SetDoorState(v, attributeDoorOpen and DoorRoot.State.Opened or DoorRoot.State.Closed)
            end
        end,
        ["ToggleSingleDoor"] = function()
            singleDoorOpen = not singleDoorOpen
            DoorService:SetDoorState(DoorTest, singleDoorOpen and DoorRoot.State.Opened or DoorRoot.State.Closed)
        end,
        ["LockSingleDoor"] = function()
            singleDoorLocked = not singleDoorLocked
            DoorTestObject:SetLock(singleDoorLocked)
        end
    }
    SetString()
end)

SetString()