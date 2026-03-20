--#region required
local dirClient = require(script.Parent.Parent.Parent.Directory)
local types = dirClient.Types
local dir = dirClient.Main
local AttachUIDisplay = require(dirClient.Modules.AttachmentSystem.Attach_UIDisplay)
--#endregion required

--[[
    Refill_UIHandler
    Manages the UI interaction for reloading/refilling attachments.
]]

local template = dir.Assets.UI.RefillUI
local player = game.Players.LocalPlayer

local UI = {}
UI.__index = UI

local function _setupComponents(args, required)
    local canvas = template:Clone()
    
    local mainPanel = canvas:FindFirstChild("Main")
    local slotsPanel = mainPanel and mainPanel:FindFirstChild("Slots")

    local components = {
        main = mainPanel,
        slots = slotsPanel,
    }

    return canvas, components
end

function UI.new(args, required)
    local self = setmetatable({
        maid = dir.Maid.new(),
        signals = args.signals,
        referencePart = args.referencePart,
        attachController = args.attachClientController,
    }, UI)

    self.canvas, self.components = _setupComponents(args, required)
    self.canvas.Parent = player.PlayerGui
    self.maid:GiveTask(self.canvas)

    self.attachUIDisplay = AttachUIDisplay.new(self.components.slots, self.attachController, args.referencePart)
    self.maid:GiveTask(self.attachUIDisplay)

    self.maid:GiveTask(self.attachUIDisplay.OnSlotClicked:Connect(function(index, slot)
        print(`clicked index {index} with {slot}`)
    end))

    self:SetupConnections(self.signals)
    return self
end

function UI:SetupConnections(signals)
end

function UI:Update(dt, state)
end

function UI:Destroy()
    self.maid:DoCleaning()
end

return UI