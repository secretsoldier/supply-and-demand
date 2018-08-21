local function ulxCommand(name,func,help_str,default) local x = ulx.command("Supply & Demand",string.format("ulx %s",string.lower(name)),func,string.format("!%s",string.lower(name)),
	false,false,false) x:help(help_str) x:defaultAccess(default) return x end
local function ulxLog(string,ply,arg1,arg2,arg3) ulx.fancyLogAdmin(ply,string.format("#A %s",string.format(string,arg1,arg2,arg3))) end
local function ulxError(string,ply) ULib.tsayError(ply,string,false) end
local function ulxParam(enum,hint,optional,restrict,round,restofline) optional = optional or nil restrict = restrict or nil round = round or nil restofline = restofline or nil
	local t = {{type=ULib.cmds.NumArg},{type=ULib.cmds.BoolArg},{type=ULib.cmds.PlayerArg},{type=ULib.cmds.PlayersArg},{type=ULib.cmds.StringArg}} t[enum].hint = hint 
	if !t[enum] then return end if optional then table.Add(t[enum],{ULib.cmds.optional}) end if restrict then table.Add(t[enum],{ULib.cmds.restrictToCompletes}) end
	if restofline then table.Add(t[enum],{ULib.cmds.takeRestOfLine}) end if round then table.Add(t[enum],{ULib.cmds.round}) end return t[enum] end
local NUM,BOOL,PLAYER,PLAYERS,STRING,ALL,OPERATOR,ADMIN,SUPERADMIN = 1,2,3,4,5,"user","operator","admin","superadmin"
-----
local AddPremium = ulxCommand("AddPremium",
	function(ply,target) S_D.Premium.AddPremium(target,S_D.Premium.Enum.Month) ulxLog("Gave %s Premium.",ply,target:Nick()) end,
	"Gives a player Premium for a Month.",SUPERADMIN)
local player = ulxParam(PLAYER,"target")
--player.target = "!%superadmin"
AddPremium:addParam(player)
-----
local RemovePremium = ulxCommand("RemovePremium",
	function(ply,target) if S_D.Premium.RemovePremium(target) then ulxLog("Removed Premium from %s",ply,target:Nick()) else ulxError("This player does not have Premium to remove.",ply) end end,
	"Removed Premium from a player.",SUPERADMIN)
local player = ulxParam(PLAYER,"target")
--player.target = "!%superadmin"
RemovePremium:addParam(player)
----
local PrintPremiumPlayers_func = function(ply)
	if SERVER then
		ply:PrintMessage(HUD_PRINTTALK,table.ToString(S_D.Premium.GetAllPremium(),"Premium Players",true))
	end
end
local PrintPremiumPlayers = ulxCommand("PrintPremiumPlayers",PrintPremiumPlayers_func,
	"Prints a list of all the players with Premium in console.",SUPERADMIN)


local function CreateEntity(class,pos)
	local ent = ents.Create(class)
	if !IsValid(ent) then return end
	ent:SetPos(pos)
	ent:Spawn()
end
local SpawnEntity = ulxCommand("SpawnEntity",function(ply,class) CreateEntity(class,ply:GetEyeTrace().HitPos) ulxLog("Spawned %s",ply,class) end,
	"Spawns an entity from a pre-selected list.",SUPERADMIN)
local string = ulxParam(STRING,"class")
string.completes = {"ent_supplies","ent_product","ent_process","ent_dropoff"}
string.error = "Please choose a class"
SpawnEntity:addParam(string)