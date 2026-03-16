local dir = require(script.Parent.Parent.Parent.Parent.Directory).Main
local ScannerAutoMount = {
    TriggerType = dir.Consts.INTERACTION_TYPE.PROMPT_ENTER
}
local PING_DIFF

function ScannerAutoMount:Execute(prompt: ProximityPrompt, callback)
    local RemoteEvent = Instance.new("RemoteEvent", prompt)

    return RemoteEvent.OnServerEvent:Connect(function(player)
        local center = prompt.Parent.Position
        local targ = player.Character and player.Character:FindFirstChild("HumanoidRootPart") or nil
        if not targ then return end

        -- sanity check so people can't trigger things too far away
        local mag = (center - targ.Position).Magnitude
        local buffer = prompt.MaxActivationDistance + 6
        if mag > buffer then return end
        callback(player)
    end)
end

return ScannerAutoMount