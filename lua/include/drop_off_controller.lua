local ent_list,counter = {},1
local function RegisterEnt(ent)
	ent_list[counter] = ent
	counter = counter + 1
end
local function RndEnt(t)
	local x = table.Random(t)
	return x
end
local function ActiveEnts()
	for k,v in pairs(ent_list) do
		if !v:Active() then
			return true
		end
	end
end
local function ReturnActiveEnt()
	-- This is assuming that ActiveEnts() returned true,
	local t,counter = {},1
	for k,v in pairs(ent_list) do
		if !v:Active() then
			t[counter] = v
			counter = counter + 1
		end
	end
	return RndEnt(t)
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

WAYPOINT(t,position)
TIMER(t,seconds)

TODO//
Premium
Fix process identifier
Add Process upgrades
]]

local function netSend(ply,enum,var)
	net.Start(S_D.NetworkString.Format(S_D.NetworkString["util"]))
	net.WriteInt(enum,2)
	net.WriteEntity(var)
	net.Send(ply)
end
net.Receive(S_D.NetworkString.Format(S_D.NetworkString["util"]),function()
end)
local function WAYPOINT(t,position) for k,v in pairs(t) do netSend(v,0,position) end end
local function TIMER(t,seconds) for k,v in pairs(t) do netSend(v,1,seconds) end end

local function OrderNormalSupply(ply,quantity)
	if !ActiveEnts() then return false end
	local ent = ReturnActiveEnt()
	local t = S_D.Gang.ReturnGang(ply) or {ply}
	ent:VisibleSet(true)
	WAYPOINT(t,ent)
	//TIMER(t,S_D.Configs.Supply_Pickup_Length)
	ent:ActivateOutput("ent_supplies",t)
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
	ent:VisibleSet(true)
	WAYPOINT(t,ent)
	//TIMER(t,S_D.Configs.Product_Pickup_Length)
	ent:ActivateInput("ent_product",t,function() print("Yay!") RunConsoleCommand("DarkRP","setmoney",S_D.Configs.Product_Sell_Price) end)
end
local function OrderPremiumProduct(ply)
	if !S_D.Premium.GetPremiumExpireDate(ply) then return end
	if !ActiveEnts() then return false end
	local ent = ReturnActiveEnt()
	local t = S_D.Gang.ReturnGang(ply) or {ply}
end

concommand.Add("OrderSupplies",function(ply,cmd,args,argStr)
	OrderNormalSupply(ply,1)
end)
concommand.Add("SellProduct",function(ply,cmd,args,argStr)
	OrderNormalProduct(ply)
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
	local positions,counter = {},1
	for k,v in pairs(ents.FindByClass("ent_placedrop")) do
		print("Saved",k,v)
		positions[counter] = {}
		positions[counter].pos = v:GetPos()
		positions[counter].ang = v:GetAngles()
		counter = counter + 1
	end
	file.Write("Supply&Demand/poss.txt",util.TableToJSON(positions))
end
local function RemovePoss()
	file.Delete("Supply&Demand/poss.txt")
end
-- Uncomment these commands if you do not have ULX:
concommand.Add("SD_SaveDropOffPositions",SavePoss,nil,nil,FCVAR_PROTECTED) 
concommand.Add("SD_RemoveDropOffPositions",RemovePoss,nil,nil,FCVAR_PROTECTED)

hook.Add("InitPostEntity","DropOffPositions",function()
	print("Supply and Demand Init")
	if !file.Exists("Supply&Demand","DATA") then
		file.CreateDir("Supply&Demand")
	end
	if file.Exists("Supply&Demand/poss.txt","DATA") then
		local poss = util.JSONToTable(file.Read("Supply&Demand/poss.txt"))
		PrintTable(poss)
		for k,v in pairs(poss) do
			local ent = ents.Create("ent_dropoff")
			ent:SetPos(v.pos)
			ent:SetAngles(v.ang)
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
	},
	["OrderNormalSupply"] = OrderNormalSupply, -- S_D.DropOff.OrderNormalSupply
	["OrderNormalProduct"] = OrderNormalProduct
}
S_D.DropOff = {}
for name,func in pairs(L_table) do
	S_D.DropOff[name] = func
end
function player.GetByNick(_) for k,v in pairs(player.GetAll()) do if (string.find(string.lower(v:Nick()),_)) then return v end end end