local dir = require(game.ReplicatedStorage.m_Shared._Main.Directory)
local ObjectInitializer = require(dir.Modules.ObjectManagement.ObjectInitializer)

local ServerObjectHandler = {
    ObjectInit = ObjectInitializer.new("ServerController"),
    owned = {}
}


function ServerObjectHandler:PreInit()
    dir.ServerSignals.InitObject:Connect(function(required)
        self.owned[required] = self.ObjectInit:Execute(required)
        
        if dir.Consts.PRINT_OBJ_LIFETIME then warn(`shimureishon {dir.NetUtils:GetId(required)}`) end
    end)

    dir.ServerSignals.DestroyObject:Connect(function(required)
        if not self.owned[required] then
            warn("object " .. (required and required.Name or "<not found>") .. " wasn't found in ServerObjectHandler")
        end
        if dir.Consts.PRINT_OBJ_LIFETIME then warn(`shimureishon owaru {dir.NetUtils:GetId(required)}`) end

        self.owned[required].destroy()
        self.owned[required] = nil
    end)
end

return ServerObjectHandler