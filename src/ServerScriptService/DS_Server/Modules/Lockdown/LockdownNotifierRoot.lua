--#region required
local dirServer = require(script.Parent.Parent.Parent.Directory)
local dir = dirServer.Main
--local TweenMoveSequence = require(dir.Modules.Movement.TweenMoveSequence)
local FX = require(dir.mOS.Modules.FX.FX)
local validator = dir.Validator.new(script.Name)
--#endregion required
--[[
triggers FX activator on the provided event being triggered
WTF ROBLOX HAS STRING INTERPLOATION???
]]
local audio = dir.Assets.Sounds.Lockdown
local RS = game.ReplicatedStorage

local fallbacks = {
    signal = dir.Consts.LOCKDOWN_ATTR
}

local LockdownNotifierRoot = {}
LockdownNotifierRoot.__index = LockdownNotifierRoot

local function GetRequiredComponents(required)
    local parts = validator:IsOfClass(required:FindFirstChild("Parts"), "Folder")
    local FXOrigin = validator:IsOfClass(parts:FindFirstChild("FXOrigin"), "BasePart")
    return parts, FXOrigin
end


function LockdownNotifierRoot.new(args, required)
    local parts, FXOrigin: BasePart = GetRequiredComponents(required)
    local self = setmetatable({
        ClassName = script.Name,
        config = dir.Helpers:TableOverwrite(fallbacks, args),
        maid = dir.Maid.new(),
        parts = parts,
        state = nil,
        playing = nil,
    }, LockdownNotifierRoot)

    -- sets up the FX parts for use by FX activator
    for key, stateFX in pairs(self.config.Instructions) do
        for substateKey, substateData in pairs(stateFX) do
            local FXclone = FXOrigin:Clone()
            FXclone.Parent = parts
            FXclone.Name = `FXEmit{key}{substateKey}`
            for _, soundData in ipairs(substateData) do
                local soundInstance = audio:FindFirstChild(soundData.ID)
                if not soundInstance then
                    warn(`sound instance {soundData.ID} not found, skipping`)
                    continue
                end
                local soundClone: Sound = soundInstance:Clone()
                soundClone.Name = soundData.ID
                soundClone.Looped = soundData.Looped
                soundClone:SetAttribute("Delay", soundData.Delay)
                soundClone.Parent = FXclone
            end
        end
    end

    self:Mount()
    return self
end

-- TODO: un-hardcode the signal location
function LockdownNotifierRoot:Mount()
    local OnLockdownUpdated = RS:GetAttributeChangedSignal(self.config.signal)
    self.maid:GiveTask(OnLockdownUpdated:Connect(function()
        local value = RS:GetAttribute(self.config.signal)
        self:SetState(value)
    end))
end

function LockdownNotifierRoot:_StopPlayingFX()
    if self.playing then
        for _, v: Sound in pairs(self.playing) do
            v:Stop()
        end
    end
end

function LockdownNotifierRoot:SetState(state: string)
    local lookForKeyword = `FXEmit{state}`
    if state == self.state then
        return
    elseif self.state ~= nil and (state == nil or state == "none") then
        lookForKeyword = `FXEmit{self.state}End`
    else
        lookForKeyword = `FXEmit{state}Start`
    end

    self:_StopPlayingFX()
    self.playing = FX.Activate:ExecuteOnServer(nil, {lookFor = lookForKeyword}, {object = self.parts})
    self.state = state
end

function LockdownNotifierRoot:Destroy()
    self.maid:Destroy()
end

return LockdownNotifierRoot