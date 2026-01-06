-- this is only to be run thru the command line !! : o
local serverModules = game.ServerScriptService.Server.DS_Server.Modules
local repl = game.ReplicatedStorage.Shared.DS_Replicated
local ScannerTemplates = repl.Assets.Models.ScannerTemplates
local MountStrategies = serverModules.Components.ScannerMountStrategy
local ExecStrategies = serverModules.Components.ScannerExecuteStrategy
local DoorClasses = repl.Configs.DoorClasses
local DoorSequences = repl.Configs.DoorSequences
local DoorRoot = require(serverModules.Core.DoorRoot)
local target = repl.Configs.DoorConfig
local function MakeStringFromInstNames(tbl)
    local names = {}
    for _, v in pairs(tbl) do
        if string.sub(v.Name, 1, 2) == "__" then continue end

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
        CloseType: %s,
        AutoCloseSeconds: number,
    },
    AuthChecks: {any}, --TODO: gen authcheck conf.
	Scanner: {
        Template: %s,
        OnUseStrategy: %s,
        OnMountStrategy: %s,
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
    Classes: {%s},
    Sequence: {
        Type: %s,
        Args: {any}
    }
}

DoorData.Build = builder

return DoorData
]]
    local doorCloseTypes = MakeStringFromTbl(DoorRoot.CloseType)
    local scannerTemplates = MakeStringFromInstNames(ScannerTemplates:GetChildren())
    local execStrategies = MakeStringFromInstNames(ExecStrategies:GetChildren())
    local mountStrategies = MakeStringFromInstNames(MountStrategies:GetChildren())
    local doorClasses = MakeStringFromInstNames(DoorClasses:GetChildren())
    local doorSequences = MakeStringFromInstNames(DoorSequences:GetChildren())

    local final = string.format(
        template,
        doorCloseTypes,
        scannerTemplates,
        execStrategies,
        mountStrategies,
        doorClasses,
        doorSequences
    )
    return final
end

target.Source = CompileDoorConfig()
warn("DoorConfig compiled successfully")