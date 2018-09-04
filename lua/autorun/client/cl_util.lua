AddCSLuaFile("include/client-derma.lua")
local hookPos,hookSec = nil,nil
local function timerActive(seconds)
	hookSec = seconds
	timer.Create("SD_Timer",seconds,(seconds+1),function()
		hookSec = hookSec - 1
		if hookSec <= 0 then
			net.Start("SD_SC1")
			net.SendToServer()
		end
	end)
end
local function timerDeactive()
	timer.Remove("SD_Timer")
end
local ScreenSpecs = {["x"]=ScrW(),["y"]=ScrH()}
surface.CreateFont("Trebuchet_TimerFont",{
	font = "Trebuchet MS",
	size = 26,
	weight = 900,
	antialias = true,
	outline = true
})
hook.Add("HUDPaint","ClientUtilFunction",function()
	if hookPos then
		local dist = math.Round(LocalPlayer():GetPos():Distance(hookPos))
		if dist < 70 then hookPos = nil return end
		local pos = (hookPos+Vector(0,0,50)):ToScreen()
		WaypointHUD(dist,"Trebuchet18",pos.x,pos.y)
	end
	if hookSec and hookSec >= 0 then
		local time = string.format("%s:%s",string.FormattedTime(hookSec).m,string.FormattedTime(hookSec).s)
		surface.SetFont("Trebuchet_TimerFont")
		local width,height = surface.GetTextSize(time),
		TimerHUD(time,(ScreenSpecs.x/2)-(width/2),ScreenSpecs.y/15))
	end
end)

net.Receive("SD_SC1",function()
	local util = net.ReadInt(2)
	if util == 0 then -- Waypoint
		hookPos = net.ReadEntity():GetPos()
	elseif util == 1 then -- Timer
		timerActive(net.ReadInt(12))
	end
end)