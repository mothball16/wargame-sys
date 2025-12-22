--#region required
local dirClient = require(script.Parent.Parent.Parent.Directory)
local dir = dirClient.Main
local validator = dir.Validator.new(script.Name)
local PromptStates = require(dirClient.Root.Configs.PromptStates)
local ExtraTweens = require(dir.Utility.ExtraTweens)
local Parallax = require(dir.Utility.Parallax)
--#endregion required

local FADE_IN_TIME = 1
local FADE_OUT_TIME = 0.6
local TRACK_PART = "UpperTorso"
local TS = game:GetService("TweenService")
local plr = game.Players.LocalPlayer
--[[
prompt visual component appearance
hardcoded to use only 1 asset type for now (i lazy)

Mfw the biggest file in my codebase is a prompt display
]]

local ScanVisual = {}
ScanVisual.__index = ScanVisual
ScanVisual.BeamInteractionType = {
    StayForward = "StayForward",
    LockToTrackPart = "LockToTrackPart"
}


local fallbacks = {
    initCF = CFrame.new(),
    initState = "Default",
    lerpFactor = 5,
    offset = 0.5,
    beamInteractionType = ScanVisual.BeamInteractionType.LockToTrackPart,
    rotateTowardsCam = false
}

local function _checkSetup(required)
    local backgroundFolder = validator:IsOfClass(required:FindFirstChild("Background"), "Folder")
    local background = {}
    for _, v in pairs(backgroundFolder:GetChildren()) do
        background[v.Name] = v.Value
    end
    local beam = validator:ValueIsOfClass(required:FindFirstChild("Beam"), "Beam")
    local beamAttach = validator:ValueIsOfClass(required:FindFirstChild("BeamAttach"), "Attachment")
    local canvas = validator:ValueIsOfClass(required:FindFirstChild("Canvas"), "CanvasGroup")
    local buttonText = validator:ValueIsOfClass(required:FindFirstChild("ButtonText"), "TextLabel")
    local actionText = validator:ValueIsOfClass(required:FindFirstChild("ActionText"), "TextLabel")
    local progressBar = validator:ValueIsOfClass(required:FindFirstChild("ProgressBar"), "Frame")
    local parallaxBase = validator:ValueIsOfClass(required:FindFirstChild("ParallaxBase"), "BasePart")
    return background, beam, beamAttach, canvas, buttonText, actionText, progressBar, parallaxBase
end

local function _fadeIn(fadeTime: number, canvas: CanvasGroup, beam: Beam)
    local tweenInfo = TweenInfo.new(fadeTime, Enum.EasingStyle.Cubic)
    local cancelBeamTween = ExtraTweens:FadeBeam(tweenInfo, beam, true)

    -- tween the ui canvasgroup so they all fade in
    -- (i just realized canvas groups can do this that is so cool wtf)
    canvas.GroupTransparency = 1
    TS:Create(canvas, tweenInfo, {GroupTransparency = 0}):Play()

    return cancelBeamTween
end

local function _fadeOut(fadeTime: number, canvas: CanvasGroup, beam: Beam)
    local tweenInfo = TweenInfo.new(fadeTime, Enum.EasingStyle.Cubic)
    ExtraTweens:FadeBeam(tweenInfo, beam, false)
    TS:Create(canvas, tweenInfo, {GroupTransparency = 1}):Play()
end

local function _numLerp(a, b, t)
    return a + (b - a) * t
end

-- I LOVE CODING UI!!!
function ScanVisual.new(args, required)
    local
        background, beam, beamAttach, canvas,
        buttonText, actionText, progressBar, parallaxBase = _checkSetup(required)

    local toTrack = plr.Character and plr.Character:FindFirstChild(TRACK_PART) or nil
    local self = setmetatable({
        background = background,
        beam = beam,
        beamAttach = beamAttach,
        canvas = canvas,
        buttonText = buttonText,
        actionText = actionText,
        progressBar = progressBar,
        parallax = Parallax.new(parallaxBase),

        config = dir.Helpers:TableOverwrite(fallbacks, args),
        toTrack = toTrack,
        model = args.model,
        prompt = args.prompt,

        holdProgress = 0,
        holding = false,

        maid = dir.Maid.new(),
    }, ScanVisual)
    self.maid:GiveTasks(
        self.toTrack.Destroying:Once(function() self:Destroy() end),
        self.model, self.parallax)

    self.cancelFadeIn = _fadeIn(FADE_IN_TIME, canvas, beam)
    self.model:SetPrimaryPartCFrame(self.config.initCF * CFrame.new(0,0,-self.config.offset))

    if self.config.beamInteractionType == ScanVisual.BeamInteractionType.LockToTrackPart then
        self.beamAttach.Parent = self.toTrack
        self.beamAttach.CFrame = CFrame.new()
        self.maid:GiveTask(self.beamAttach)
    end

    self.buttonText.Text = self.prompt.KeyboardKeyCode.Name or "N/A"
    self:SetText(self.prompt:GetAttribute(dir.Consts.DOOR_ROOT_STATE_ATTR))
    self:SetState(self.config.initState)
    return self
