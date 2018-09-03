S_D = {}
S_D.dev = true
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
	"drop_off_controller",
	"commands"
}
for k,v in pairs(modules) do
	include(string.format("include/%s.lua",v))
end