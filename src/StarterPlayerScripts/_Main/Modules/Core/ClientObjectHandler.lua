--[[ 
this script is used to boot up objects
]]

local dirClient = require(script.Parent.Parent.Parent.Directory)
local dir = dirClient.Main
local ObjectInitializer = require(game.ReplicatedStorage.m_Shared._Main.Modules.ObjectManagement.ObjectInitializer)
-- load order
local ObjectHandler = {
    ObjectInit = ObjectInitializer.new("LocalController"),
    owned = {}
}

function ObjectHandler:PreInit()
    dir.Net:Connect(dir.Events.Reliable.OnInitialize, function(required)
        if self.owned[required] then return end
        if dir.Consts.PRINT_OBJ_LIFETIME then warn(`shimureishon {dir.NetUtils:GetId(required)}`) end

        self.owned[required] = self.ObjectInit:Execute(required)
    end)

    dir.Net:Connect(dir.Events.Reliable.OnDestroy, function(required)
        if self.owned[required] then
            if dir.Consts.PRINT_OBJ_LIFETIME then warn(`shimureishon owaru {dir.NetUtils:GetId(required)}`) end

            self.owned[required].destroy()
            self.owned[required] = nil
        end
    end)
end

return ObjectHandler