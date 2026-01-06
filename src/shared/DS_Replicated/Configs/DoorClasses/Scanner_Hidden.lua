local dir = require(game.ReplicatedStorage.Shared.DS_Replicated.Directory)
local Door = require(dir.Configs.DoorConfig)

local ScannerHidden: Door.DoorConfig = {
    Scanner = {
        Template = "HiddenScanner",
        OnUseStrategy = "ScannerHiddenExecute"
    },
}
return ScannerHidden