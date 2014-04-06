local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")

if awesome.startup_errors then
   naughty.notify({ preset = naughty.config.presets.critical,
                    title = "Oops, there were errors during startup!",
                    text = awesome.startup_errors })
end

do
   local in_error = false
   awesome.connect_signal("debug::error",
                          function (err)
                             if in_error then return end
                             in_error = true

                             naughty.notify({ preset = naughty.config.presets.critical,
                                              title = "Oops, an error happened!",
                                              text = err })
                             in_error = false
                          end)
end

beautiful.init("~/.config/awesome/my-theme.lua")
gears.wallpaper.maximized(beautiful.wallpaper, nil, true)

terminal = "urxvt"
winkey = "Mod4"
altkey = "Mod1"
ctrlkey = "Control"
mash = { winkey, ctrlkey, altkey }

awful.tag({1})

local right_layout = wibox.layout.fixed.horizontal()
right_layout:add(wibox.widget.systray())
right_layout:add(awful.widget.textclock())

local battery_update_fn = function()
   fh = assert(io.popen("acpi | cut -d, -f 2", "r"))
   batterywidget:set_text(" |" .. fh:read("*l") .. " | ")
   fh:close()
end

batterywidget = wibox.widget.textbox()
batterywidget:set_text(" | Battery | ")
batterywidgettimer = timer({ timeout = 30 })
batterywidgettimer:connect_signal("timeout", battery_update_fn)
batterywidgettimer:start()
right_layout:add(batterywidget)

battery_update_fn()

local layout = wibox.layout.align.horizontal()
layout:set_right(right_layout)

mywibox = awful.wibox({ position = "bottom" })
mywibox:set_widget(layout)

globalkeys = awful.util.table.join(
   awful.key({ winkey, altkey, "Shift" }, "h", function () awful.client.focus.bydirection("left") ; client.focus:raise() end),
   awful.key({ winkey, altkey, "Shift" }, "l", function () awful.client.focus.bydirection("right"); client.focus:raise() end),
   awful.key({ winkey, altkey, "Shift" }, "j", function () awful.client.focus.bydirection("down") ; client.focus:raise() end),
   awful.key({ winkey, altkey, "Shift" }, "k", function () awful.client.focus.bydirection("up"); client.focus:raise() end),

   awful.key({ winkey }, "Return", function () awful.util.spawn(terminal) end),
   awful.key({ winkey }, "r", awesome.restart),
   awful.key({ winkey, "Shift" }, "q", awesome.quit),

   awful.key({ winkey }, "e", function () awful.util.spawn_with_shell("emacsclient -nc -a '' ~/projects") end),
   awful.key({ winkey }, "p", function () awful.util.spawn_with_shell("dmenu_run") end))

grid_width = 3

function round (n) return math.floor(n + 0.5) end

function get_grid(w)
   local winFrame = w:geometry(r)
   local screenRect = screen[1].workarea

   local thirdScreenWidth = screenRect.width / grid_width
   local halfScreenHeight = screenRect.height / 2

   local g = {
      x = round((winFrame.x - screenRect.x) / thirdScreenWidth),
      y = round((winFrame.y - screenRect.y) / halfScreenHeight),
      width  = round(math.max(1, winFrame.width / thirdScreenWidth)),
      height = round(math.max(1, winFrame.height / halfScreenHeight)),
   }

   return g
end

function set_grid(w, grid)
   local screenRect = screen[1].workarea
   local thirdScreenWidth = screenRect.width / grid_width
   local halfScreenHeight = screenRect.height / 2

   local newFrame = {
      x = (grid.x * thirdScreenWidth) + screenRect.x,
      y = (grid.y * halfScreenHeight) + screenRect.y,
      width = grid.width * thirdScreenWidth,
      height = grid.height * halfScreenHeight,
   }

   newFrame.width = newFrame.width - 6
   newFrame.height = newFrame.height - 6

   w:geometry(newFrame)
end

function changeGridWidth(n)
   grid_width = math.max(1, grid_width + n)
   naughty.notify({text = "grid is now " .. grid_width})
end

clientkeys = awful.util.table.join(

   awful.key(mash, "h",
             function (c)
                local w = client.focus
                local f = get_grid(w)
                f.x = math.max(f.x - 1, 0)
                set_grid(w, f)
             end),

   awful.key(mash, "l",
             function (c)
                local w = client.focus
                local f = get_grid(w)
                f.x = math.min(f.x + 1, grid_width - f.width)
                set_grid(w, f)
             end),

   awful.key(mash, "i",
             function (c)
                local w = client.focus
                local f = get_grid(w)
                f.width = math.max(f.width - 1, 1)
                set_grid(w, f)
             end),

   awful.key(mash, "o",
             function (c)
                local w = client.focus
                local f = get_grid(w)
                f.width = math.min(f.width + 1, grid_width)
                set_grid(w, f)
             end),

   awful.key(mash, "j",
             function (c)
                local w = client.focus
                local f = get_grid(w)
                f.y = 1
                f.height = 1
                set_grid(w, f)
             end),

   awful.key(mash, "k",
             function (c)
                local w = client.focus
                local f = get_grid(w)
                f.y = 0
                f.height = 1
                set_grid(w, f)
             end),

   awful.key(mash, "u",
             function (c)
                local w = client.focus
                local f = get_grid(w)
                f.y = 0
                f.height = 2
                set_grid(w, f)
             end),

   awful.key(mash, ";",
             function (c)
                local w = client.focus
                set_grid(w, get_grid(w))
             end),

   awful.key(mash, "'",
             function (c)
                for i, w in pairs(client.get()) do
                   set_grid(w, get_grid(w))
                end
             end),

   awful.key(mash, "m",
             function (c)
                local w = client.focus
                set_grid(w, {x = 0, y = 0, width = grid_width, height = 2})
             end),

   awful.key(mash, "-", function (c) changeGridWidth(-1) end),
   awful.key(mash, "=", function (c) changeGridWidth(1) end),

   awful.key({ winkey, "Shift"   }, "c", function (c) c:kill() end))

clientbuttons = awful.util.table.join(
   awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
   awful.button({ winkey }, 1, awful.mouse.client.move),
   awful.button({ winkey }, 3, awful.mouse.client.resize))

root.keys(globalkeys)

awful.rules.rules = {
   { rule = { },
     properties = { border_width = 3,
                    border_color = beautiful.border_normal,
                    focus = awful.client.focus.filter,
                    size_hints_honor = false,
                    raise = true,
                    keys = clientkeys,
                    buttons = clientbuttons } },
}

function manage_window (c, startup)
   c:connect_signal("mouse::enter", function(c)
                       if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                          and awful.client.focus.filter(c) then
                       client.focus = c
                       c:raise()
                       end
                                    end)

   if not startup then
      if not c.size_hints.user_position and not c.size_hints.program_position then
         awful.placement.no_overlap(c)
         awful.placement.no_offscreen(c)
      end
   end
end

client.connect_signal("manage", manage_window)

client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus  end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
