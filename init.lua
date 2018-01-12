--- === Cryptocurrency ===
---
--- A Cryptocurrency stat displayer
---
--- Download:  [https://github.com/Grox-Ni/CryptocurrencySpoon/archive/master.zip](https://github.com/Grox-Ni/CryptocurrencySpoon/archive/master.zip)

local json = require('cjson')

local obj={}
obj.__index = obj

-- Metadata
obj.name = "Cryptocurrency"
obj.version = "1.0"
obj.author = "groxni <nishukai@hotmail.com>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.height = 600
obj.width = obj.height * 0.618
obj.interval = 60

listNum = 25
baseUrl = 'https://api.coinmarketcap.com/v1/ticker/'

local function updateStats()
  local _, body = hs.http.get(baseUrl, nil)
  if body then
    stats = json.decode(body)
  end
  for k, v in ipairs(stats) do
    if (k<=listNum) then
      obj.canvas[2+k].text = string.format("%20s   %3.3s   %8.2f   %5.2f", v.name, v.symbol, v.price_usd, v.percent_change_1h)
    else
      break
    end
  end
end

function obj:init()
  local cscreen = hs.screen.mainScreen()
  local cres = cscreen:fullFrame()
  obj.canvas = hs.canvas.new({
      x = 40,
      y = 40,
      w = obj.width,
      h = obj.height,
  }):show()

  obj.canvas:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)
  obj.canvas:level(hs.canvas.windowLevels.desktopIcon)

  obj.canvas[1] = {
    id = "bg",
    type = "rectangle",
    action = "fill",
    fillColor = {red=0, blue=0, green=0, alpha=0.3},
    roundedRectRadii = {xRadius = 10, yRadius = 10},
  }

  obj.canvas[2] = {
    id = "title",
    type = "text",
    text = "CryptoCurrency Market Cap",
    textSize = 18,
    textColor = {red=1, blue=1, green=1, alpha=0.3},
    textAlignment = "left",
    frame = {
      x = tostring(10/obj.width),
      y = tostring(10/obj.height),
      w = tostring(1-20/obj.width),
      h = "30%"
    }
  }

  for i=3, 2+listNum do
    obj.canvas[i] = {
      type = "text",
      text = "",
      textFont = "Ubuntu Mono derivative Powerline",
      textSize = 13,
      textAlignment = "left",
      frame = {
            x = "10%",
            y = tostring(20*(i-1)/obj.height),
            w = tostring(1-20/obj.width),
            h = "20%"
      }
    }
  end

  if obj.timer == nil then
    obj.timer = hs.timer.doEvery(obj.interval, updateStats)
    obj.timer:setNextTrigger(0)
  else
    obj.timer:start()
  end

end

return obj
