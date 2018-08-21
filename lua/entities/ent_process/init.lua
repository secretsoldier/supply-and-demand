AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
//Process
local model = "models/props_wasteland/laundry_washer003.mdl" -- Placeholder

function ENT:Initialize()
	self:SetModel(model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetNWVars()
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

local length = 60
function ENT:ActiveSwitch(bool)
	self:SetDTBool(0,bool)
	return self:GetDTBool(0)
end
function ENT:MachineActive()
	return self:GetDTBool(0)
end
function ENT:Touch(entity)
	if entity:GetClass() == "ent_supplies" and !self:MachineActive() then
		self:SetDTBool(0,true)
		entity:Remove()
		timer.Create("SpawnProduct",length,1,function()
			self:SpawnEntity("ent_product")
			self:SetDTBool(0,false)
		end)
	end
end
function ENT:SpawnEntity(class)
	local pos,angle = self:GetPos(),self:GetAngles()
	pos = pos + 100 * angle:Forward()
	local product = ents.Create(class)
	if !IsValid(product) then error(string.format("%s failed to create.",class)) return end
	product:SetPos(pos)
	product:Spawn()
end
local owner
function ENT:GetOwner()
	return owner
end
function ENT:SetOwner(ply)
	if owner then return end
	owner = ply
end