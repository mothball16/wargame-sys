local share = game.ReplicatedStorage.Shared
local dir = require(share.mOS_Replicated.Directory)
local validator = dir.Validator.new(script.Name)
local isServer = game:GetService("RunService"):IsServer()

return function(root)
    local bootstrappers = {}

    for _, folder in ipairs(root:GetChildren()) do
        if folder:HasTag(dir.Consts.FOLDER_IDENT_TAG_NAME) then
            local bootstrapper = validator:Exists(folder:FindFirstChild("Bootstrapper"), "bootstrapper of folder " .. folder.Name)
            local loadOrder = folder:GetAttribute(dir.Consts.LOAD_ORDER_TAG_NAME) or 999
            if bootstrapper:GetAttribute(dir.Consts.LOAD_ORDER_TAG_NAME) then
                warn("place load order attribute of " .. folder.Name .. " into the folder, not the bootstrapper script")
            end

            table.insert(bootstrappers, {
                load = loadOrder,
                module = require(bootstrapper),
                name = folder.Name
            })
        end
    end

    local beginTime = os.clock()
    warn(root.Name .. " - beginning load...")

    table.sort(bootstrappers, function(a, b)
        return a.load < b.load
    end)

    for _, bootstrapper in ipairs(bootstrappers) do
        validator:Log("loading " .. bootstrapper.name .. "...")
        bootstrapper.module:Init()
    end

    local endTime = os.clock()
    warn(root.Name .. " - load completed in".. (endTime - beginTime) .. "sec.")
    if isServer then
        game.ServerScriptService:SetAttribute(dir.Consts.FRAMEWORK_LOADED_ATTR, true)
    else
        game.StarterPlayer:SetAttribute(dir.Consts.FRAMEWORK_LOADED_ATTR, true)
    end
end