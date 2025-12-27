--#region required
local dir = require(script.Parent.Parent.Parent.Directory)
local validator = dir.Validator.new(script.Name)
local Signal = require(dir.Utility.Signal)
local RunService = game:GetService("RunService")
local TS = game:GetService("TweenService")
local SFX = dir.Assets.Sounds
--#endregion required
--[[
interprets a set of instructions to apply to parts.
this module is a bit messy because i made this wit OOP in mind before realizing server-side tweens suck
]]

local TweenMoveSequence = {}

local function ParseAnim(config, parts)
    if not parts then return end
    local anim = {}
    -- grab the instructions to translate into actionable tweens
    for key, stepsForPart in pairs(config) do
        -- grab the parts corresponding to the instructions
        local partFolder = parts:FindFirstChild(key)
        if not partFolder then
            validator:Warn("corresponding part for " .. key .. " instruction doesn't exist, ignoring")
            continue
        end
        local mover = partFolder:FindFirstChild("Mover") and partFolder["Mover"].Value or nil
        if not mover then
            validator:Warn("mover for " .. key .. " in part folder doesn't exist, ignoring")
            continue
        end
        ---------------------------------------------------------------

        -- translate the two into tweens that use the part as the instance
        -- and the instruction as the info/move
        for timeOf, step in pairs(stepsForPart) do
            local to = validator:Exists(partFolder[step.to], "end goal of step for " .. key).Value
            local sound = step.sound[1] and SFX:FindFirstChild(step.sound[1]) or nil
            local soundParent = step.sound[2] and partFolder:FindFirstChild(step.sound[2]) or mover
            if step.sound[1] and not sound then
                validator:Warn("sound asset " .. step.sound .. " is not in DS_Replicated.Assets.Sounds")
            end
            if step.sound[2] and soundParent == mover then
                validator:Warn("sound parent " .. step.sound[2] .. " is not in the part folder, defaulting to part")
            end

            table.insert(anim, {
                timeOf = timeOf,
                tween = TS:Create(mover, TweenInfo.new(table.unpack(step.info)), {CFrame = to.CFrame}),
                sound = sound,
                soundParent = soundParent
            })
        end
    end
    return anim
end

local function GetAnimLength(config)
    local maxTime = 0
    for _, stepsForPart in pairs(config) do
        for timeOf, step in pairs(stepsForPart) do
            maxTime = math.max(maxTime, timeOf + step.info[1] or 0) --step.info[1] is the tween time
        end
    end
    return maxTime
end

function TweenMoveSequence:ExecuteOnServer(config, parts)
    dir.NetUtils:FireAllClients(dir.Events.Reliable.PlayAnimation, config, parts)
    return GetAnimLength(config)
end

function TweenMoveSequence:ExecuteOnClient(config, parts)
    local onFinish = Signal.new()
    local anim = ParseAnim(config, parts)
    local remainingSteps = #anim
    for _, step in pairs(anim) do
        task.delay(step.timeOf, function()
            if step.sound then
                local sfx = (step.sound:Clone()) :: Sound
                sfx.Parent = step.soundParent
                sfx:Play()
                sfx.Ended:Once(function()
                    sfx:Destroy()
                end)
            end

            if step.tween then
                step.tween:Play()
                step.tween.Completed:Once(function()
                    remainingSteps -= 1
                    if remainingSteps == 0 then
                        onFinish:Fire()
                    end
                end)
            else
                onFinish:Fire()
            end
        end)
    end

    return onFinish
end

return TweenMoveSequence