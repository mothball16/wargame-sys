-- GENERATED SCRIPT DO NOT TOUCH THIS!!!! RUN DOORCONFIGTYPECOMPILER SNIPPET IN CMD LINE
-- (this will auto-upd DoorConfig. You cant see the change unless you close and re-open doorconfig if working in studio *)
local dir = require(game.ReplicatedStorage.Shared.DS_Replicated.Directory)
local builder = require(dir.Modules.DoorSetup.DoorConfigBuilder)

local DoorData = {}

export type TweenKey = {[string]: TweenSequence}
export type TweenSequence = {[number]: TweenStep}

export type TweenStep = {
	to: string,
	info: { number | Enum.EasingStyle | Enum.EasingDirection },
	sound: { string }?
}

export type DoorConfig = {
	DoorRoot: {
        DoorClipsDuringAnim: boolean,
        CloseType: "AutoClose" | "ForcedAutoClose" | "ManualClose",
        AutoCloseSeconds: number,
    },
    AuthChecks: {any}, --TODO: gen authcheck conf.
	Scanner: {
        Template: "HiddenScanner" | "DefaultScanner" | "RFIDScanner",
        OnUseStrategy: "ScannerPortalExecute" | "ScannerHiddenExecute",
        OnMountStrategy: "ScannerManualMount" | "ScannerAutoMount",
        ScanVisual: string,
        DisplayPrompt: boolean,
        UseThrottle: number
    },
	PartMover: {
        Use: string,
        Instructions: {[string]: {[string]: TweenKey}}
    }
}

export type DoorSetup = {
    Classes: {"Auth_LevelFive" | "Auth_LevelOne" | "CloseType_Auto" | "CloseType_ForcedAuto" | "CloseType_Manual" | "OpenType_Auto" | "OpenType_Manual" | "Scanner_Default" | "Scanner_Hidden" | "Scanner_RFID" | "Behavior_DoorClipsDuringAnim" | "Behavior_StrictLockdownControl"},
    Sequence: {
        Type: "SingleDirectionalDoor" | "DoubleDoor" | "SingleDoor",
        Args: {any}
    }
}

DoorData.Build = builder.Build

return DoorData
