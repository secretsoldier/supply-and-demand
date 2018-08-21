ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.PrintName = "Machine Processor"
ENT.Author = "secret_survivor"
ENT.DisableDuplicator = true
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:SetNWVars()
	self:SetDTBool(0,false)
end