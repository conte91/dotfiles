-- This is used later as the default terminal and editor to run.
terminal = "urxvtc -fade 20"

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")

local switching = require("switching")
local conkymanager = require("conky_manager")

local screenchanger = require("screen_changer")
local exec_popup = require("exec_popup")
local print_table = require("print_table")
local home_folder = os.getenv("HOME")

--To run application in the right desktop, add this for each one
skipMovingFF=false;

require("lfs") 
-- {{{ Run programm once
local function processwalker()
  local function yieldprocess()
    for dir in lfs.dir("/proc") do
      -- All directories in /proc containing a number, represent a process
      if tonumber(dir) ~= nil then
        local f, err = io.open("/proc/"..dir.."/cmdline")
        if f then
          local cmdline = f:read("*all")
          f:close()
          if cmdline ~= "" then
            coroutine.yield(cmdline)
          end
        end
      end
    end
  end
  return coroutine.wrap(yieldprocess)
end

local function run_once(process, cmd)
  assert(type(process) == "string")
  local regex_killer = {
    ["+"]  = "%+", ["-"] = "%-",
    ["*"]  = "%*", ["?"]  = "%?" }

    for p in processwalker() do
      if p:find(process:gsub("[-+?*]", regex_killer)) then
        return
      end
    end
    return awful.util.spawn(cmd or process)
  end
  -- }}}

  -- Usage Example
  run_once("udiskie")
  --run_once("firefox")
  run_once(home_folder .. "/.cambiasfondo.pl")
  run_once("setxkbmap -layout us -variant altgr-intl -option nodeadkeys")
  run_once("pasystray")
  run_once("glipper")
  run_once("nm-applet")
  run_once("liferea")
  -- Use the second argument, if the programm you wanna start, 
  -- differs from the what you want to search.
  run_once("urxvtd", "urxvtd -o -q -f")
  run_once("xautolock -locker i3lock")
  run_once("python2 /usr/bin/pamusb-agent")
  run_once("/usr/bin/python /usr/bin/blueman-applet", "blueman-applet")
  run_once("/usr/bin/python2 /usr/share/kupfer/kupfer.py --no-splash", "kupfer --no-splash")
  run_once("conky")
  --run_once("pidgin")
  run_once("/usr/bin/ruby /usr/bin/sup", "urxvt -name MailTerminal -e sh -c \"RUBY_GC_MALLOC_LIMIT=256000000 RUBY_HEAP_MIN_SLOTS=600000 RUBY_HEAP_SLOTS_INCREMENT=200000 RUBY_HEAP_FREE_MIN=100000 sup\"")

  -- {{{ Error handling
  -- Check if awesome encountered an error during startup and fell back to
  -- another config (This code will only ever execute for the fallback config)
  if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors })
  end

  -- Handle runtime errors after startup
  do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
      -- Make sure we don't go into an endless error loop
      if in_error then return end
      in_error = true

      naughty.notify({ preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = err })
      in_error = false
    end)
  end
  -- }}}

  -- {{{ Variable definitions
  -- Themes define colours, icons, and wallpapers
  beautiful.init(home_folder .. "/.config/awesome/mytheme/theme.lua")
  editor = os.getenv("EDITOR") or "nano"
  editor_cmd = terminal .. " -e " .. editor

  -- Default modkey.
  -- Usually, Mod4 is the key with a logo between Control and Alt.
  -- If you do not like this or do not have such a key,
  -- I suggest you to remap Mod4 to another key using xmodmap or other tools.
  -- However, you can use another modifier like Mod1, but it may interact with others.
  modkey = "Mod4"

  -- Table of layouts to cover with awful.layout.inc, order matters.
  local layouts =
  {
    --awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.magnifier,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
  }
  -- }}}

  -- {{{ Wallpaper
  if beautiful.wallpaper then
    for s = 1, screen.count() do
      gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
  end
  -- }}}

  -- {{{ Tags
  -- Define a tag table which hold all screen tags.
  for s = 1, screen.count() do
    -- Each screen has its own tag table.
    awful.tag({ '零' , '一', '二', '三', '四', '五', '六', '七', '八', '九', '@'}, s, layouts[1])
  end
  -- }}}


-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
  { "manual", terminal .. " -e man awesome" },
  { "edit config", editor_cmd .. " " .. awesome.conffile },
  { "restart", awesome.restart },
  { "quit", function() awesome.quit() end }
}

