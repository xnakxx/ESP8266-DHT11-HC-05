-- Horrible name I know. It really does not 'serve' anything but it's purpose.
humi= nil
fare= nil
function ReadDHT()
     --dht = require "dht11" --dht11
     dht = require "dht22"
     dht.read(3) --gpio0
     t = dht.getTemperature()
     h = dht.getHumidity()
     -- release module
     dht = nil
     --package.loaded.dht11=nil --dht11
     package.loaded.dht22=nil
     
    if h == nil then
  print("Error reading from DHT22")
     t= nil
     h = nil
     return
   else
     --humi=(h) --dht11
     humi = ((h - (h % 10)) / 10)
     fare = (9 * t / 50 + 32)
     t= nil
     h = nil
     sendData()
   end
end
function sendData()
-- conection to thingspeak.com
print("Sending data to thingspeak.com")
conn=net.createConnection(net.TCP, 0) 
conn:on("receive", function(conn, payload) 
payload = nil
 end)
-- api.thingspeak.com 184.106.153.149
conn:connect(80,'184.106.153.149') 
conn:send("GET /update?key=XXXXXXXXXXXXXXXX&field1="..fare.."&field2="..humi.." HTTP/1.1\r\n") 
conn:send("Host: api.thingspeak.com\r\n") 
conn:send("Accept: */*\r\n") 
conn:send("User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n")
conn:send("\r\n")
conn:on("sent",function(conn)
                      --print("Closing connection")
                      conn:close()
                  end)
conn:on("disconnection", function(conn)
                      --print("Got disconnection...")
                      conn = nil
  end)
  fare = nil
  humi = nil
end
-- send data every X ms to thing speak
tmr.alarm(2, 60000, 1, function() ReadDHT() end )
