local dir = require(script.Parent.Parent.Parent.Parent.Directory).Main
local ScannerManualMount = {
    TriggerType = dir.Consts.INTERACTION_TYPE.TRIGGER
}
--[[
requires the prompt to be triggered
]]
function ScannerManualMount:Execute(prompt: ProximityPrompt, callback)
    return prompt.Triggered:Connect(callback)
end

return ScannerManualMount