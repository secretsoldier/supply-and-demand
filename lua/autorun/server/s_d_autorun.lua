local lang = util.JSONToTable(util.Decompress(file.Read("include/english-language-table.dat","LUA")))
local version_info = util.JSONToTable(file.Read("include/version.txt","LUA"))
print("###########################################")
print("Supply and Demand Initlised.")
print(string.format(lang.version_message,version_info.version,version_info.build_state))
if version_info.unstable then
	print(lang.unstable_message)
end
local latest_version_info
http.Fetch(lang.url,function(body,size,headers,code)
	latest_version_info = util.JSONToTable(body)
	if latest_version_info then
		if version_info.version < latest_version_info.version then
			if version_info.unstable and !latest_version_info.unstable then
				print(lang.recommend_message)
			else
				print(lang.casual_message)
			end
		end
	else
		print(lang.unable_message)
	end
end)
print("###########################################")

S_D = {}
S_D.dev = false
S_D.NetworkString = {
	["util"] = "SC1",
	"HornyNipples321"
}
S_D.NetworkString.Format = function(string)
	return string.format("SD_%s",string)
end
for k,v in pairs(S_D.NetworkString) do
	if !isfunction(v) then
		util.AddNetworkString(S_D.NetworkString.Format(v))
	end
end
local modules = {
	"config",
	"gang_system",
	"premium",
	"drop_off_controller"
}
for k,v in pairs(modules) do
	include(string.format("include/%s.lua",v))
end

hook.Add("SD_EntBecomingAvailable","NextInQ",function()
	local q = S_D.DropOff.Queue.GetNext()
	S_D.DropOff.OrderNormalSupply(ply,1)
	S_D.DropOff.Queue.Remove(ply)
end)
concommand.Add("SD_BuySupply",function(ply,cmd,args,argStr)
	if !S_D.DropOff.OrderNormalSupply(ply,1) then
		S_D.DropOff.Queue.Add(ply)
	end
end,nil,nil,FCVAR_LUA_CLIENT)
concommand.Add("SD_SellProduct",function(ply,cmd,args,argStr)
	if !S_D.DropOff.OrderNormalSupply(ply,1) then
		S_D.DropOff.Queue.Add(ply)
	end
end,nil,nil,FCVAR_LUA_CLIENT)
concommand.Add("SD_SaveDropOffPositions",S_D.DropOff.SavePositions,nil,nil,FCVAR_PROTECTED) 
concommand.Add("SD_RemoveDropOffPositions",S_D.DropOff.RemovePositions,nil,nil,FCVAR_PROTECTED)
if DarkRP then
	DarkRP.createEntity("Machine Processor",{
		ent = "ent_process",
		model = "models/props_wasteland/laundry_washer003.mdl",
		price = S_D.Configs.Process_Machine_Cost,
		max = 1,
		cmd = "SD_BuyMachineProccessor",
		allowed = S_D.Configs.Machine_Team_Allowed,
		category = S_D.Configs.Machine_Entity_Category
	})
end