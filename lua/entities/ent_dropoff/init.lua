AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local model = "models/Items/ammoCrate_Rockets.mdl"

function ENT:Initialize()
	self:SetModel(model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	S_D.DropOff.RegisterEntity(self)
	self:VisibleSet(false)
	self:SetMoveType(MOVETYPE_NONE)
end
local active,entity,validuse,IO,func = false
function ENT:Active() return active end
function ENT:ActivateOutput(class,t)
	active = true
	entity = class
	validuse = t
	IO = 1
	timer.Simple(S_D.Configs.Supply_Pickup_Length,function() active = false entity = nil validuse = nil end)
end
function ENT:ActivateInput(class,t,in_func)
	active = true
	entity = class
	validuse = t
	func = in_func
	IO = 2
	timer.Simple(S_D.Configs.Product_Pickup_Length,function() active = false entity = nil validuse = nil end)
end
function ENT:DisableEntity()
	active = false
	entity = nil
	validuse = nil
end
local function Valid(t,ply)
	for k,v in pairs(t) do
		print(k,v,ply)
		if ply == v then
			return true
		end
	end
end
function ENT:SpawnEntity(class)
	local pos,angle = self:GetPos(),self:GetAngles()
	pos = pos + 100 * angle:Up()
	local product = ents.Create(class)
	if !IsValid(product) then error(string.format("%s failed to create.",class)) return end
	product:SetPos(pos)
	product:Spawn()
end
function ENT:Use(activator,caller)
	if active and Valid(validuse,caller) and IO == 1 then
		self:SpawnEntity(entity)
		self:VisibleSet(false)
		self:DisableEntity()
	end
end
function ENT:Touch(ent)
	if active and IO == 2 and ent:GetClass() == entity then
		ent:Remove()
		func()
		self:VisibleSet(false)
		self:DisableEntity()
	end
end
function ENT:VisibleSet(bool)
	self:SetNoDraw(!bool)
	self:SetNotSolid(!bool)
end