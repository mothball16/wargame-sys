-- GENERATED SCRIPT DO NOT TOUCH THIS!!!! RUN DOORCONFIGTYPECOMPILER SNIPPET IN CMD LINE
-- (this will auto-upd DoorConfig. You cant see the change unless you close and re-open doorconfig if working in studio *)
local DoorConfig = {}

export type TweenKey = {[string]: TweenSequence}
export type TweenSequence = {[number]: TweenStep}

export type TweenStep = {
	to: string,
	info: { number | Enum.EasingStyle | Enum.EasingDirection },
	sound: { string }?
}

export type DoorConfig = {
	DoorRoot: {
        DisableCollisionOnOpen: boolean,
        CloseType: "AutoClose" | "ForcedAutoClose" | "ManualClose",
        AutoCloseSeconds: number,
    },
    AuthChecks: {any}, --TODO: gen authcheck conf.
	Scanner: {
        OnUseStrategy: "ScannerPortalExecute" | "ScannerHiddenExecute",
        OnMountStrategy: "ScannerManualMount" | "ScannerAutoMount",
        ScanVisual: string,
        Template: string,
        DisplayPrompt: boolean,
        UseThrottle: number
    },
	PartMover: {
        Use: string,
        Instructions: {[string]: {[string]: TweenKey}}
    }
}

return DoorConfig
