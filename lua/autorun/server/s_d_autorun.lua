local version_info = util.JSONToTable(file.Read("include/version.txt","LUA"))
print("SD: Supply and Demand Initlised.")
print(string.format("Version: %s %s",version_info.version,version_info.build_state))
if version_info.unstable then
	print("### This release is considered unstable, please report at errors to the developer ###")
end
local latest_version_info
http.Fetch("https://raw.githubusercontent.com/secretsoldier/supply-and-demand/master/lua/include/version.txt",function(body)
	latest_version_info = util.JSONToTable(body)
end)
if latest_version_info then
	if !(tonumber(version_info.version) < tonumber(latest_version_info.version)) then
		if (version_info.unstable and !latest_version_info.unstable) and !(version_info.version < latest_version_info.last_stable_version) then
			print("Supply and Demand can be updated to a stable release")
		elseif version_info.unstable and latest_version_info.unstable then
			print("A later version of Supply and Demand is available for download")
		end
	end
else
	print("Unable to retrieve version info.")
end

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
	if !(type(v) == "function") then
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