--#region required
local dirClient = require(script.Parent.Parent.Parent.Directory)
local dir = dirClient.Main
local AnimationLoader = require(dir.Utility.AnimationLoader)
local Signal = require(dir.Utility.Signal)
local validator = dir.Validator.new(script.Name)
local player = game.Players.LocalPlayer
--#endregion required
--[[
pullup bar for muffinstink > : )
very unlikely to be re-used or expanded upon so no 1000 lines of abstraction here. input is read thru the UI handler
]]

local fallbacks = {
    weldToR6 = "Torso",
    weldToR15 = "UpperTorso",
    anims = {
        ["begin"] = "",
        ["idle"] = "",
        ["perform"] = "",
        ["end"] = "",
    },
}

local PTState = {
    Mounting = 1,
    Idle = 2,
    Performing = 3,
    Dismounting = 4
}

local PTMachineRoot = {}
PTMachineRoot.__index = PTMachineRoot

local function GetRequiredComponents(required)
    local handler = require(validator:ValueIsOfClass(required:FindFirstChild("PTHandler"), "ModuleScript"))
    local anchor = validator:ValueIsOfClass(required:FindFirstChild("Anchor"))
    local char = validator:Exists(player.Character, "pchar")
    return handler, anchor, char
end

function PTMachineRoot.new(args, required)
    local handler, anchor, char = GetRequiredComponents(required)
    local self = setmetatable({
        config = dir.Helpers:TableOverwrite(fallbacks, args),
        maid = dir.Maid.new(),
        handler = handler,
        anchor = anchor,
        state = PTState.Mounting,
        localSignals = {
            RequestPerform = Signal.new(),
            RequestDismount = Signal.new()
        }
    }, PTMachineRoot)

    local isR15 = char.Humanoid.RigType == Enum.RigType.R15
    self.attachPoint = isR15 and char:FindFirstChild(self.config.weldToR15) or char:FindFirstChild(self.config.weldToR6)
    if not self.attachPoint then
        validator:Warn("attachpoint wasn't found on the character")
    end
    
    self.attachMotor = Instance.new("Motor6D")
    self.attachMotor.Part0 = self.attachPoint
    self.attachMotor.Part1 = self.anchor
    self.attachMotor.C0 = self.attachMotor.Part0.CFrame:Inverse() * self.attachMotor.Part1.CFrame
    self.animationLoader = AnimationLoader.new(char.Humanoid:FindFirstChildOfClass("Animator"))
    self.maid:GiveTasks(self.attachMotor, self.animationLoader)

    self.beginAnim = self.animationLoader:LoadAnimation("begin",
        {id = self.config.anims.begin, looped = false, priority = Enum.AnimationPriority.Action}) :: AnimationTrack
    self.idleAnim = self.animationLoader:LoadAnimation("idle",
        {id = self.config.anims.begin, looped = true, priority = Enum.AnimationPriority.Idle})
    self.performAnim = self.animationLoader:LoadAnimation("perform",
        {id = self.config.anims.begin, looped = false, priority = Enum.AnimationPriority.Action})
    self.endAnim = self.animationLoader:LoadAnimation("end",
        {id = self.config.anims.begin, looped = false, priority = Enum.AnimationPriority.Action})

    self.beginAnim:Play()
    self.beginAnim.Ended:Once(self:Init())
    return self
end

function PTMachineRoot:Init()
    self.localSignals.RequestPerform:Connect(function()
        if self.state ~= PTState.Idle then return end
        self:Perform()
    end)
end

function PTMachineRoot:Perform()
    self.state = PTState.Performing
    self.performAnim:Play()
    self.performAnim.Ended:Once(function()
        self.state = PTState.Idle
    end)
end

function PTMachineRoot:Dismount()
    self.endAnim:Play()
    self.endAnim.Ended:Once(function()
        self:Destroy()
    end)
end

function PTMachineRoot:Destroy()
    self.maid:DoCleaning()
end

return PTMachineRoot