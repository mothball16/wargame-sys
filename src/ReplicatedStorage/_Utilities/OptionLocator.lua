local OptionLocator = {}
OptionLocator.__index = OptionLocator

function OptionLocator.new(optionsConfig, selectedOptions)
    local self = setmetatable({}, OptionLocator)
    self.config = optionsConfig or {}
    self.selections = selectedOptions or {}
    return self
end

function OptionLocator:GetModuleScript(optionName)
    local optData = self.config[optionName]
    if not optData then
        error(`[OptionLocator] No option configuration defined for '{optionName}'`, 2)
    end

    local folderPath = optData.path or optData[1]
    local moduleName = self.selections[optionName] or optData.default

    if not folderPath then
        error(`[OptionLocator] No path defined for option '{optionName}'`, 2)
    end

    if not moduleName then
        error(`[OptionLocator] No default or selected module name for option '{optionName}'`, 2)
    end

    local moduleScript = folderPath:FindFirstChild(moduleName)
    if not moduleScript then
        error(`[OptionLocator] Could not find module '{moduleName}' in {folderPath:GetFullName()}`, 2)
    end

    return moduleScript
end

function OptionLocator:Get(optionName)
    return require(self:GetModuleScript(optionName))
end

return OptionLocator