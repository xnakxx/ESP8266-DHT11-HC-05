local moduleName = ...
local M = {}
_G[moduleName] = M

local humidity
local temperature
local checksum
local checksumTest
local checko1
local checko2

function M.read(pin)
  humidity = 0
  temperature = 0
  checksum = 0
  checko1=0
  checko2=0
  gpio_read = gpio.read
  gpio_write = gpio.write
  bitStream = {}
  for j = 1, 40, 1 do
    bitStream[j] = 0
  end
  bitlength = 0
  gpio.mode(pin, gpio.OUTPUT)
  --gpio.write(pin, gpio.HIGH)
  --tmr.delay(100)
  gpio.write(pin, gpio.LOW)
  tmr.delay(20000)
  gpio.mode(pin, gpio.INPUT)
  while (gpio_read(pin) == 0 ) do end
  c=0
  while (gpio_read(pin) == 1 and c < 100) do c = c + 1 end
  while (gpio_read(pin) == 0 ) do end
  c=0
  while (gpio_read(pin) == 1 and c < 100) do c = c + 1 end
  for j = 1, 40, 1 do
    while (gpio_read(pin) == 1 and bitlength < 10 ) do
      bitlength = bitlength + 1
    end
    bitStream[j] = bitlength
    bitlength = 0
    while (gpio_read(pin) == 0) do end
  end
  for i = 1, 8, 1 do
    if(bitStream[i+0]>2)then
      humidity=humidity+2^(8-i)
    end
     if(bitStream[i+8]>2)then
      checko1=checko1+2^(8-i)
    end
    if(bitStream[i+16]>2)then
      temperature=temperature+2^(8-i)
    end
    if(bitStream[i+24]>2)then
      checko2=checko2+2^(8-i)
     end
    if (bitStream[i+32]>2)then
      checksum=checksum+2^(8-i)
    end
  end
  checksumTest=(humidity+checko1+temperature+checko2)% 0xFF
  print(checksum)
  print(checksumTest)
  if (checksum == checksumTest) then
    print("check ok")
    else
    humidity = nil
  end
end
function M.getTemperature()
  return temperature
end
function M.getHumidity()
  return humidity
end
return M
