local prefabs = game.ReplicatedStorage.Shared.DS_Replicated.Configs.Prefabs
return function()
    for _, v: ModuleScript in pairs(prefabs:GetChildren()) do
        pcall(function()
            if v:IsA("ModuleScript") then
                local config = require(v)
                -- set default partmover instructions if not already set
                local instructions = config.PartMover.Instructions
                if not instructions["Default"] then
                    -- for common names that would equate to default
                    instructions["Default"] = instructions["Open"] or instructions["Front"]
                    -- for idiot config
                    if not instructions["Default"] then
                        warn("door should have a default PartMover instruction for script interactions, using a random key (BAD)")
                        warn(v.Name)
                        instructions["Default"] = next(instructions)
                    end
                end
                -- ensure scripts have an interactable animKey
                instructions["Scriptable"] = instructions["Scriptable"] or instructions["Default"]
            end
        end)
    end
end