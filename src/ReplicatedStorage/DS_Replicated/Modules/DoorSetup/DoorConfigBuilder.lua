local dir = require(game.ReplicatedStorage.Shared.DS_Replicated.Directory)

--[[
this is a tiny snippet that builds a door config given a combination of classes and a sequence with arguments
]]

return function(setup)
    local classes = {}
    local sequences = {}

    for _, v in pairs(dir.Configs.DoorClasses:GetChildren()) do
        classes[v.Name] = require(v)
    end

    for _, v in pairs(dir.Configs.DoorSequences:GetChildren()) do
        sequences[v.Name] = require(v)
    end

    local config = {}
    for _, v in pairs(setup.Classes) do
        local class = classes[v]
        if not class then
            warn(string.format("class %s doesn't exist, skipping", v))
            continue
        end
        dir.Helpers:TableCombine(config, classes[v])
    end

    local sequence = sequences[setup.Sequence.Type]
    if not sequence then
        error(string.format("sequence %s doesn't exist. doors need a valid sequence to animate", setup.Sequence.Type))
    end
    dir.Helpers:TableCombine(config, sequence(table.unpack(setup.Sequence.Args)))
    return config
end