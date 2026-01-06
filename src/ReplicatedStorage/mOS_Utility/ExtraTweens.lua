local ExtraTweens = {}
local TS = game:GetService("TweenService")

function ExtraTweens:FadeBeam(tweenInfo, beam, fadeIn)
    -- stupid ah beam transparency tween.. 67
    local goalTrans = beam.Transparency.Keypoints
    local startTrans = {}
    for _, v in pairs(goalTrans) do
        table.insert(startTrans, NumberSequenceKeypoint.new(v.Time, 1, v.Envelope))
    end

    if not fadeIn then
        startTrans, goalTrans = goalTrans, startTrans
    end

    local lerpVal = Instance.new("NumberValue", beam)
    lerpVal.Value = 0

    local beamTween = TS:Create(lerpVal, tweenInfo, {Value = 1})
    beamTween:Play()

    local tweenChanged = lerpVal.Changed:Connect(function(value)
        local keypoints = {}
        for i, keypoint in ipairs(goalTrans) do
            local a = startTrans[i].Value
            local newTrans = a + (keypoint.Value - a) * value
            table.insert(keypoints, NumberSequenceKeypoint.new(keypoint.Time, newTrans))
        end
        beam.Transparency = NumberSequence.new(keypoints)
    end)

    beamTween.Completed:Connect(function()
        tweenChanged:Disconnect()
        lerpVal:Destroy()
    end)

    return function ()
        -- this cancels the tween
        TS:Create(lerpVal, TweenInfo.new(0), {Value = lerpVal.Value}):Play()
    end
end

return ExtraTweens