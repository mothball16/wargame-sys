local CollectionService = game:GetService("CollectionService")
local ProximityPromptService = game:GetService("ProximityPromptService")
--#region required
local dirClient = require(script.Parent.Parent.Parent.Directory)
local dir = dirClient.Main
local AttachSelector = require(dir.Modules.AttachmentSystem.AttachSelector)
local RequestAttachmentAttach = dir.Net:RemoteEvent(dir.Events.Reliable.RequestAttachmentAttach)
--#endregion required
--[[

]]

local fallbacks = {
    refillType = "TOS220Short"
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

function RefillToolRoot:ReadSelector(selector: typeof(AttachSelector), required)
    local id = dir.NetUtils:GetId(required)
    local slots = selector.slotsByIndex

    for i, slot in ipairs(slots) do
        print(i, slot)
        if not selector:SlotOccupied(slot) then
            print(`refilling slot {i} with {self.config.refillType}`)
            dir.NetUtils:FireServer(dir.Events.Reliable.RequestAttachmentAttach, id, i, self.config.refillType)
        else
            print(selector:GetAttachPointDataAt(i))
        end
    end
end

function RefillToolRoot:SetupConnections()
    self.maid:GiveTask(ProximityPromptService.PromptTriggered:Connect(function(prompt, player)
        if player ~= game.Players.LocalPlayer then return end
        if CollectionService:HasTag(prompt.Parent, dir.Consts.SELECTOR_INTERACT_ATTR) then
            local required = prompt.Parent.Parent
            local selector = AttachSelector.new(self.config, required)
            self:ReadSelector(selector, required)
        end
    end))
end

function RefillToolRoot:Destroy()
    _toggleInteractionPoints(false)
    self.maid:DoCleaning()
end

return RefillToolRoot