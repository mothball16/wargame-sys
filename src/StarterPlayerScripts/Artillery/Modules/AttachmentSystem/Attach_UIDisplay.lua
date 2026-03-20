--#region requires
local dirClient = require(script.Parent.Parent.Parent.Directory)
local dir = dirClient.Main
local Signal = require(dir.Utility.Signal)
local template = dir.Assets.UI.Slot
--#endregion

local AttachUIDisplay = {}
AttachUIDisplay.__index = AttachUIDisplay


function AttachUIDisplay.new(canvasFrame: Frame, attachClientController: table, orientationPoint: BasePart, options: {
    xScale: number,
    yScale: number,
    slotSize: number
}?)
    options = options or {}
    local self = setmetatable({
        canvasFrame = canvasFrame,
        attachController = attachClientController,
        orientationPoint = orientationPoint,
        xScale = options.xScale or 0.8,
        yScale = options.yScale or 0.8,
        slotSize = options.slotSize,
        OnSlotClicked = Signal.new(),
        buttons = {},
        maid = dir.Maid.new()
    }, AttachUIDisplay)

    self:_drawSlots()

    -- wire up updates
    self.maid:GiveTask(self.attachController.localSignals.OnRackUpdated:Connect(function()
        self:_updateStates()
    end))

    return self
end

function AttachUIDisplay:_drawSlots()
    local slotsList = self.attachController.AttachSelector.slotsByIndex
    if not slotsList or #slotsList == 0 then return end

    local minX, maxX = math.huge, -math.huge
    local minY, maxY = math.huge, -math.huge
    --local minZ, maxZ = math.huge, -math.huge
    local relativePositions = {}

    -- find bounds before mapping
    for i, slot in ipairs(slotsList) do
        local relativeCF = self.orientationPoint.CFrame:ToObjectSpace(slot.CFrame)
        local pos = relativeCF.Position
        relativePositions[i] = pos
        minX, maxX = math.min(minX, pos.X), math.max(maxX, pos.X)
        minY, maxY = math.min(minY, pos.Y), math.max(maxY, pos.Y)
    end

    local rangeX = maxX - minX
    local rangeY = maxY - minY
    --local rangeZ = maxZ - minZ

    local offsetX = (1 - self.xScale) / 2
    local offsetY = (1 - self.yScale) / 2

    for i, slot in ipairs(slotsList) do
        local pos = relativePositions[i]
        -- defaults
        local normX, normY = 0.5, 0.5
        if rangeX > 0.001 then
            normX = offsetX + self.xScale * ((pos.X - minX) / rangeX)
        end
        if rangeY > 0.001 then
            normY = offsetY + self.yScale * (1 - ((pos.Y - minY) / rangeY))
        end

        local btn = template:Clone()
        btn.Parent = self.canvasFrame
        btn.Position = UDim2.fromScale(normX, normY)

        if self.slotSize then
            btn.Size = UDim2.fromScale(btn.Size.X.Scale * self.slotSize, btn.Size.Y.Scale * self.slotSize)
        end

        self:_setButtonState(btn, slot:GetAttribute(dir.Consts.SLOT_OCCUPIED_ATTR))

        self.maid:GiveTask(btn.Main.SlotButton.MouseButton1Click:Connect(function()
            self.OnSlotClicked:Fire(i, slot)
        end))

        self.buttons[i] = btn
    end
end

function AttachUIDisplay:_setButtonState(btn: TextButton, isOccupied: boolean)
    btn.Main.SlotButton.BackgroundColor3 = isOccupied and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(60, 60, 60)
end

function AttachUIDisplay:_updateStates()
    for i, btn in pairs(self.buttons) do
        local slot = self.attachController.AttachSelector.slotsByIndex[i]
        if slot then
            self:_setButtonState(btn, slot:GetAttribute(dir.Consts.SLOT_OCCUPIED_ATTR))
        end
    end
end

function AttachUIDisplay:Destroy()
    self.maid:DoCleaning()
end

return AttachUIDisplay