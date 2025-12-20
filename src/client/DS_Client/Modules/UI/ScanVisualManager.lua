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
local scanVisualTemplate = dir.Assets.Models.ScanVisual

local ScanVisualManager = {}
local activePrompts = {}

function ScanVisualManager:Init()
    PPS.PromptShown:Connect(function(prompt: ProximityPrompt, inputType)
        if CS:HasTag(prompt, dir.Consts.DOOR_SCANNER_PROMPT_TAG) then
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
                OnDestroy = function()
                    activePrompts[scanVisual] = nil
                end
            }, scanVisualModel:WaitForChild("Required")):ConnectEvents()
            activePrompts[scanVisual] = scanVisual
        end
    end)
    RS.RenderStepped:Connect(function(dt)
        for visual in activePrompts do
             visual:Update(dt)
        end
    end)
end

return ScanVisualManager
