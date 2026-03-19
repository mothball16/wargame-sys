local HttpService = game:GetService("HttpService")
local dir = require(game.ReplicatedStorage.m_Shared.Artillery.Directory)
local rayParams = RaycastParams.new()
local ProjectileRegistry = require(dir.Modules.Projectile.ProjectileRegistry)
local RequestProjectileCreate = dir.Net:RemoteEvent(dir.Events.Reliable.RequestProjectileCreate)
local RequestProjectileHit = dir.Net:RemoteEvent(dir.Events.Reliable.RequestProjectileHit)
local RequestProjectileDestroy = dir.Net:RemoteEvent(dir.Events.Reliable.RequestProjectileDestroy)
local RequestProjectileUpdate = dir.Net:UnreliableRemoteEvent(dir.Events.Unreliable.RequestProjectileUpdate)
local ProjectileController = {}

ProjectileController._activeProjectiles = {}

--TODO: this script is lagging a bit behind the current architecture.
-- replace event registration with netutils call
-- switch to colon syntax

function ProjectileController:Init()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.IgnoreWater = false
end
---creates a client model of the projectile and sends a request to the server to replicate
---@param firePart BasePart the origin of the projectile spawn
---@param ammoName string the name corresponding to the projectile type registered in ProjectileRegistry
---@param filterInstances table the instances to ignore when casting rays
---@param args any further arguments relevant to OnFire methods
function ProjectileController.Fire(firePart, ammoName, filterInstances, args)
    --------------------------------------------------------------------
    local data = ProjectileRegistry:GetProjectile(ammoName)
    local onFire = assert(data.Config["OnFire"], "OnFire prop. of config of projectile " .. ammoName)
    args = args or {}
    --------------------------------------------------------------------

    -- find our projectile and make the physical copy
    local projectile = data.Model:Clone()
    projectile.Parent = game.Workspace
    projectile:SetPrimaryPartCFrame(firePart.CFrame * CFrame.new(0,0,-(data.Config.offset or 0)))

    -- setup replication data, send to server
    local id = HttpService:GenerateGUID()
    projectile:SetAttribute(dir.Consts.REPL_ID, id)

    -- [!] this is solely for a client-side copy for client-side effects
    -- the server will never use this for obv. reasons
    projectile:SetAttribute(dir.Consts.AMMO_TYPE, ammoName)

    ProjectileController._activeProjectiles[id] = {
        Model = projectile,
        AmmoType = ammoName
    }

    -- this is a safeguard for when the projectile is destroyed externally
    projectile.Destroying:Connect(function()
        if ProjectileController._activeProjectiles[id] then
            ProjectileController.Destroy(id)
        end
    end)

    rayParams.FilterDescendantsInstances = filterInstances
    dir.Helpers:TableCombine(args, {
        ["object"] = projectile,
        ["rayParams"] = rayParams,
        ["id"] = id,
    })

    RequestProjectileCreate:FireServer(id, {
        ["cf"] = projectile.PrimaryPart.CFrame,
        ["handler"] = "ReplicateOrientation",
        ["projectile"] = ammoName
    })

    dir.NetUtils:ExecuteOnClient(onFire,args)
    return id
end

function ProjectileController.Replicate(id)
    local data = ProjectileController._activeProjectiles[id]

    if not data or not data.Model or not data.Model.PrimaryPart then
        return
    end

    RequestProjectileUpdate:FireServer(id, {
        ["cf"] = data.Model.PrimaryPart.CFrame
    })
end

-- calls the hit behavior of the object
function ProjectileController.Hit(id, args)
    local data = ProjectileController._activeProjectiles[id]

    if not data then warn("no data on projectile, not hitting") return end
    local onHit = assert(ProjectileRegistry:GetProjectile(data.AmmoType).Config.OnHit)

    args = args or {}
    local object = data.Model
    local pos = args.pos or (object and object.PrimaryPart and object.PrimaryPart.Position)
    local cf = args.cf or (object and object.PrimaryPart and object.PrimaryPart.CFrame)

    dir.Helpers:TableCombine(args, {
        ["object"] = object,
        ["pos"] = pos,
        ["cf"] = cf
    })

    dir.NetUtils:ExecuteOnClient(onHit, args)
    RequestProjectileHit:FireServer(id, args)
end

function ProjectileController.Destroy(id)
    local data = ProjectileController._activeProjectiles[id]
    if not data then return end

    ProjectileController._activeProjectiles[id] = nil

    local object = data.Model

    if object then
        -- prevent new updates and tell the server to drop the id
        object:SetAttribute(dir.Consts.REPL_ID, nil)
        object:Destroy()
    end
    RequestProjectileDestroy:FireServer(id)
end

return ProjectileController