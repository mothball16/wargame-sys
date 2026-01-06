--[[
    sets up tagged objects and sends a request to build the object when initialization conditions meet
    REFACTOR: used gemini to protect against leaks
]]

local dir = require(game.ReplicatedStorage.Shared.mOS_Replicated.Directory)
local HTTP = game:GetService("HttpService")
local CS = game:GetService("CollectionService")

local ServerSignals = dir.ServerSignals


local function Initialize(player, required)
    if player then
        dir.NetUtils:FireClient(player, dir.Events.Reliable.OnInitialize, required)
    end
    ServerSignals.InitObject:Fire(required)
end

local function Destroy(player, required)
    dir.NetUtils:FireClient(player, dir.Events.Reliable.OnDestroy, required)
end

local function AddSeatInitListener(required)
    local seatValue = required:FindFirstChild("ControlSeat")
    if not seatValue then
        warn("Missing ControlSeat ObjectValue for:", required:GetFullName())
        return
    end

    local seat = seatValue.Value
    if not seat then return end

    local lastOccupant
    seat:GetPropertyChangedSignal("Occupant"):Connect(function()
        local occupant = seat.Occupant
        if occupant then
            occupant = occupant.Parent
            local player = game.Players:GetPlayerFromCharacter(occupant)
            if player then
                Initialize(player, required)
            end
        else
            if not lastOccupant or not lastOccupant.Parent then
                return
            end
            local player = game.Players:GetPlayerFromCharacter(lastOccupant)
            if player then
                Destroy(player, required)
            end
        end
        lastOccupant = occupant
    end)
end

local function AddToolInitListener(required)
    local tool = required.Parent

    if not tool or not tool:IsA("Tool") then
        return
    end

    local owner = nil

    tool.Equipped:Connect(function()
        local char = tool.Parent
        local player = game.Players:GetPlayerFromCharacter(char)
        if player then
            owner = player
            Initialize(player, required)
        end
    end)

    tool.Unequipped:Connect(function()
        if not owner then return end
        Destroy(owner, required)
        owner = nil
    end)
end

local function PrepImmediateSpawn(required)
    -- just needs the ID and preload check, which happens in SpawnListener
end



local TagHandlers = {
    [dir.Consts.SEATED_INIT_TAG_NAME] = AddSeatInitListener,
    [dir.Consts.TOOL_INIT_TAG_NAME] = AddToolInitListener,
    [dir.Consts.SPAWN_INIT_TAG_NAME] = PrepImmediateSpawn
}

-----------------------------------------------------------------------------------

local function SpawnListener(required, handler)
    local function execute()
        if required:GetAttribute("_hasSpawned") then return end
        required:SetAttribute("_hasSpawned", true)

        if not required:GetAttribute(dir.Consts.OBJECT_IDENT_ATTR) then
            required:SetAttribute(dir.Consts.OBJECT_IDENT_ATTR, HTTP:GenerateGUID())
        end

        handler(required)

        -- check preload (whether server obj. only initializes itself after the client obj. is entered)
        if not required:GetAttribute(dir.Consts.LAZY_LOAD_SERVER_CONTROLLER_ATTR) then
            ServerSignals.InitObject:Fire(required)
        end
    end

    if required:IsDescendantOf(workspace) then
        execute()
    else
        -- wait till this is connected
        local connection
        local destroyConn
        destroyConn = required.Destroying:Connect(function()
            if connection then connection:Disconnect() end
            if destroyConn then destroyConn:Disconnect() end
        end)

        connection = required.AncestryChanged:Connect(function(_, parent)
            if parent and required:IsDescendantOf(workspace) then
                connection:Disconnect()
                if destroyConn then destroyConn:Disconnect() end
                execute()
            end
        end)
    end
end

return function()
    for tag, handler in pairs(TagHandlers) do
        for _, v in pairs(CS:GetTagged(tag)) do
            SpawnListener(v, handler)
        end

        CS:GetInstanceAddedSignal(tag):Connect(function(inst)
            SpawnListener(inst, handler)
        end)
    end
end