end

function ScanVisual:Update(dt)
    if self.config.beamInteractionType == ScanVisual.BeamInteractionType.StayForward then
        local mag = (self.model.PrimaryPart.Position - self.toTrack.Position).Magnitude
        self.beamAttach.CFrame = CFrame.new(0,0, -mag)
    end

    if self.config.rotateTowardsCam then
        local lookAtCamCF = CFrame.lookAt(self.model.PrimaryPart.Position, game.Workspace.CurrentCamera.CFrame.Position)
        local newCF = (self.model.PrimaryPart.CFrame :: CFrame):Lerp(lookAtCamCF, dt * self.config.lerpFactor)
        self.model:SetPrimaryPartCFrame(newCF)
    end


    -- progress bar tween
    self.holdProgress = self.holding and self.holdProgress + dt or 0

    local holdPct = math.clamp(self.holdProgress / self.prompt.HoldDuration, 0, 1)
    self.progressBar.Size = UDim2.fromScale(1, _numLerp(self.progressBar.Size.Y.Scale, holdPct, dt * 10))
    self.parallax:Update()
end

function ScanVisual:SetState(state)
    local stateInfo = PromptStates[state]
    if not stateInfo then
        validator:Warn("promptstate " .. state .. " isn't registered in PromptStates, ignoring change")
        return
    end
    local showPrompt = not stateInfo["HideButton"]

    --[[
    Background = "rbxassetid://129468391154883",
        BackgroundColor = Color3.fromRGB(255, 131, 73),
        BeamColor = ColorSequence.new(Color3.fromRGB(255, 131, 73)),
        ]]
    self.background["Main"].Image = stateInfo.Background
    self.buttonText.Visible = showPrompt
    self.actionText.Visible = showPrompt
    for _, v in pairs(self.background) do
        v.ImageColor3 = stateInfo.BackgroundColor
    end
    self.beam.Color = stateInfo.BeamColor
end

function ScanVisual:SetScale(scale)
    TS:Create(self.canvas, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), {Size = UDim2.fromScale(scale, scale)}):Play()
end

function ScanVisual:SetText(rootState)
    dir.Helpers:Switch (rootState) {
        ["Open"] = function()
            self.actionText.Text = "CLOSE"
        end,
        ["Close"] = function()
            self.actionText.Text = "OPEN"
        end,
        ["Broken"] = function()
            self.actionText.Text = "<BROKEN>"
        end,
        default = function()
            validator:Warn("scanvisual has no function to process root state " .. rootState)
        end
    }
end

function ScanVisual:ConnectEvents()
    self.maid:GiveTasks(
        self.prompt:GetAttributeChangedSignal(dir.Consts.DOOR_SCAN_VISUAL_ATTR):Connect(function()
            self:SetState(self.prompt:GetAttribute(dir.Consts.DOOR_SCAN_VISUAL_ATTR))
        end),
        self.prompt:GetAttributeChangedSignal(dir.Consts.DOOR_ROOT_STATE_ATTR):Connect(function()
            self:SetText(self.prompt:GetAttribute(dir.Consts.DOOR_ROOT_STATE_ATTR))
        end),
        self.prompt.PromptButtonHoldBegan:Connect(function()
            self.holding = true
            self:SetScale(1.25)
        end),
        self.prompt.PromptButtonHoldEnded:Connect(function()
            self.holding = false
            self:SetScale(1)
        end),
        self.prompt.PromptHidden:Once(function()
            self:Destroy()
        end))

    return self
end

function ScanVisual:Destroy()
    self:SetScale(1.5)
    self.cancelFadeIn()
    self.buttonText.Visible = false
    self.actionText.Visible = false
    _fadeOut(FADE_OUT_TIME, self.canvas, self.beam)
    task.delay(FADE_OUT_TIME, function()
        if self.config.OnDestroy then
            self.config.OnDestroy()
        end
        self.maid:DoCleaning()

    end)
end

return ScanVisual