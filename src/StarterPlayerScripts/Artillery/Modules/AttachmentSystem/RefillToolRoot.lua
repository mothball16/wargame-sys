local CollectionService = game:GetService("CollectionService")
local ProximityPromptService = game:GetService("ProximityPromptService")
--#region required
local dirClient = require(script.Parent.Parent.Parent.Directory)
local dir = dirClient.Main
local template = dir.Assets.UI.RefillUI
local AttachClientController = require(dirClient.Modules.AttachmentSystem.AttachClientController)
local Refill_UIHandler = require(dirClient.Modules.UIHandlers.Refill_UIHandler)
--#endregion required
--[[

]]

local fallbacks = {
    refillType = "9M27F"
}

local RefillToolRoot = {}
RefillToolRoot.__index = RefillToolRoot

local function GetRequiredComponents(required)
    return
end

local function _toggleInteractionPoints(enabled: boolean)
    for _, interact in ipairs(CollectionService:GetTagged(dir.Consts.SELECTOR_INTERACT_ATTR)) do
        local prox = interact:FindFirstChildOfClass("ProximityPrompt")
        if not prox then return end
        prox.Enabled = enabled
    end
end

function RefillToolRoot.new(args : {
    interactible: boolean
}, required)
    local self = setmetatable({}, RefillToolRoot)
    self.config = dir.Helpers:TableOverwrite(fallbacks, args)
    self.maid = dir.Maid.new()
    _toggleInteractionPoints(true)
    self:SetupConnections()
    return self
end

function RefillToolRoot:_cleanupUI()
    if self.currentUI then
        self.currentUI:Destroy()
        self.currentUI = nil
    end
    if self.currentAttachController then
        self.currentAttachController:Destroy()
        self.currentAttachController = nil
    end
end

function RefillToolRoot:OpenUI(required)
    self:_cleanupUI()

    local id = dir.NetUtils:GetId(required)
    self.currentAttachController = AttachClientController.new(self.config, required)

    self.currentUI = Refill_UIHandler.new({
        referencePart = required:FindFirstChild("OrientationPoint"),
        attachClientController = self.currentAttachController,
        signals = {},
    }, required)

    if self.currentUI.attachUIDisplay then
        self.currentUI.maid:GiveTask(self.currentUI.attachUIDisplay.OnSlotClicked:Connect(function(index, slot)
            if not self.currentAttachController.AttachSelector:SlotOccupied(slot) then
                print(`refilling slot {index} with {self.config.refillType}`)
                dir.NetUtils:FireServer(dir.Events.Reliable.RequestAttachmentAttach, id, index, self.config.refillType)
            else
                print(`slot {index} is already occupied`)
            end
        end))
    end
end

function RefillToolRoot:SetupConnections()
    self.maid:GiveTask(ProximityPromptService.PromptTriggered:Connect(function(prompt, player)
        if player ~= game.Players.LocalPlayer then return end
        if CollectionService:HasTag(prompt.Parent, dir.Consts.SELECTOR_INTERACT_ATTR) then
            local required = prompt.Parent.Parent
            self:OpenUI(required)
        end
    end))
end

function RefillToolRoot:Destroy()
    _toggleInteractionPoints(false)
    self:_cleanupUI()
    self.maid:DoCleaning()
end

return RefillToolRoot