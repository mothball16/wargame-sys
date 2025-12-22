-- this is only to be run thru the command line !! : o
local serverModules = game.ServerScriptService.Server.DS_Server.Modules
local repl = game.ReplicatedStorage.Shared.DS_Replicated
local MountStrategies = serverModules.Components.ScannerMountStrategy
local ExecStrategies = serverModules.Components.ScannerExecuteStrategy
local DoorRoot = require(serverModules.Core.DoorRoot)
local target = repl.Configs.DoorConfig
local function MakeStringFromInstNames(tbl)
    local names = {}
    for _, v in pairs(tbl) do
        table.insert(names, '"' .. v.Name .. '"')
    end
    return table.concat(names, " | ")
end

local function MakeStringFromTbl(tbl)
    local names = {}
    for _, v in pairs(tbl) do
        table.insert(names, '"' .. v .. '"')
    end
    return table.concat(names, " | ")
end

local function CompileDoorConfig()
    local template = [[
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
        CloseType: %s,
        AutoCloseSeconds: number,
    },
    AuthChecks: {any}, --TODO: gen authcheck conf.
	Scanner: {
        OnUseStrategy: %s,
        OnMountStrategy: %s,
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
]]

    local execStrategies = MakeStringFromInstNames(ExecStrategies:GetChildren())
    local mountStrategies = MakeStringFromInstNames(MountStrategies:GetChildren())
    local doorCloseTypes = MakeStringFromTbl(DoorRoot.CloseType)
    
    local final = string.format(template, doorCloseTypes, execStrategies, mountStrategies)
    return final
end

target.Source = CompileDoorConfig()
warn("DoorConfig compiled successfully")