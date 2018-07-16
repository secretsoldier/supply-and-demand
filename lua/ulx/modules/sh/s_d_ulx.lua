local function ulxCommand(name,func,help_str,default) local x = ulx.command("Supply & Demand",string.format("ulx %s",string.lower(name)),func,string.format("!%s",string.lower(name)),
	false,false,false) x:help(help_str) x:defaultAccess(default) return x end
local function ulxLog(string,ply,arg1,arg2,arg3) ulx.fancyLogAdmin(ply,string.format("#A %s",string.format(string,arg1,arg2,arg3))) end
local function ulxError(string,ply) ULib.tsayError(ply,string,false) end
local function ulxParam(enum,hint,optional,restrict,round,restofline) optional = optional or nil restrict = restrict or nil round = round or nil restofline = restofline or nil
	local t = {{type=ULib.cmds.NumArg},{type=ULib.cmds.BoolArg},{type=ULib.cmds.PlayerArg},{type=ULib.cmds.PlayersArg},{type=ULib.cmds.StringArg}} t[enum].hint = hint 
	if !t[enum] then return end if optional then table.Add(t[enum],{ULib.cmds.optional}) end if restrict then table.Add(t[enum],{ULib.cmds.restrictToCompletes}) end
	if restofline then table.Add(t[enum],{ULib.cmds.takeRestOfLine}) end if round then table.Add(t[enum],{ULib.cmds.round}) end return t[enum] end
local NUM,BOOL,PLAYER,PLAYERS,STRING,ALL,OPERATOR,ADMIN,SUPERADMIN = 1,2,3,4,5,"user","operator","admin","superadmin"

local AddPremium = ulxCommand("AddPremium",function(ply,target,days) 
	S_D.Premium.AddPremium(target,days) 
	local x = s 
	if days == 1 then 
		x = nil 
	end 
	ulxLog("Gave %s Premium for %s day%s.",ply,target:Nick(),days,x) end,
	"Gives a player Premium for a certain amount of time.",SUPERADMIN)
local player,num = ulxParam(PLAYER,"target"),ulxParam(NUM,"days")
player.target = "!%superadmin"
num.min = 1
num.max = 30
AddPremium:addParam(player)
AddPremium:addParam(num)

