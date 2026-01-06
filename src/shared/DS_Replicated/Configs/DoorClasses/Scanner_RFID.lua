local dir = require(game.ReplicatedStorage.Shared.DS_Replicated.Directory)
local Door = require(dir.Configs.DoorConfig)

local ScannerDefault: Door.DoorConfig = {
    Scanner = {
        Template = "RFIDScanner",
        OnUseStrategy = "ScannerPortalExecute"
    },
}
return ScannerDefault