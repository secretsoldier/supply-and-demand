local function ulxCommand(name,func) return ulx.command("Supply & Demand",string.format("ulx %s",string.lower(name)),func,string.format("!%s",string.lower(name)),false,false,false) end
local function ulxLog(string,ply,arg1,arg2,arg3) ulx.fancyLogAdmin(ply,string.format("#A %s",string.format(string,arg1,arg2,arg3))) end
local function ulxError(string,ply) ULib.tsayError(ply,string,false) end
local function ulxParam(enum,hint,optional,restrict,round,restofline) optional = optional or nil restrict = restrict or nil round = round or nil restofline = restofline or nil
	local t = {{type=ULib.cmds.NumArg},{type=ULib.cmds.BoolArg},{type=ULib.cmds.PlayerArg},{type=ULib.cmds.PlayersArg},{type=ULib.cmds.StringArg}} t[enum].hint = hint 
	if !t[enum] then return end if optional then table.Add(t[enum],{ULib.cmds.optional}) end if restrict then table.Add(t[enum],{ULib.cmds.restrictToCompletes}) end
	if restofline then table.Add(t[enum],{ULib.cmds.takeRestOfLine}) end if round then table.Add(t[enum],{ULib.cmds.round}) end return t[enum] end
local NUM,BOOL,PLAYER,PLAYERS,STRING,ALL,OPERATOR,ADMIN,SUPERADMIN = 1,2,3,4,5,"user","operator","admin","superadmin"