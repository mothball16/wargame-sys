--#region required
local dirClient = require(script.Parent.Parent.Parent.Directory)
local dir = dirClient.Main
local validator = dir.Validator.new(script.Name)
local ScanVisual = require(script.Parent.ScanVisual)
--#endregion required
--[[
this handles the prompt visuals
hardcoded to use only 1 asset type for now (i lazy)
]]
local PPS = game:GetService("ProximityPromptService")
local CS = game:GetService("CollectionService")
local RS = game:GetService("RunService")
local HTTPS = game:GetService("HttpService")
local scanVisualTemplate = dir.Assets.Models.ScanVisual
local throttle, throttleVal = 0.2, 0.2

local ScanClientManager = {}
local activePrompts = {}

-- this would be replaced by whatever settings system you guys have
local SETTINGS_DEMO = {
    rotateTowardsCam = false
}

local function _CreateVisual(prompt, id)
    local promptStateType = prompt:GetAttribute(dir.Consts.DOOR_SCAN_VISUAL_ATTR)
    if not promptStateType then
        validator:Warn(
            "prompt doesn't have corresponding attr. "
            .. dir.Consts.DOOR_SCAN_VISUAL_ATTR
            .. " , aborting")
    end
    local scanVisual
    local scanVisualModel = scanVisualTemplate:Clone()
    scanVisualModel.Parent = prompt.Parent

    scanVisual = ScanVisual.new({
        model = scanVisualModel,
        initCF = prompt.Parent.CFrame,
        initState = promptStateType,
        beamInteractionType = ScanVisual.BeamInteractionType.LockToTrackPart,
        prompt = prompt,
        rotateTowardsCam = SETTINGS_DEMO["rotateTowardsCam"],
        OnDestroy = function()
            activePrompts[id] = nil
        end
    }, scanVisualModel:WaitForChild("Required")):ConnectEvents()
    return scanVisual
end

local function _RunInteractionCheck(prompt)
    local remote = prompt:FindFirstChildOfClass("RemoteEvent")
    if not remote then
        validator:Warn("no remote found in prompt, can't setup PromptEnter interaction??")
        return
    end
    remote:FireServer()
end

function ScanClientManager:Init()
    PPS.PromptShown:Connect(function(prompt: ProximityPrompt, inputType)
        if CS:HasTag(prompt, dir.Consts.DOOR_SCANNER_PROMPT_TAG) then
            local shouldDisplay = prompt:GetAttribute(dir.Consts.DOOR_SCANNER_SHOULD_DISPLAY_PROMPT_ATTR)
            local interactionType = prompt:GetAttribute(dir.Consts.DOOR_SCANNER_INTERACTION_TYPE_ATTR)
            local id = HTTPS:GenerateGUID()
            local scanVisual
            if shouldDisplay then
                scanVisual = _CreateVisual(prompt, id)
            end
            if interactionType == dir.Consts.INTERACTION_TYPE.PROMPT_ENTER then
                _RunInteractionCheck(prompt)
            end

            activePrompts[id] = {
                prompt = prompt,
                visual = scanVisual,
                interactionType = interactionType
            }
        end
    end)

    RS.RenderStepped:Connect(function(dt)
        for id, data in pairs(activePrompts) do
            if data.visual then
                data.visual:Update(dt)
            end

            throttle += dt
            if throttle > throttleVal then
                throttle -= throttleVal
                if data.interactionType == dir.Consts.INTERACTION_TYPE.PROMPT_ENTER then
                    _RunInteractionCheck(data.prompt)
                end
            end
        end
    end)
end

return ScanClientManager
