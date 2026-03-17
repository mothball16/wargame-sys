local OptionLocator = {}
OptionLocator.__index = OptionLocator

function OptionLocator.new(options)
    local self = setmetatable({
        ["options"] = options,
    }, OptionLocator)

    return self
end

function OptionLocator:GetModule(optionName)
    local optionData = self.options[optionName]
    if not optionData then
        error(`[OptionLocator] No option configuration defined for {optionName}`, 2)
    end

    local folderPath = optionData.path or optionData[1]
    local moduleName = self.selections[optionName] or optionData.default

    if not folderPath then
        error(`[OptionLocator] No path defined for option {optionName}`, 2)
    end

    if not moduleName then
        error(`[OptionLocator] No default or selected module name for option {optionName}`, 2)
    end

    local moduleScript = folderPath:FindFirstChild(moduleName)
    if not moduleScript then
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