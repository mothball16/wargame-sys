--#region required
local dirClient = require(script.Parent.Parent.Parent.Directory)
local dir = dirClient.Main
local types = dirClient.Types

local OptionLocator = require(dir.Utility.OptionLocator).new(dirClient.Options)
local TurretClientBase = require(script.Parent.TurretClientBase)
local TurretPlayerControls = require(script.Parent.TurretPlayerControls)
local RuS = game:GetService("RunService")
--#endregion required
--[[
initializes the turret systems in order & passes local dependencies down the line
]]

local TurretPlayerRoot = {}
TurretPlayerRoot.__index = TurretPlayerRoot




function TurretPlayerRoot:Destroy()
    self.maid:DoCleaning()
end

function TurretPlayerRoot.new(args, required)
    -- 1: setup base components
    OptionLocator:Select(args.OptionLocator)

    local self = setmetatable({
        turretBase = TurretClientBase.new(args, required),
        joystick = (OptionLocator:Get("Joystick") :: types.Joystick).new(args.Joystick),
        UILoad = {},
        maid = dir.Maid.new()
    }, TurretPlayerRoot)

    -- 2: wrap player controls around base and provide init. args
    self.playerControls = TurretPlayerControls.new({
        controller = self.turretBase,
        joystick = self.joystick,
    }, required)

    local combinedSignals = table.clone(self.turretBase.localSignals)
    combinedSignals.RequestProjectileSwap = self.playerControls.localSignals.RequestProjectileSwap

    -- 3: set up UI handler with signals from base & joystick from player controls
    self.uiHandler = OptionLocator:Get("UIHandler").new({
        signals = combinedSignals,
        joystickComponent = self.playerControls.joystick,

        initial = {
            rack = self.turretBase:GetRackedProjectiles(),
            salvo = self.turretBase:GetSalvo(),
            interval = self.turretBase:GetInterval(),
            selected = self.turretBase.state.selectedProjectile,
        },

        static = {
            title = self.turretBase.config.turretName,
        }
    }, required)

    -- flow of information:
    -- Input (playerControls) -> Logic (turretBase) -> UI (uiHandler)

    self.maid:GiveTasks(
        self.turretBase,
        self.playerControls,
        self.uiHandler
    )

    self.maid:GiveTask(RuS.RenderStepped:Connect(function(dt)
        self:Step(dt)
    end))
    return self
end

function TurretPlayerRoot:UpdateUI(dt)
    local stickPos, stickRaw = self.joystick:GetInput()
    self.UILoad.stickPos = stickPos
    self.UILoad.stickRaw = stickRaw
    self.UILoad.stickTime = self.playerControls.timeHoldingJoystick
    self.UILoad.tickMult = self.playerControls.rotationMult
    self.UILoad.lockedAxes = {
        x = self.playerControls.joystick.lockedX,
        y = self.playerControls.joystick.lockedY}
    self.UILoad.rot = self.turretBase.TwoAxisRotator:GetRot()
    self.UILoad.orient = self.turretBase.OrientationReader:GetDirection()
    self.UILoad.pos = self.turretBase.OrientationReader:GetPos()
    self.UILoad.crosshair = self.turretBase.OrientationReader:GetForwardPos(2000)
    self.UILoad.inCamera = self.turretBase.ForwardCamera
        and self.playerControls.controller.ForwardCamera.enabled or false
    self.UILoad.selectedProjectileType = self.turretBase.selectedProjectileType
    self.UILoad.rackedProjectiles = self.turretBase:GetRackedProjectiles()

    self.uiHandler:Update(dt, self.UILoad)
end

function TurretPlayerRoot:Step(dt)
    self.turretBase:Update(dt)
    self.playerControls:Update(dt)
    self:UpdateUI(dt)
end

return TurretPlayerRoot