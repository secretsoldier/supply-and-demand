include("shared.lua")
/// TO BE FIXED
//
//
local length = 60
function ENT:Draw()
	self:DrawModel()
	self:SetNWVars()
	
	local ang = self:GetAngles()
	cam.Start3D2D(self:GetPos()+Vector(0,15,50),Angle(0,180,55) + ang,0.3)
		draw.DrawText("Test","CloseCaption_Bold",0,0,Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

local oldval = false
function ENT:Think()
	if !(self:GetDTBool(0) == oldval) then
		oldval = self:GetDTBool(0)
		self:LoopSound(oldval)
	end
end
local sound1,sound2,id_1,id_2 = "sound/phx/epicmetal_hard7.wav","sound/phx/hmetal1.wav"
function ENT:LoopSound(bool)
	if bool and (id_1 or id_2) then return end
	if bool then
		id_1 = self:StartLoopingSound(sound1)
		//id_2 = self:StartLoopingSound(sound2)
		print(id_1,id_2)
	else
		self:StopLoopingSound(id_1)
		//self:StopLoopingSound(id_2)
		id_1 = nil
		//id_2 = nil
		print(id_1,id_2)
	end
end