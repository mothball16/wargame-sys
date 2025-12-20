--#region required
local dirServer = require(script.Parent.Parent.Parent.Directory)
local dir = dirServer.Main
local validator = dir.Validator.new(script.Name)
local Strategies = script.Parent.ScannerStrategy
--#endregion required
--[[
handles prompt interaction triggers & displays
no authoritative state on the actual functions
]]
local RESET_TIME = 5

local fallbacks = {
    Template = "DefaultScanner",
    ScanVisual = "Default",
    OnUseStrategy = "ScannerPortalStrategy",
    UseThrottle = 1
}

local Scanner = {}
Scanner.__index = Scanner

function Scanner.new(args)
    local self = setmetatable({
        config = dir.Helpers:TableOverwrite(fallbacks, args),
        maid = dir.Maid.new(),
        prompt = args.prompt,
        OnTriggered = args.OnTriggered,
        runCount = 0,
        lock = false
    }, Scanner)

    self.OnUseStrategy = require(
        assert(
            Strategies:FindFirstChild(self.config.OnUseStrategy),
            "onUseStrategy missing"))

    return self
end



function Scanner:_Triggered(plr)
    -- check lock, throttle the scanner if unlocked
    if self.lock then return end

    local status = self.config.OnActivated(plr)
    if status == dir.Consts.ACCESS_DENIED then
        self.prompt:SetAttribute(dir.Consts.DOOR_SCAN_VISUAL_ATTR, "Denied")
        self:SetLock(true)
        task.delay(self.config.UseThrottle, function()
            self:SetLock(false)
        end)
    end

    self.OnUseStrategy:Execute(self.model, status)

    -- resets the scanner if no actions have further occured
    self.runCount += 1
    local curRunCount = self.runCount
    task.delay(RESET_TIME, function()
        if curRunCount == self.runCount then
            self.OnUseStrategy:Execute(self.model, dir.Consts.ACCESS_NEUTRAL)
        end
    end)
end

function Scanner:Mount()
    -- setup da model
    local template = dir.Assets.Models:FindFirstChild(self.config.Template)
    if not template then
        validator:Error("model not found in assets (" .. self.config.template .. ")")
    end
    self.model = template:Clone()
    self.model:SetPrimaryPartCFrame(self.prompt.Parent.CFrame)
    self.model.Parent = self.prompt.Parent
    --reset to neut. state
    self.OnUseStrategy:Execute(self.model, dir.Consts.ACCESS_NEUTRAL)

    -- some stuff for connections and external use
    self.maid:GiveTask((self.prompt :: ProximityPrompt).Triggered:Connect(function(plr)
       self:_Triggered(plr)
    end))

    self.prompt:AddTag(dir.Consts.DOOR_SCANNER_PROMPT_TAG)
    self.prompt:SetAttribute(dir.Consts.DOOR_SCAN_VISUAL_ATTR, self.config.ScanVisual)
    return self
end

function Scanner:SetLock(lock)
    -- reset the prompt state
    if not lock then
        self.prompt:SetAttribute(dir.Consts.DOOR_SCAN_VISUAL_ATTR, self.config.ScanVisual)
    end
    self.lock = lock
    self.prompt.Enabled = not lock
end

function Scanner:Destroy()
    self.maid:DoCleaning()
end

return Scanner