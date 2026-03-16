local Helpers = {}

-- TODO: look into this. some weird pointer siht goes on with this deep merge stuff
function Helpers:TableCombine(tbl1, ...)
    for _, t in ipairs({...}) do
        for k, v in pairs(t) do
            if type(v) == "table" and type(tbl1[k]) == "table" then
                self:TableCombine(tbl1[k], v)
            else
                tbl1[k] = v
            end
        end
    end
end

function Helpers:TableCombineNew(...)
    local tbl = {}
    for _, t in ipairs({...}) do
        for k, v in pairs(t) do
            if type(v) == "table" and type(tbl[k]) == "table" then
                tbl[k] = self:TableCombineNew(tbl[k], v)
            else
                tbl[k] = v
            end
        end
    end
    return tbl
end

function Helpers:TableOverwrite(orig, overwrite)
    local tbl = {}
    for k, v in pairs(orig) do
        if type(v) == "table" then
            tbl[k] = Helpers:TableOverwrite(v, {})
        else
            tbl[k] = v
        end
    end
    for k, v in pairs(overwrite) do
        if type(v) == "table" and type(tbl[k]) == "table" then
            tbl[k] = Helpers:TableOverwrite(tbl[k], v)
        else
            tbl[k] = v
        end
    end

    return tbl
end

function Helpers:Weld(p1: BasePart, p2: BasePart): WeldConstraint
	local weld = Instance.new("WeldConstraint")
	weld.Name = p1.Name .. "Weld"
	weld.Part0 = p1
	weld.Part1 = p2
	weld.Parent = p1
	return weld
end

function Helpers:ToConfigTable(folder)
    assert(folder:IsA("Folder"), "foldeer attempted to be converted into config, but wasn't a folder... idiot....")
    local cfg = {}
    for _, v in pairs(folder:GetChildren()) do
        cfg[v.Name] = v.Value
    end
    return cfg
end

function Helpers:Switch(value)
    return function(cases)
        return (cases[value] or cases.default)(value)
    end
end

function Helpers:GenInaccuracy(value)
    value *= 100000
    local inaccX = math.random(-value, value) / 100000
    local inaccY = math.random(-value, value) / 100000
    local inaccZ = math.random(-value, value) / 100000
    return CFrame.Angles(math.rad(inaccX), math.rad(inaccY), math.rad(inaccZ))
end

function Helpers:GetDictSize(t)
    local n = 0
    for _ in pairs(t) do
        n = n + 1
    end
    return n
end
return Helpers