local dirClient = require(game.StarterPlayer.StarterPlayerScripts.Client.DS_Client.Directory)
local dir = dirClient.Main
local GeneralSettings = require(dir.Configs.GeneralConfig)
local promptRotates = GeneralSettings.RotatePromptsTowardCamera
local plr = game.Players.LocalPlayer

plr.CharacterAdded:Connect(function(character)
    
end)

require(dirClient.mOS.Modules.Input.InputSystem).new({
    on = {
        [Enum.KeyCode.R] = function()
            promptRotates = not promptRotates
            GeneralSettings.RotatePromptsTowardCamera = promptRotates
            GeneralSettings.PromptPitchOffset = promptRotates and 0 or 15
            warn("changed promptrotates: " .. tostring(promptRotates))
        end,
        [Enum.KeyCode.T] = function()
            dir.NetUtils:FireServer(dir.Events.Reliable.RunTest, "ToggleLockdown")
        end,
        [Enum.KeyCode.Y] = function()
            dir.NetUtils:FireServer(dir.Events.Reliable.RunTest, "ToggleByAttribute")
        end,
        [Enum.KeyCode.G] = function()
            dir.NetUtils:FireServer(dir.Events.Reliable.RunTest, "ToggleSingleDoor")
        end,
        [Enum.KeyCode.H] = function()
            dir.NetUtils:FireServer(dir.Events.Reliable.RunTest, "LockSingleDoor")
        end,
    },
})