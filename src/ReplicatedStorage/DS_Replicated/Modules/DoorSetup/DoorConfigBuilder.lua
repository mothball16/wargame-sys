local dir = require(game.ReplicatedStorage.Shared.DS_Replicated.Directory)
local classes = {}
local sequences = {}
--[[
this is a tiny snippet that builds a door config given a combination of classes and a sequence with arguments
]]
local DoorConfigBuilder = {}
local loaded = false

function DoorConfigBuilder.Load()
    for _, v in pairs(dir.Configs.DoorClasses:GetChildren()) do
        classes[v.Name] = require(v)
    end

    for _, v in pairs(dir.Configs.DoorSequences:GetChildren()) do
        sequences[v.Name] = require(v)
    end
    loaded = true
end

function DoorConfigBuilder.Build(setup)
    if not loaded then
        DoorConfigBuilder.Load()
    end

    local config = {}
    for _, v in pairs(setup.Classes) do
        local class = classes[v]
        if not class then
            warn(string.format("class %s doesn't exist, skipping", v))
            continue
        end
        config = dir.Helpers:TableOverwrite(config, classes[v])
    end


    local sequence = sequences[setup.Sequence.Type]
    if not sequence then
        error(string.format("sequence %s doesn't exist. doors need a valid sequence to animate", setup.Sequence.Type))
    end
    config = dir.Helpers:TableOverwrite(config, sequence(table.unpack(setup.Sequence.Args)))
    return {Build = config, Raw = setup}
end

return DoorConfigBuilder