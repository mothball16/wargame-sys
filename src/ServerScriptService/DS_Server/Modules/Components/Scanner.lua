--#region required
local dirServer = require(script.Parent.Parent.Parent.Directory)
local dir = dirServer.Main
local validator = dir.Validator.new(script.Name)
local ScannerTemplates = dir.Assets.Models.ScannerTemplates
local UseStrategies = script.Parent.ScannerExecuteStrategy
local MountStrategies = script.Parent.ScannerMountStrategy
--#endregion required
--[[
handles prompt interaction triggers & displays
no authoritative state on the actual functions
]]
local RESET_TIME = 5



local Scanner = {}
Scanner.__index = Scanner

local fallbacks = {
    Template = "DefaultScanner",
    ScanVisual = "Default",
    OnMountStrategy = "ScannerManualMount",
    OnUseStrategy = "ScannerPortalExecute",
    DisplayPrompt = true,
    UseThrottle = 1,
}

function Scanner.new(args, required: Model)
    local self = setmetatable({
        config = dir.Helpers:TableOverwrite(fallbacks, args),
        maid = dir.Maid.new(),
        prompt = args.prompt,
        OnTriggered = args.OnTriggered,
        runCount = 0,
        lock = false
    }, Scanner)

    self.OnMountStrategy = require(
        assert(
            MountStrategies:FindFirstChild(self.config.OnMountStrategy),
            "onMountStrategy missing"))
    self.OnUseStrategy = require(
        assert(
            UseStrategies:FindFirstChild(self.config.OnUseStrategy),
            "onUseStrategy missing"))

    -- buh.....
    self.prompt:SetAttribute(dir.Consts.DOOR_ROOT_STATE_ATTR, required:GetAttribute(dir.Consts.DOOR_ROOT_STATE_ATTR))
    self.maid:GiveTask(required:GetAttributeChangedSignal(dir.Consts.DOOR_ROOT_STATE_ATTR):Connect(function()
        self.prompt:SetAttribute(dir.Consts.DOOR_ROOT_STATE_ATTR, required:GetAttribute(dir.Consts.DOOR_ROOT_STATE_ATTR))
    end))
    return self
end



function Scanner:_Triggered(plr)
    -- check lock, throttle the scanner if unlocked
    if self.lock then return end

    local status = self.config.OnActivated(plr)
    if status == dir.Consts.ACCESS_DENIED then
        self:SetPromptVisual("Denied")
        if self.config.UseThrottle > 0 then self:SetLock(true) end
        task.delay(self.config.UseThrottle, function()
            if self.config.UseThrottle > 0 then self:SetLock(false) end
        end)
    end

    self.OnUseStrategy:Execute(self.model, status)

    -- reset prompt visual if accepted
    -- (for autoquerying so denied visual doesnt stay when accepted)
    if status == dir.Consts.ACCESS_ACCEPTED then
        self:SetPromptVisual()
    end

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
    local template = ScannerTemplates:FindFirstChild(self.config.Template)
    if not template then
        validator:Error("model not found in assets (" .. self.config.template .. ")")
    end
    self.model = template:Clone()
    self.model:SetPrimaryPartCFrame(self.prompt.Parent.CFrame)
    self.model.Parent = self.prompt.Parent
    --reset to neut. state & setup connection
    self.OnUseStrategy:Execute(self.model, dir.Consts.ACCESS_NEUTRAL)
    self.maid:GiveTasks(self.OnMountStrategy:Execute(self.prompt, function(...)
        self:_Triggered(...)
    end))

    -- some stuff for connections and external use

    self.prompt:AddTag(dir.Consts.DOOR_SCANNER_PROMPT_TAG)
    self:SetPromptVisual()
    self.prompt:SetAttribute(dir.Consts.DOOR_SCANNER_INTERACTION_TYPE_ATTR, self.OnMountStrategy.TriggerType)
    self.prompt:SetAttribute(dir.Consts.DOOR_SCANNER_SHOULD_DISPLAY_PROMPT_ATTR, self.config.DisplayPrompt)
    return self
end

function Scanner:SetLock(lock)
    self.runCount += 1
    if not lock then
        self:SetPromptVisual()
        self.OnUseStrategy:Execute(self.model, dir.Consts.ACCESS_NEUTRAL)
    else
        self.OnUseStrategy:Execute(self.model, dir.Consts.ACCESS_DISABLED)
    end
    self.lock = lock
    self.prompt.Enabled = not lock
end

function Scanner:SetPromptVisual(state)
    if not state then state = self.config.ScanVisual end
    self.prompt:SetAttribute(dir.Consts.DOOR_SCAN_VISUAL_ATTR, state)
end

function Scanner:Destroy()
    self.maid:DoCleaning()
end

return Scanner