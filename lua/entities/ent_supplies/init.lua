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