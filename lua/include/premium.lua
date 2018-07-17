local table_name,f,s = "S_D_Premium",string.format,sql.Query
function sqlQuery(str) local x = s(str) if x == false then error(str) else return x end end local sql.Query = sqlQuery
if !sql.TableExists(table_name) then
	sql.Query(f("CREATE TABLE %s( SteamID TEXT, Date TEXT )",table_name))
end
local MONTH,MONTH_3,MONTH_6,MONTH_9,MONTH_12,PERM = 1,2,3,4,5,6
local function GetCurrentDate()
	return os.date("%y%m%d",os.time())
end
local function StringToTable(str)
	local temp,t = {},{}
	for w in string.gmatch(str,"..") do
		table.Add(temp,{w})
	end
	t.year = temp[1]
	t.month = temp[2]
	t.day = temp[3]
	t.ToString = function(self) return string.format("%s-%s-%s",self.day,self.month,self.year) end
	return t
end
local function TableToString(tab)
	return f("%s%s%s",tab.year,tab.month,tab.day)
end
local function AddToDate(day,month)
	local date,month_lengths = StringToTable(GetCurrentDate()),{31,28,31,30,31,30,31,31,30,31,30,31} -- People who buy before the end of Feburary will get one free day on a leap year, lucky them
	if day > 30 then return end -- Because I CANNOT be bothered to try and calculate more than one month in days
	date.day = date.day + day
	if date.day > month_lengths[date.month] then
		date.day = date.day - month_lengths[date.month]
		date.month = date.month + 1
	end
	date.month = date.month + month
	if date.month > 12 then
		date.month = dat.month - 12
		date.year = date.year + 1 
	end
	return date
end
local function AddPremium(ply,time_length)
	local str,ply,month = f("INSERT INTO %s ( SteamID, Date ) %s",table_name,"VALUES ( %s, %s )"),ply:SteamID(),function(num) return TableToString(AddToDate(0,num)) end
	local switch = {
		[MONTH] = f(str,ply,month(1)),
		[MONTH_3] = f(str,ply,month(3)),
		[MONTH_6] = f(str,ply,month(6)),
		[MONTH_9] = f(str,ply,month(9)),
		[MONTH_12] = f(str,ply,month(12)),
		[PERM] = f(str,ply,nil)
	}
	sql.Query(switch[time_length])
end
local function AddPremiumDay(ply,days)
	if !GetPremiumExpireDate(ply) then return end
	local str = f("INSERT INTO %s ( SteamID, Date ) %s",table_name,"VALUES ( %s, %s )")
	sql.Query(f(str,ply:SteamID(),TableToString(AddToDate(days,0))))
end
local function GetPremiumExpireDate(ply)
	local tab = sql.Query(f("SELECT Date FROM %s WHERE SteamID='%s'",table_name,ply:SteamID()))
	if tab then return tab[1] end
end
local function GetAllPremium()
	return sql.Query(f("SELECT * FROM %s",table_name)) 
end
local function ValidStrDate(str)
	local date,today = StringToTable(str),os.time()
	local time = os.time{year=date.year,month=date.month,day=date.day}
	if time > today then
		return true
	end
end

local L_table = {
	["Enum"] = {["Month"] = MONTH,["Month_3"] = MONTH_3,["Month_6"] = MONTH_6,["Month_9"] = MONTH_9,["Year"] = MONTH_12,["Perm"] = PERM}, -- S_D.Premium.Enum.Month
	["AddPremium"] = AddPremium, -- S_D.Premium.AddPremium(ply,days)
	["GetPremiumExpireDate"] = GetPremiumExpireDate, -- S_D.Premium.GetPremiumExpireDate(ply)
	["GetAllPremium"] = GetAllPremium, -- S_D.Premium.GetAllPremium()
	["StringToTable"] = StringToTable, -- S_D.Premium.StringToTable(str)
	["dev"] = {["ValidStrDate"] = ValidStrDate,["SQL_Table"] = table_name} -- S_D.Premium.dev.ValidStrDate(str)
}
S_D.Premium = {}
for name,func in pairs(L_table) do
	S_D.Premium[name] = func
end