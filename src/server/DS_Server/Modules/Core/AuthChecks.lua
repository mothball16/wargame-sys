local CS = game:GetService("CollectionService")
local AuthChecks = {}

--[[
a series of functions for checking door auths
99% of the time you should only be interactig with AuthChecks:Check()
]]

function AuthChecks:ReturnFalse()
    return false
end

function AuthChecks:NotLockdownOrAuth(plr)
    -- put your thing here
    -- UPD: this should be handled externally using an extension to AuthChecks
    warn("not implemented")
    return true
end

function AuthChecks:IsOfGroup(plr, groupId)
    return AuthChecks:IsOfGroupRank(plr, groupId, 1)
end

function AuthChecks:IsOfGroupRank(plr, groupId, minRank)
    return plr:GetRankInGroup(groupId) >= minRank
end

function AuthChecks:IsInTeam(plr: Player, teams: {Team})
    for _, team in ipairs(teams) do
        if plr.Team == team then
            return true
        end
    end
    return false
end

function AuthChecks:HasToolWithTag(plr: Player, tag)
    for _, v in ipairs(plr.Backpack:GetChildren()) do
        if CS:HasTag(v,tag) then return true end
    end
    if plr.Character then
        for _, v in ipairs(plr.Character:GetChildren()) do
            if CS:HasTag(v,tag) then return true end
        end
    end
    return false
end

function AuthChecks:HoldingToolWithTag(plr: Player, tag)
    if plr.Character then
        for _, v in ipairs(plr.Character:GetChildren()) do
            if CS:HasTag(v,tag) then return true end
        end
    end
    return false
end


--[[
wraps around a series of checks
TODO: merge this with Check
]]
function AuthChecks:OR(plr, ...)
    for _, check in ipairs({...}) do
        local funcName = check[1]
        local args = check[2] or {}

        local func = self[funcName]
        if not func then
            error("unknown authcheck: " .. funcName)
        end
        if func(self, plr, table.unpack(args)) then
            return true
        end
    end
    return false
end
--[[
interprets the table equivalent of calling these functions
```
local auth = AuthChecks:Check(plr,
{"OR",
    {"HasToolWithTag",{"level1"}},
    {"IsOfGroup", {16057783}},
},
{"NotLockdownOrAuth"}) -- this passes an empty {} as the args if not filled
```
]]
function AuthChecks:Check(plr, checks)
    for _, check in ipairs(checks or {}) do
        local funcName = check[1]
        local args = check[2] or {}

        local func = self[funcName]
        if func then
            if not func(self, plr, table.unpack(args)) then return false end
        else
            error("unknown authcheck: " .. args)
        end
    end
    return true
end

return AuthChecks