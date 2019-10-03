-- Switching - a toggling widgets library for Awesome WM
-- 


switching = switching or {}
switching._toggleWidgets=switching._toggleWidgets or {}

local wibox=require("wibox")
local awful=require("awful")
local naughty=require("naughty")

--Settings widget
function switching.toggleWidget(func, description, value, image)
  --Puts the new widget in our table
  switching._toggleWidgets[description]=wibox.widget.imagebox()
  local myImage=nil
  if type(image)=="string" then
    myImage=image
  else
    myImage=awful.util.getdir("config") .. "/settings.png"
  end
  switching._toggleWidgets[description]:set_image(myImage)
  switching._toggleWidgets[description].toggleSettings_description=description
  switching._toggleWidgets[description].toggleSettings_value=value
  switching._toggleWidgets[description].toggleSettings_function=func
  switching._toggleWidgets[description]:buttons(
  awful.util.table.join(
  awful.button({ }, 1,
  function(c)
    if not switching._toggleWidgets[description].toggleSettings_value then
      testo=c.widget.toggleSettings_description .. ": ON"
      if c.widget.toggleSettings_function(true) then
        c.widget.toggleSettings_value=true
      end
    else
      testo=c.widget.toggleSettings_description .. ": OFF"
      if c.widget.toggleSettings_function(false) then
        c.widget.toggleSettings_value=false
      end
    end 
    c.widget.toggleSettings_cid = naughty.notify({ text =  testo,
    timeout = 4,
    replaces_id = c.widget.toggleSettings_cid }).id

  end
  )
  )
  )
  return switching._toggleWidgets[description]
end

function switching.addToggles(layout)
  --Adds all registered widgets to specified layout
  for i,v in pairs(switching._toggleWidgets) do
    layout:add(v)
  end
end

return switching
