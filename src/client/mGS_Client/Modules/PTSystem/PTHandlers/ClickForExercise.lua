--#region required
local dirClient = require(script.Parent.Parent.Parent.Parent.Directory)
local dir = dirClient.Main
local InputSystem = require(dirClient.mOS.Modules.Input.InputSystem)
local validator = dir.Validator.new(script.Name)
--#endregion required
--[[
shi
]]
local player = game.Players.LocalPlayer
local template = dir.Assets.UI.PTClickOnlyUI

local fallbacks = {
    cooldown = 1
}
local ClickOnly = {}
ClickOnly.__index = ClickOnly

local function _checkSetup(required)
    
end
function ClickOnly.new(args, required)
    local self = setmetatable({
        maid = dir.Maid.new(),
        config = dir.Helpers:TableCombine(fallbacks, args),
    }, ClickOnly)

    
    self.InputSystem = InputSystem.new({
        on = {
            [Enum.UserInputType.MouseButton1] = function()
                if self.debounced then return end
                self.debounced = true
                task.delay(self.config.cooldown, function()
                    self.debounced = false
                end)
            end,
        },
        off = {}
    })

    self.maid:GiveTask(self.InputSystem)
    return self
end

function ClickOnly:SetupUI(args: {title: string})
    local clone = template:Clone()
    clone.Parent = player.PlayerGui
    clone.Title.Text = args.title
    self.maid:GiveTask(clone)
end

function ClickOnly:Destroy()
    self.maid:DoCleaning()
end

return ClickOnly