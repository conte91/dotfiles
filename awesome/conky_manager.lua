local conkyTimer= nil

function get_conky()
    local clients = client.get()
    local conky = nil
    local i = 1
    while clients[i]
    do
        if clients[i].class == "conky"
        then
            conky = clients[i]
        end
        i = i + 1
    end
    return conky
end
function raise_conky()
    local conky = get_conky()
    if conky
    then
        conky.ontop = true
    end
end
function remove_conky()
    if conkyTimer ~= nil then
      conkyTimer:stop()
      conkyTimer = nil
    end
    local conky = get_conky()
    if conky
    then
        conky.minimized = true
    end
end
function minimize_conky()
    if conkyTimer then
      conkyTimer:stop()
      conkyTimer=nil
    end
    conkyTimer = timer {timeout = 0.2}
    conkyTimer:connect_signal("timeout",
    function()
      remove_conky()
    end
    )
    conkyTimer:start()
end
function unminimize_conky()
    local conky = get_conky()
    if conky
    then
        conky.minimized = false
    end
end
function lower_conky()
    local conky = get_conky()
    if conky
    then
        conky.ontop = false
    end
end
function toggle_conky()
    local conky = get_conky()
    if conky
    then
        if conky.ontop
        then
            conky.ontop = false
        else
            conky.ontop = true
        end
    end
end
