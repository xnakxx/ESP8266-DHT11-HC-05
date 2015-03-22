wifi.setmode(wifi.STATION)
wifi.sta.config("SSID","PASSWORD")
wifi.sta.connect()
tmr.alarm(1, 2000, 1, function() 
if wifi.sta.getip()== nil then 
print(".") 
else 
tmr.stop(1)
print("IP is "..wifi.sta.getip())
end 
end)
dofile("server.lc") -- or "server.lua" if you don't compile the scripts.
