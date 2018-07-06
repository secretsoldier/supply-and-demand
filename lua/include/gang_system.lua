local function Empty_Gang()
	return {
		["name"] = nil, -- String
		["leader"] = nil, -- Entity
		["members"] = {} -- Table
	}
end
local current_gangs = {}
local function CreateGang(ply,name)
	local a,b = true,nil
	for k,v in pairs(current_gangs) do
		if v.name == name then
			a = false
			b = "Name is already taken."
		elseif v.leader == ply then
			a = false
			b = "Leader is already leader of another gang."
		end
		for l,d in pairs(v.members) do
			if ply == d then
				a = false
				b = "Leader is already part of another gang."
			end
		end
	end
	if !a then return a,b end
	local t = Empty_Gang()
	t.name = name
	t.leader = ply
	table.Add(current_gangs,{t})
	return a,b
end
local function ReturnGang(ply)
	for k,v in pairs(current_gangs) do
		if v.leader == ply then
			return v,k
		else
			for l,d in pairs(v.members) do
				if d == ply then
					return v,k
				end
			end
		end
	end
end
local function ReturnGangRole(ply)
	local gang,_ = ReturnGang(ply)
	local LEADER,MEMBER = 1,2
	if gang.leader == ply then
		return LEADER
	else
		for k,v in pairs(gang.members) do
			if v == ply then
				return MEMBER
			end
		end
	end
end
local function RegisterMember(ply,leader)
	local meta = getmetatable(ply)
	meta.GetGang = function(self)
		local x,_ = ReturnGang(self)
		return x
	end
	meta.GetGangRole = function(self)
		return ReturnGangRole(self)
	end
	setmetatable(ply,meta)
end
local function RemoveGang(leader)
	local _,index = ReturnGang(leader)
	table.remove(index)
end
-- Leaders and members are two very different things; do not put anyone of them in the wrong parameter
local function RemoveMember(leader,member)
	if !ReturnGang(member) then return end
	local _,index = ReturnGang(leader)
	local gang = current_gangs[index]
	for k,v in pairs(gang.members) do
		if member == v then
			table.remove(current_gangs[index].members,k)
		end
	end
end
local function AddMember(leader,member)
	local check = ReturnGang(member)
	if check then
		RemoveMember(check.leader,member)
	end
	local gang = ReturnGang(leader)
	table.Add(gang.members,{member})
end

local L_table = -- Global Functions:
{
	["CreateGang"] = CreateGang, -- S_D.Gang.CreateGang(ply,name)
	["RegisterMember"] = RegisterMember, -- S_D.Gang.RegisterMember(ply,leader)
	["RemoveGang"] = RemoveGang, -- S_D.Gang.RemoveGang(leader)
	["AddMember"] = AddMember, -- S_D.Gang.AddMember(leader,member)
	["RemoveMember"] = RemoveMember, -- S_D.Gang.RemoveMember(leader,member)
	["Print"] = print -- S_D.Gang.Print(text)
}
S_D.Gang = {}
for name,func in pairs(L_table) do
	S_D.Gang[name] = func
end
--[[
The reason why I have done this is because Lua runs faster
through local variables rather than global variables.
So I have written it locally first then made certain functions
global so they can be accessed by other threads.
]]--