mymainmenu = awful.menu({ items = {
    { "awesome", myawesomemenu, beautiful.awesome_icon },
    { "open terminal", terminal },
    { "firefox", "firefox" },
    --{ "System", fd_menu_items }
  }
})

theme.font = "DejaVu Sans 8"

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Vicious widgets
-- {{{

--widgetseparator = wibox.widget.imagebox()
--widgetseparator:set_image("provola.png")
--widgetseparator:fit(30,30)
--widgetseparator:set_height(50);
--
--RSS READER From reussnerm
--
--rssbox_urlOfFeeds= { "https://news.ycombinator.com/rss", "http://xkcd.com/rss.xml" }
--rssbox={}
--rssbox=widget({type = "textbox", name="rss"})
--aware.register(rssbox, rssbox_urlOfFeeds, {} ) 

--END RSS READER
battwidget = awful.widget.progressbar()
battwidget:set_max_value(1)
battwidget:set_width(30)
battwidget:set_height(5)
battwidget:set_color("#00ff00")
battwidget:set_background_color("#cc0000")
vicious.register(battwidget, vicious.widgets.bat, "$2", 10, "BAT0")

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

--mySettings=wibox.widget.imagebox()
--mySettings:set_image(awful.util.getdir("config") .. "/settings.png")
--
--mySettingscid=nil
--showMe=nil
--mySettings.asd="ASD"
--
--mySettings:buttons(awful.util.table.join(
--awful.button({ }, 1, 
--function (c) 
--  local testo=nil
--  if not showMe then
--    testo="Stocazzo false"
--    showMe=true
--  else
--    testo="Stocazzo true"
--    showMe=false
--  end
--
--
--  for i, v in pairs(c.widget) do
--    naughty.notify({ text =  i, 
--    timeout = 4})
--  end
--  mySettingscid = naughty.notify({ text =  c.widget.asd,
--  timeout = 4,
--  replaces_id = mySettingscid }).id
--end
--)
--
--))

-- Create a wibox for each screen and add it
mywibox = {}
mytaglist = {}
local taglist_buttons = awful.util.table.join(
                          awful.button({ }, 1, function(t) t:view_only() end),
                          awful.button({ modkey }, 1, function(t) 
                                                        if client.focus then
                                                          client.focus:move_to_tag(t)
                                                        end
                                                      end),
                          awful.button({ }, 3, awful.tag.viewtoggle),
                          awful.button({ modkey }, 3, function(t) 
                                                        if client.focus then
                                                          client.focus:toggle_tag(t)
                                                        end
                                                      end),
                          awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                          awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = awful.util.table.join(
                           awful.button({ }, 1, function (c)
                             if c == client.focus then
                               c.minimized = true
                             else
                               -- Without this, the following
                               -- :isvisible() makes no sense
                               c.minimized = false
                               if not c:isvisible() and c.first_tag then
                                 awful.tag.viewonly(c:tags()[1])
                               end
                               -- This will also un-minimize
                               -- the client, if needed
                               client.focus = c
                               c:raise()
                             end
                           end),
                           awful.button({ }, 3, client_menu_toggle_fn()),
                           awful.button({ }, 4, function ()
                             awful.client.focus.byidx(1)
                           end),
                           awful.button({ }, 5, function ()
                             awful.client.focus.byidx(-1)
                           end))

switching.toggleWidget(
function(a)
  if a then
    awful.util.spawn("light -S 90")
  else
    awful.util.spawn("light -S 20")
  end
  return true
end
, "Screen brightness", false
)

switching.toggleWidget(
function(a)
  if a then
    awful.util.spawn("xset s on +dpms")
    awful.util.spawn("xautolock -enable")
  else
    awful.util.spawn("xset s off -dpms")
    awful.util.spawn("xautolock -disable")
  end
  return true
end
, "Screen locking", true, awful.util.getdir("config") .. "/screen.svg"
)

switching.toggleWidget(
function(a)
  if a then
    awful.util.spawn("rfkill unblock all")
  else
    awful.util.spawn("rfkill block all")
  end
  return true
end
, "WiFi", false, awful.util.getdir("config") .. "/wifi.svg"
)

awful.screen.connect_for_each_screen(function(s)
  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(awful.util.table.join(
                          awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                          awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                          awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                          awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

  -- Widgets that are aligned to the right
  s.right_layout = wibox.layout.fixed.horizontal()
  switching.addToggles(s.right_layout)
  s.right_layout:add(battwidget)
  if s.index == 1 then s.right_layout:add(wibox.widget.systray()) end
  s.right_layout:add(mytextclock)
  s.right_layout:add(s.mylayoutbox)

  -- Create the wibox
  s.mywibox = awful.wibox({ position = "top", screen = s })

  s.mywibox:setup {
              layout = wibox.layout.align.horizontal,
              { -- Left widgets
                  layout = wibox.layout.fixed.horizontal,
                  mylauncher,
                  s.mytaglist,
                  s.mypromptbox,
              },
              s.mytasklist, -- Middle widget
              -- Right widgets
              s.right_layout
          }
end)

-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
               awful.button({ }, 3, function () mymainmenu:toggle() end),
               awful.button({ }, 4, awful.tag.viewnext),
               awful.button({ }, 5, awful.tag.viewprev)
               )
            )
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

awful.key({ modkey,           }, "j",
            function ()
              awful.client.focus.byidx( 1)
            end),
awful.key({ modkey,           }, "k",
            function ()
              awful.client.focus.byidx(-1)
            end),
awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

-- Layout manipulation
awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)     end),
awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx(  -1)    end),
awful.key({ modkey, "Shift"   }, "r", function () awful.util.spawn("kupfer")    end),
awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
awful.key({ modkey,           }, "Tab",
            function ()
              awful.client.focus.history.previous()
              if client.focus then
                client.focus:raise()
              end
            end),

-- Standard program
awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
awful.key({ modkey, "Control" }, "r", awesome.restart),
awful.key({ modkey, "Shift"   }, "q", function() awesome.quit() end),

awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true)      end),
awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true)      end),
awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)         end),
awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)         end),
awful.key({ modkey,           }, "space", function () awful.layout.inc(1) end),
awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1) end),

awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end),

-- Prompt
awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end),

awful.key({ modkey }, "x",
            function ()
              awful.prompt.run { prompt = "Run Lua code: " ,
                                 textbox      = awful.screen.focused().mypromptbox.widget,
                                 exe_callback = awful.util.eval,
                                 history_path = awful.util.get_cache_dir() .. "/history_eval"
                               }
            end),


awful.key({ modkey , "Shift"}, "e",
  function ()
    awful.prompt.run({ prompt = "Search for translations: " },
    mypromptbox[mouse.screen].widget,
    function (w) -- Search for translation in both it->en and en->it
      local ba, ca, ha = http.request("http://www.wordreference.com/iten/"..w)
      local strresult=""
      --naughty.notify({text=ba, timeout=0})
      local myRegex="<td class='FrWrd'><strong>([^<]*)</strong>[^<]*<em class='POS2'>([^<]*)</em></td>[^<]*<td>[^<]*</td>[^<]*<td class='ToWrd'[^>]*>([^<]*)<em class"
      --local myRegex2="<td class='FrWrd'><strong>([^<]*)</strong>.*</td>"
      for word, thetype, trans in string.gmatch(ba, myRegex) do
      --_,_, text = string.find(ba, myRegex2)
      --naughty.notify({text = text, timeout=0})
      --naughty.notify({text=word})
      --naughty.notify({text=thetype})
      --naughty.notify({text=trans})
          local result= word .. ' ('.. thetype .. ') => ' .. trans
          strresult=strresult..result..'\n'
      end
      naughty.notify({text = strresult, timeout=0})
    end,
    nil,
    awful.util.getdir("cache") .. "/translations_history") -- Translation cache savefile
  end),


-- Menubar
awful.key({ modkey, "Shift" }, "m", function() menubar.show() end),
-- Lock screen
awful.key({ modkey, "Shift" }, "l", function () awful.util.spawn("xautolock -locknow")    end),
-- Change screen
awful.key({ modkey,  }, "p", xrandr),
awful.key({}, "F10", unminimize_conky, minimize_conky),
awful.key({}, "F11",
    function()
      add_execpopup("todolist", "~/Sblargaba/todo/todo.sh")
    end,
    function()
      delete_execpopup("todolist")
    end
),
-- Volume keys
awful.key({}, "XF86AudioLowerVolume", function () awful.util.spawn("pactl set-sink-volume 0 '-1%'")    end),
awful.key({}, "XF86AudioRaiseVolume", function () awful.util.spawn("pactl set-sink-volume 0 '+1%'")    end),
awful.key({}, "XF86MonBrightnessUp", function () awful.util.spawn("light -A 1")    end),
awful.key({}, "XF86MonBrightnessDown", function () awful.util.spawn("light -U 1")    end)
)

