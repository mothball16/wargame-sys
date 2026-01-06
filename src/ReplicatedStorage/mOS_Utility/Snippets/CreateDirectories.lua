--#region ignore
local mOSConsts = require(game.ReplicatedStorage.Shared.mOS_Replicated.Configs.Constants)
--#endregion



--               ((((DEPRECATED))))
local directoryName = "m<name-here>S"


local function initFolder(suffix, parent)
    local folder = Instance.new("Folder", parent)
    folder.Name = directoryName .. "_" .. suffix
    folder:AddTag(mOSConsts.FOLDER_IDENT_TAG_NAME)

    local minDirectory = string.format([[
local share =           game.ReplicatedStorage.Shared
local repl =            %s

local root =            script.Parent
local mOS =             root.Parent.mOS_Client


return {
    Main =              require(repl.Directory),
    mOS =               mOS,
    Repl =              repl,
    Root =              root,
}]], directoryName .. "_" .. suffix)
    local directory = Instance.new("ModuleScript", folder)
    directory.Name = "Directory"
    directory.Source = minDirectory
end

local clientFolder = initFolder("Client", game.StarterPlayer.StarterPlayerScripts.Client)
local replFolder = initFolder("Replicated", game.ReplicatedStorage.Shared)
local serverFolder = initFolder("Server", game.ServerScriptService.Server)

print("worked")