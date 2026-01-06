-- animation loader from Ilucere
local animationPlayer = {}
animationPlayer.__index = animationPlayer
local RunService = game:GetService('RunService')
local hum = Instance.new('Humanoid')
hum.Parent = workspace
local preloader = Instance.new('Animator')
preloader.Parent = hum

local animObjects = {}
local function getAnimationObject(id)
	if (not animObjects[id]) then
		animObjects[id] = Instance.new('Animation')
		animObjects[id].AnimationId = `rbxassetid://{id}`
	end
	return animObjects[id]
end

function animationPlayer.new(animator)
	return setmetatable({
        animator = animator,
        animations = {},
        animationObjects = {}
    }, animationPlayer)
end

function animationPlayer.Preload(anims:{number})
	for _, v in ipairs(anims) do
		local obj = getAnimationObject(v)
		preloader:LoadAnimation(obj)
	end
end

function animationPlayer:WaitForAnimationLoad(name)
	if (not self.animations[name]) then
		error('no anim found')
	end
	
	while (self.animations[name].Length <= 0) do
		RunService.Heartbeat:Wait()
	end
end

function animationPlayer:LoadAnimation(name, data: {id:number, looped:boolean, priority:EnumItem}, poll)
	if (not self.animations[name]) then
		local animObj = getAnimationObject(data.id)
		local anim = self.animator:LoadAnimation(animObj)
		anim.Looped = data.looped
		anim.Priority = data.priority
		self.animations[name] = anim
		if (poll) then
			self:WaitForAnimationLoad(name)
		end
	end

	return self.animations[name]
end

function animationPlayer:GetAnimation(name)
	return self.animations[name]
end

function animationPlayer:Destroy()
	table.clear(self)
	setmetatable(self, nil)
end

return animationPlayer