local OptionLocator = {}
OptionLocator.__index = OptionLocator

function OptionLocator.new(options)
    local self = setmetatable({
        ["options"] = options,
        ["selections"] = {},
    }, OptionLocator)

    return self
end

function OptionLocator:Dump()
    warn("=== OptionLocator Dump ===")
    print("Options:", self.options)
    print("Selections:", self.selections)
    warn("==========================")
end

function OptionLocator:GetModule(optionName)
    local optionData = self.options[optionName]
    if not optionData then
        self:Dump()
        error(`[OptionLocator] No option configuration defined for {optionName}`, 2)
    end

    local folderPath = optionData.path or optionData[1]
    local moduleName = self.selections[optionName] or optionData.default

    if not folderPath then
        self:Dump()
        error(`[OptionLocator] No path defined for option {optionName}`, 2)
    end

    if not moduleName then
        self:Dump()
        error(`[OptionLocator] No default or selected module name for option {optionName}`, 2)
    end

    local moduleScript = folderPath:FindFirstChild(moduleName)
    if not moduleScript then
        self:Dump()
        error(`[OptionLocator] Could not find module {moduleName} in {folderPath:GetFullName()}`, 2)
    end

    return moduleScript
end

function OptionLocator:Get(optionName)
    return require(self:GetModule(optionName))
end

function OptionLocator:Select(selection)
    self.selections = selection
end

return OptionLocator