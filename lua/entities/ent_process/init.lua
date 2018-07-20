AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local model = "models/props_phx/construct/plastic/plastic_panel1x1.mdl" -- Placeholder

function ENT:Initialize()
	self:SetModel(model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end
local active,length = false,300
local function ActiveSwitch(bool)
	if bool == nil then
		active = !active
	else
		active = bool
	end
	LoopSound(active)
	hook.Run("S_D_MachineActivated",self,active)
	return active
end
function ENT:MachineActive()
	return active
end
function ENT:Touch(entity)
	if entity:GetClass() == "ent_supplies" and !active then
		ActiveSwitch(false)
		entity:Remove()
		timer.Simple(length,function()
			local pos,angle = self:GetPos(),self:GetAngles()
			pos = pos + 100 * angle:Forward()
			local product = ents.Create("ent_product")
			if !IsValid(product) then error("ent_product failed to create.") return end
			product:SetPos(pos)
			product:Spawn()
			ActiveSwitch(true)
		end)
	end
end
local sound1,sound2,id_1,id_2 = "sound/phx/epicmetal_hard7.wav","sound/phx/hmetal1.wav"
local function LoopSound(bool)
	if bool then
		id_1 = self:StartLoopingSound(sound1)
		id_2 = self:StartLoopingSound(sound2)
	else
		self:StopLoopingSound(id_1)
		self:StopLoopingSound(id_2)
	end
end
local owner
function ENT:GetOwner()
	return owner
end
function ENT:SetOwner(ply)
	if owner then return end
	owner = ply
end