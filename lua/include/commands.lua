--[[ 
COMMAND.Name = "Arrest"
COMMAND.Flag = EAS.Config.Commands.Arrest
COMMAND.AdminMode = true
COMMAND.Args = {{"player", "Name/SteamID"}, {"number", "Duration"}}

COMMAND.Run = SERVER and function(pl, args, supp)
	supp[1]:arrest(supp[2])
end
--]]
local SavePositions = {
	["Name"] = "SavePositions",
--	["Flag"] = EAS.Config.Commands.SavePositions,
	["AdminMode"] = true
	["Args"] = nil,
	["Run"] = SERVER and function(pl,args,supp)
		S_D.DropOff.SavePositions()
	end
}
local RemovePositions = {
	["Name"] = "RemovePositions",
--	["Flag"] = EAS.Config.Commands.RemovePositions,
	["AdminMode"] = true
	["Args"] = nil,
	["Run"] = SERVER and function(pl,args,supp)
		S_D.DropOff.RemovePositions()
	end
}