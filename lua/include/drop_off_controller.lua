--[[
???
]]--
local ent_list,counter = {},1
local function RegisterEnt(ent)
	ent_list[counter] = ent
	counter = counter + 1
end
local function RndEnt(t)
	return t[table.Random(t)]
end
local function ActiveEnts()
	for k,v in pairs(ent_list) do
		if v:Active() then
			return true
		end
	end
end
local q,id = {},0
local function AddQ(ply)
	q[id] = ply
	id = id + 1
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
local function OrderSupply(ent,ply,quantity)
	
end
local WAYPOINT,TIMER = 0,1
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

// Placeholder shit!!!

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
	local placeholders = ents.FindByClass("ent_placedrop")
	local positions,counter = {},0
	for k,v in pairs(placeholders) do
		counter = counter + 1
		positions[counter] = v:GetPos()
	end
	fileWriteVector("Supply&Demand/poss.dat",positions)
end
local function RemovePoss()
	file.Delete("Supply&Demand/poss.dat")
end
concommand.Add("SD_SaveDropOffPositions",SavePoss)
concommand.Add("SD_RemoveDropOffPositions",RemovePoss)

hook.Add("Initialize","DropOffPositions",function()
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
	["RandomEntity"] = function() return RndEnt(ent_list) end -- S_D.DropOff.RandomEntity()
}
S_D.DropOff = {}
for name,func in pairs(L_table) do
	S_D.DropOff[name] = func
end