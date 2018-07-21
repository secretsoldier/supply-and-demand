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
local data_list = {}

local L_table = {
	["RegisterEntity"] = RegisterEnt, -- S_D.DropOff.RegisterEntity(ent)
	["RandomEntity"] = function() return RndEnt(ent_list) end -- S_D.DropOff.RandomEntity()
}
S_D.DropOff = {}
for name,func in pairs(L_table) do
	S_D.DropOff[name] = func
end