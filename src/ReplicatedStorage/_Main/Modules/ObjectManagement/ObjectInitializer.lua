--#region required
local dir = require(script.Parent.Parent.Parent.Directory)
local ObjectRegistry = require(script.Parent.ObjectRegistry)
local OptionLocator = require(dir.Utility.OptionLocator)
--#endregion required
--[[
This runs the initialization process and returns the object + relevant connections.
]]

local ObjectInitializer = {}
ObjectInitializer.__index = ObjectInitializer

function ObjectInitializer.new(controllerType)
    local self = setmetatable({}, ObjectInitializer)
    self.controllerType = controllerType
    self.registeredControllers = {}
    self.registeredPrefabs = OptionLocator.new({})
    return self
end

-- register the instance, not the require
function ObjectInitializer:RegisterController(key, module)
    self.registeredControllers[key] = module
end

function ObjectInitializer:RegisterPrefabs(key, path)
    self.registeredPrefabs.options[key] = {["path"] = path}
end

function ObjectInitializer:GetControllerInstance(root, required)
    local controller, prefab
    if not root:IsA("ModuleScript") then
        warn(`root of {required.Parent.Name} should be a ModuleScript!`)
        return
    end
    local config = require(root)

    -- find prefab
    -- TODO: what is this bro???? 0Head
    self.registeredPrefabs:Select({[config.SystemType] = config.Prefab})
    prefab = self.registeredPrefabs:Get(config.SystemType)

    if not prefab then
        warn(`prefab {config.Prefab} not found for system {config.SystemType}`)
        prefab = {}
    end

    -- find controller (optional)
    if config[self.controllerType] then
        controller = self.registeredControllers[config[self.controllerType]]
    end
    
    if not controller then
        if config[self.controllerType] then
            warn(`no controller for {required.Parent.Name} (controller: {config[self.controllerType]})`)
        end
        return nil
    end

    -- gen and setup instance
    local obj = require(controller).new(prefab, required)
    obj.ClassName = controller.Name

    return obj
end

---initializes and registers obj. according to prefab/controller link
---@param required Folder the folder containing all components and references
---@return table the object and the corresponding method to destroy it
function ObjectInitializer:Execute(required)
    if ObjectRegistry:WasRegistered(required) then
        print(`Object of GUID {dir.NetUtils:GetId(required)} was already registered.`)
        return
    end
    local entryPoint = required:FindFirstChild("InitRoot")
    local obj = self:GetControllerInstance(entryPoint, required)
    if not obj then return end

    ------------ (the point where stuff actually happens) -------------


    -- attach a bunch of GC stuff, since this is a huge risk for memory leaks
    local function DestroyObj()
        ObjectRegistry:Deregister(required)
    end
    required.Destroying:Connect(DestroyObj)

    return {
        object = ObjectRegistry:Register(obj, required),
        destroy = DestroyObj,
    }
end

return ObjectInitializer