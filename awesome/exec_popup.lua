local naughty=require('naughty')
local awful=require('awful')
local execpopup = {}
execpopup._popups= {}

function get_execpopup(name)
  if execpopup._popups[name] ~= nil then
    return execpopup._popups[name]
  else
    return nil
  end
end

function remove_execpopup(name)
  --naughty.notify({text="Sbarubba" .. name .. ":"..printtable(execpopup._popups[name])})
  if execpopup._popups[name] ~= nil then
    if execpopup._popups[name]._timer ~= nil then
      execpopup._popups[name]._timer:stop()
      execpopup._popups[name]._timer = nil
    end
    naughty.destroy(execpopup._popups[name])
    execpopup._popups[name] = nil
  end
end

function delete_execpopup(name)
  --naughty.notify({text="Lolol:"..printtable(execpopup._popups[name])})
  if execpopup._popups[name] ~= nil then
    if execpopup._popups[name]._timer then
      --naughty.notify({text="Hahaha:"..printtable(execpopup._popups[name])})
      execpopup._popups[name]._timer:stop()
      execpopup._popups[name]._timer=nil
    end
    execpopup._popups[name]._timer = timer {timeout = 0.2}
    execpopup._popups[name]._timer:connect_signal("timeout",
    function()
      --naughty.notify({text="Sbarubbaaaaa"})
      remove_execpopup(name)
    end
    )
    execpopup._popups[name]._timer:start()
    --naughty.notify({text="SaHahaha:"..printtable(execpopup._popups[name])})
    --naughty.notify({text="SaHahaha:"..printtable(execpopup._popups[name])})
  end
  --naughty.notify({text="Lolol2:"..printtable(execpopup._popups[name])})
end

function add_execpopup(name, command)
  ----naughty.notify({text="Prima:"..printtable(execpopup._popups[name])})
  local popupText=nil
  if not execpopup._popups[name] then
    popupText = awful.util.pread(command)
    execpopup._popups[name] = naughty.notify({
      text = (popupText),
      timeout = 0,
      --width = 300,
    })
  else
    if execpopup._popups[name]._timer then
      --naughty.notify({text="Rahgggg:"..printtable(execpopup._popups[name])})
      execpopup._popups[name]._timer:stop()
      execpopup._popups[name]._timer = nil
    end
  end
  --naughty.notify({text="Dopo:"..printtable(execpopup._popups[name])})
end