clientkeys = awful.util.table.join(
               awful.key({ modkey,           }, "f", function (c)
                                                       c.fullscreen = not c.fullscreen
                                                       c:raise()
                                                     end),
               awful.key({ modkey, "Shift"   }, "c", function (c) c:kill() end),
               awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle ),
               awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
               awful.key({ modkey,           }, "o",      awful.client.movetoscreen ),
               awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
               awful.key({ modkey,           }, "n",
                           function (c)
                             -- The client currently has the input focus, so it cannot be
                             -- minimized, since minimized clients can't have the focus.
                             c.minimized = true
                           end),
               awful.key({ modkey, "Shift", "Control"   }, "j",
                           function (c)
                             c:move_to_screen(c.screen.index + 1)
                           end),
               awful.key({ modkey, "Shift", "Control"   }, "k",
                           function (c)
                             c:move_to_screen(c.screen.index - 1)
                           end),
               awful.key({ modkey,           }, "m",
                           function (c)
                             c.maximized = not c.maximized
                             c:raise()
                           end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
  keynumber = math.min(9, math.max(#screen[s].tags, keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
local function bind_to_desktop(key, number)
  globalkeys = awful.util.table.join(globalkeys,
  awful.key({ modkey }, key ,
              function ()
                local screen = awful.screen.focused()
                if screen.tags[number] then
                  screen.tags[number]:view_only()
                end
              end),
  awful.key({ modkey, "Control" },key,
              function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                   awful.tag.viewtoggle(tag)
                end
              end),
  awful.key({ modkey, "Shift" },key,
              function ()
                if client.focus then
                  local tag = client.focus.screen.tags[number]
                  if tag then
                    client.focus:move_to_tag(tag)
                  end
                end
              end),
  awful.key({ modkey, "Control", "Shift" },key,
              function ()
                if client.focus then
                  local tag = client.focus.screen.tags[number]
                  if tag then
                    client.focus:toggle_tag(tag)
                  end
                end
              end))
end

for i = 1, keynumber do
  bind_to_desktop("#" .. i + 9, i);
end

bind_to_desktop("0", 10);
bind_to_desktop("'", 11);

clientbuttons = awful.util.table.join(
                  awful.button({ }, 1, function (c)
                                         client.focus = c; c:raise()
                                       end),
                  awful.button({ modkey }, 1, awful.mouse.client.move),
                  awful.button({ modkey }, 3, awful.mouse.client.resize))


-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
  -- All clients will match this rule.
  { rule = { },
  properties = { border_width = beautiful.border_width,
  border_color = beautiful.border_normal,
  focus = awful.client.focus.filter,
  keys = clientkeys,
  buttons = clientbuttons,
  size_hints_honor = false } },
  { rule = { class = "MPlayer" },
  properties = { floating = true } },
  { rule = { class = "pinentry" },
  properties = { floating = true } },
  { rule = { class = "gimp" },
  properties = { floating = true } },

  {rule = {class = "dosbox"}, properties={minimized=true}},
  { rule = { class = "Plugin-container" },
  properties = { floating = true } },
  { rule = { instance = "MailTerminal"},
  properties = {tag=screen[1].tags[11],  fullscreen=true } },
  { rule = { class = "Firefox" },
  properties = { }, callback = function (c)
    if not skipMovingFF then
      awful.client.movetotag(screen[1].tags[2], c)
      skipMovingFF = true                                                                 
    end 
  end },
  { rule = { class = "conky" },
    properties = {
        floating = true,
        sticky = true,
        ontop = true,
        focusable = false,
        size_hints = {"program_position", "program_size"},
        minimized = true
    }
  },
  { rule = { name = "Workrave" },
    properties = {
        floating = true,
        ontop = true,
        sticky = true
      }
    }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
  if awesome.startup and
    not c.size_hints.user_position
    and not c.size_hints.program_position then
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Put windows in a smart way, only if they does not set an initial position.
    if not c.size_hints.user_position and not c.size_hints.program_position then
      awful.placement.no_overlap(c)
      awful.placement.no_offscreen(c)
    end
  end
end)
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

--
-- Enable sloppy focus
client.connect_signal("mouse::enter", function(c)
  if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
    and awful.client.focus.filter(c) then
    client.focus = c
  end
end)
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
--


