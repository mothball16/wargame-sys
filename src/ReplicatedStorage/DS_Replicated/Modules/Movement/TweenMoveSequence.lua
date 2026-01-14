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

-- helper cause parseanim and getanimendstate use the same iteraiton logic
local function ForEachMover(config, parts, fn)
    if not parts then
        warn("no parts?")
        return
    end
    -- grab the instructions to translate into actionable tweens
    for key, stepsForPart in pairs(config) do
        -- grab the parts corresponding to the instructions
        local partFolder = parts:WaitForChild(key)
        if not partFolder then
            validator:Warn("corresponding part for " .. key .. " instruction doesn't exist, ignoring")
            continue
        end
        local mover = partFolder:WaitForChild("Mover")
        if not mover then
            validator:Warn("mover for " .. key .. " in part folder doesn't exist, ignoring")
            continue
        end
        fn(key, stepsForPart, partFolder, mover)
    end
end

local function ParseAnim(config, parts)
    local anim = {}
    ForEachMover(config, parts, function(key, stepsForPart, partFolder, mover)
        for timeOf, step in pairs(stepsForPart) do
            local to = validator:Exists(partFolder[step.to], "end goal of step for " .. key)
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
    end)
    return anim
end

local function GetAnimEndState(config, parts)
    local partStates = {}
    ForEachMover(config, parts, function(key, stepsForPart, partFolder, mover)
        local lastTime = -math.huge
        local lastCF

        for timeOf, step in pairs(stepsForPart) do
            if timeOf > lastTime then
                lastTime = timeOf
                local to = assert(partFolder[step.to], "end goal of step for " .. key)
                lastCF = to.CFrame
            end
        end

        if lastCF then
            partStates[mover] = lastCF
        end
    end)

    return partStates
end

function TweenMoveSequence:GetAnimLength(config)
    local maxTime = 0
    for _, stepsForPart in pairs(config) do
        for timeOf, step in pairs(stepsForPart) do
            maxTime = math.max(maxTime, timeOf + (step.info[1] or 0)) --step.info[1] is the tween time
        end
    end
    return maxTime
end

function TweenMoveSequence:ExecuteOnServer(config, parts)
    dir.NetUtils:FireAllClients(dir.Events.Reliable.PlayAnimation, config, parts)
    return self:GetAnimLength(config)
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

function TweenMoveSequence:ExecuteOnClientImmediate(config, parts)
    for part, cf in pairs(GetAnimEndState(config, parts)) do
        part.CFrame = cf
    end
end

return TweenMoveSequence