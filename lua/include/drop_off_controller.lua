local ent_list,counter = {},0
local function RegisterEnt(ent)
	counter = counter + 1
	ent_list[counter] = ent
end
local function RndEnt(t)
	local x = table.Random(t)
	return t[x],x
end
local function ActiveEnts()
	for k,v in pairs(ent_list) do
		if v:Active() then
			return true
		end
	end
end
local function ReturnActiveEnt()
	-- This is assuming that ActiveEnts() returned true,
	local t = {}
	for k,v in pairs(ent_list) do
		if v:Active() then
			t[#t+1] = v
		end
	end
	return RndEnt(v)
end
local q,id = {},0
local function AddQ(ply)
	id = id + 1
	q[id] = ply
	return id
end
local function RemoveQ(ply)
	table.RemoveByValue(q,ply)
end
local function GetLowestID()
	local t = math.huge
	for k,v in pairs(q) do
		if k < t then
			t = k
		end
	end
	if !(t == math.huge) then return t end
end
--[[
ENT:ActivateOutput(class,t)
ENT:ActivateInput(class,t,in_func)
ENT:SpawnEntity(class)
ENT:VisibleSet(bool)

PLY:GetGang() / S_D.Gang.ReturnGang(ply)

WAYPOINT
TIMER
]]
local function OrderNormalSupply(ply,quantity)
	if !ActiveEnts() then return false end
	local ent = ReturnActiveEnt()
	local t = S_D.Gang.ReturnGang(ply) or {ply}

	--timer.Create(string.format("ENT%s Timer",table.KeyFromValue(ent_list,ent)),)
end
local function OrderPremiumSupply(ply,quantity)
	if !S_D.Premium.GetPremiumExpireDate(ply) then return end
	if !ActiveEnts() then return false end
	local ent = ReturnActiveEnt()
	local t = S_D.Gang.ReturnGang(ply) or {ply}
end
local function OrderNormalProduct(ply)
	if !ActiveEnts() then return false end
	local ent = ReturnActiveEnt()
	local t = S_D.Gang.ReturnGang(ply) or {ply}
end
local function OrderPremiumProduct(ply)
	if !S_D.Premium.GetPremiumExpireDate(ply) then return end
	if !ActiveEnts() then return false end
	local ent = ReturnActiveEnt()
	local t = S_D.Gang.ReturnGang(ply) or {ply}
end
local function WAYPOINT(t,position) for k,v in pairs(t) do netSend(v,0,position) end end
local function TIMER(t,seconds) for k,v in pairs(t) do netSend(v,1,seconds) end end
local function netSend(ply,enum,var)
	net.Start(S_D.NetworkString.Format(S_D.NetworkString["util"]))
	net.WriteInt(enum,2)
	if enum == 0 then
		net.WriteVector(var)
	elseif enum == 1 then
		net.WriteInt(var,12)
	end
	net.Send(ply)
end
net.Receive(S_D.NetworkString.Format(S_D.NetworkString["util"]),function()
	
end)

-- Placeholder shit!!!

local function fileWriteVector(path,vector)
	local file = file.Open(path,"wb","DATA")
	file:Seek(0)
	for k,v in pairs(vector) do
		file:WriteFloat(v.x)
		file:WriteFloat(v.y)
		file:WriteFloat(v.z)
	end
	file:Flush()
end
local function fileReadVector(path)
	local file = file.Open(path,"rb","DATA")
	local vectors,counter = {},0
	file:Seek(0)
	for x=1,(file:Size()/4)/3 do
		counter = counter + 1
		local x = file:ReadFloat()
		local y = file:ReadFloat()
		local z = file:ReadFloat()
		vectors[counter] = Vector(x,y,z)
	end
	return vectors
end

local function SavePoss()
	local placeholders,positions,counter = ents.FindByClass("ent_placedrop"),{},0
	for k,v in pairs(placeholders) do
		counter = counter + 1
		positions[counter] = v:GetPos()
	end
	fileWriteVector("Supply&Demand/poss.dat",positions)
end
local function RemovePoss()
	file.Delete("Supply&Demand/poss.dat")
end
-- Uncomment these commands if you do not have ULX:
--concommand.Add("SD_SaveDropOffPositions",SavePoss,,,FCVAR_LUA_SERVER) 
--concommand.Add("SD_RemoveDropOffPositions",RemovePoss,,,FCVAR_LUA_SERVER)

hook.Add("InitPostEntity","DropOffPositions",function()
	if !file.Exists("Supply&Demand","DATA") then
		file.CreateDir("Supply&Demand")
	end
	if file.Exists("Supply&Demand/poss.dat","DATA") then
		local poss = fileReadVector("Supply&Demand/poss.dat")
		for k,v in pairs(poss) do
			local ent = ents.Create("ent_dropoff")
			ent:SetPos(v)
			ent:Spawn()
		end
	end
end)

local L_table = {
	["Waypoint"] = function(ply,pos) netSend(ply,0,pos) end, -- S_D.DropOff.Waypoint(ply,pos)
	["Timer"] = function(ply,seconds) netSend(ply,1,seconds) end, -- S_D.DropOff.Timer(ply,seconds)
	["RegisterEntity"] = RegisterEnt, -- S_D.DropOff.RegisterEntity(ent)
	["RandomEntity"] = function() return RndEnt(ent_list) end, -- S_D.DropOff.RandomEntity()
	["SavePositions"] = SavePoss, -- S_D.DropOff.SavePositions()
	["RemovePositions"] = RemovePoss, -- S_D.DropOff.RemovePositions()
	["Queue"] = {
		["Add"] = AddQ,
		["Remove"] = RemoveQ,
		["GetNext"] = function() return q[GetLowestID()] end
	}
}
S_D.DropOff = {}
for name,func in pairs(L_table) do
	S_D.DropOff[name] = func
end