function TimerHUD(time,pos)
	surface.SetTextColor(0,0,0,255)
	surface.SetTextPos(pos)
	surface.DrawText(time)
end
function WaypointHUD(text,font,posx,posy)
	draw.SimpleText(text,font,posx,posy)
end