--#region required
local dirServer = require(script.Parent.Parent.Parent.Directory)
local dir = dirServer.Main
local TweenMoveSequence = require(dir.Modules.Movement.TweenMoveSequence)
local FX = require(dir.Utility.FX.FX)
local validator = dir.Validator.new(script.Name)
local SSS = game.ServerScriptService
--#endregion required
--[[
This is the purpose of this script.
]]
local audio = dir.Assets.Sounds.Lockdown
local fallbacks = {

}
local LockdownNotifierRoot = {}
LockdownNotifierRoot.__index = LockdownNotifierRoot

LockdownNotifierRoot.State = {
    Off = "Off",
--    Activating = "Activating",
    On = "On",
--    Deactivating = "Deactivating",
}


local function _checkSetup(required)
    local parts = validator:IsOfClass("Parts", "Folder")
    
end


function LockdownNotifierRoot.new(args, required)
    local self = setmetatable({
        config = dir.Helpers:TableOverwrite(fallbacks, args),
        maid = dir.Maid.new(),
        playing = {}
    }, LockdownNotifierRoot)
    return self
end

function LockdownNotifierRoot:Mount()
    local OnLockdownUpdated = SSS:GetAttributeChangedSignal(dir.Consts.LOCKDOWN_ATTR)
    self.maid:GiveTasks(OnLockdownUpdated:Connect(function(isLockdown)
        if isLockdown == true then
            for id, args in pairs(self.config.OnStart.Audio) do

            end
            -- for id, args in pairs(self.config.OnStart.Sequences) do end
        else
            for id, args in pairs(self.config.OnStart.Audio) do
                
            end
            -- for id, args in pairs(self.config.OnStart.Sequences) do end
        end
    end))
end

function LockdownNotifierRoot:SetState(state: string)
    dir.Helpers:Switch ()
end

return LockdownNotifierRoot