--[[
    Awesome WM configuration
--]]

-- {{{ Required libraries
local awesome, client, mouse, screen, tag --luacheck: no unused
    = awesome, client, mouse, screen, tag

local ipairs, string, os, table, tostring, tonumber, type --luacheck: no unused
    = ipairs, string, os, table, tostring, tonumber, type

local AWESOME_ROOT = os.getenv("AWESOME_ROOT") or os.getenv("HOME") .. "/.config/awesome"

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
local hotkeys_popup = require("awful.hotkeys_popup").widget
                      require("awful.hotkeys_popup.keys")
local my_table      = awful.util.table or gears.table -- 4.{0,1} compatibility
local dpi           = require("beautiful.xresources").apply_dpi
local xrandr        = require("xrandr")
-- }}}

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
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Init Services
local services = {
    battery = require("services.battery")({
        n_perc = { low = 15, crit = 5 },
        timeout = 5,
        notify = "on",
    }),
    brightness = require("services.brightness")(),
    clock = require("services.clock")(),
    usage_cpu = require("services.usage.cpu")(),
    usage_mem = require("services.usage.mem")(),
    network = require("services.network")({
        notify = "on",
        wifi_state = "on",
        eth_state = "on",
    }),
    volume_alsa = require("services.volume.alsa")(),
    screen = require("services.screen")(),
    power = require("services.power")({
        cmd_lock = "false", -- TODO: Create Screen Lock wrapper
    }),
}
-- }}}

-- {{{ Autostart

-- This function will run once every time Awesome is started
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

run_once({
    "setxkbmap -layout us,ru -option grp:win_space_toggle", -- TODO: Create keyboard layouts Wrapper
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1", -- TODO: Create polkit Wrapper
    "xinput set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Tapping Enabled' 1", -- TODO: TouchPad Wrapper
    "autorandr --change --force" -- TODO: Autorandr Service
    -- Apps
    "megasync",
})
-- }}}

-- {{{ Variable definitions
local modkey       = "Mod4"
local altkey       = "Mod1"
local terminal     = "terminator"
-- vi-like client focus - https://github.com/lcpz/awesome-copycats/issues/275
local vi_focus     = false
-- cycle trough all previous client or just the first -- https://github.com/lcpz/awesome-copycats/issues/274
local cycle_prev   = true
local gui_editor   = os.getenv("GUI_EDITOR") or "subl"
local browser      = os.getenv("BROWSER") or "firefox"

awful.util.terminal = terminal
awful.util.tagnames = { "1", "2", "3", "4" }
awful.layout.layouts = {
    awful.layout.suit.max,
    awful.layout.suit.fair,
    awful.layout.suit.tile,
    awful.layout.suit.floating,
}

awful.util.taglist_buttons = my_table.join(
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

awful.util.tasklist_buttons = my_table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    awful.button({ }, 2, function (c) c:kill() end),
    awful.button({ }, 3, function ()
        local instance = nil

        return function ()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({theme = {width = dpi(250)}})
            end
        end
    end),
    awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = dpi(2)
lain.layout.cascade.tile.offset_y      = dpi(32)
lain.layout.cascade.tile.extra_padding = dpi(5)
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

beautiful.init(string.format("%s/theme/theme.lua", AWESOME_ROOT))
-- }}}

-- Add beautiful to Services
services.battery.bat_notification_charged_preset = beautiful.bat_notification_charged_preset
services.battery.bat_notification_low_preset = beautiful.bat_notification_low_preset
services.battery.bat_notification_critical_preset = beautiful.bat_notification_critical_preset

-- {{{ Screen
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function (s)
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if only_one and not c.floating or c.maximized then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width
        end
    end
end)
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)
-- }}}

-- {{{ Mouse bindings
root.buttons(my_table.join(
    awful.button({ }, 1, function () end), -- TODO: Use global handler. See: #15
    awful.button({ }, 3, function () end), -- TODO: Use global handler. See: #15
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = my_table.join(
    -- {{{ Awesome Keys group
    awful.key({ modkey }, "s", hotkeys_popup.show_help,
        {description = "show help", group = "awesome"}),
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
        {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift" }, "x", function() xrandr.xrandr() end,
        {description = "Setup xrandr", group = "awesome"}),
    -- }}}

    -- {{{ Hotkeys Keys group
    awful.key({ modkey }, "l", function ()
        awesome.emit_signal("service:power:main:action:lock")
    end,
        {description = "lock screen", group = "hotkeys"}),
    awful.key({ modkey }, "c", function () awful.spawn.with_shell("xsel | xsel -i -b") end,
        {description = "copy terminal to gtk", group = "hotkeys"}),
    awful.key({ modkey }, "v", function () awful.spawn.with_shell("xsel -b | xsel") end,
        {description = "copy gtk to terminal", group = "hotkeys"}),
    awful.key({ }, "Print", function() awful.spawn.easy_async_with_shell("flameshot gui", function ( _ ) end) end,
        {description = "take a screenshot", group = "hotkeys"}),
    awful.key({ }, "XF86MonBrightnessUp", function () services.brightness:inc(5) end,
        {description = "+10%", group = "hotkeys"}),
    awful.key({ }, "XF86MonBrightnessDown", function () services.brightness:dec(5) end,
        {description = "-10%", group = "hotkeys"}),
    awful.key({ }, "XF86AudioRaiseVolume",
        function ()
            awesome.emit_signal('service:volume:alsa:main:Raise', 1)
        end,
        {description = "volume up", group = "hotkeys"}),
    awful.key({ }, "XF86AudioLowerVolume",
        function ()
            awesome.emit_signal('service:volume:alsa:main:Lower', 1)
        end,
        {description = "volume down", group = "hotkeys"}),
    awful.key({ }, "XF86AudioMute",
        function ()
            awesome.emit_signal('service:volume:alsa:main:Mute')
        end,
        {description = "toggle mute", group = "hotkeys"}),
    --}}}

    -- {{{ Launcher Keys group
    awful.key({ modkey }, "q", function () awful.spawn(browser) end,
        {description = "run browser", group = "launcher"}),
    awful.key({ modkey }, "a", function () awful.spawn(gui_editor) end,
        {description = "run gui editor", group = "launcher"}),
    awful.key({ modkey }, "Return", function () awful.spawn(terminal) end,
        {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey }, "d", function ()
            awful.spawn.spawn("rofi -show-icons true -combi-modi drun -show combi -modi combi")
        end,
        {description = "show rofi", group = "launcher"}),
    -- }}}

    -- {{{ Tag Keys group
    awful.key({ modkey }, "Up", function () lain.util.tag_view_nonempty(-1) end,
        {description = "view  previous nonempty", group = "tag"}),
    awful.key({ modkey }, "Down", function () lain.util.tag_view_nonempty(1) end,
        {description = "view  previous nonempty", group = "tag"}),
    -- }}}

    -- {{{ Screen Keys group
    awful.key({ modkey }, "Left", function ()
        awful.screen.focus_bydirection("left")
    end, {description = "focus previous screen", group = "screen"}),
    awful.key({ modkey }, "Right", function ()
        awful.screen.focus_bydirection("right")
    end, {description = "focus next", group = "screen"}),
    awful.key({ modkey, "Shift" }, "Left", function ()
        client.focus:move_to_screen (client.focus.screen.index-1)
    end, {description = "move client to previous screen", group = "screen"}),
    awful.key({ modkey, "Shift" }, "Right", function ()
        client.focus:move_to_screen (client.focus.screen.index+1)
    end, {description = "move client to next", group = "screen"})
    -- }}}
)

-- {{{ Client Keys group
clientkeys = my_table.join(
    awful.key({ modkey }, "Tab",
        function (c)
            if client.focus then
                awful.titlebar.toggle(c)
            end
        end,
        {description = "titlebar toggle", group = "client"}),
    awful.key({ altkey }, "Tab",
        function ()
            if cycle_prev then
                awful.client.focus.byidx(1)
                if client.focus then
                    client.focus:raise()
                end
            end
        end,
        {description = "go forth", group = "client"}),
    awful.key({ modkey }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift" }, "q", function (c) c:kill() end,
        {description = "close", group = "client"}),
    awful.key({ modkey, "Shift" }, "space", awful.client.floating.toggle,
        {description = "toggle floating", group = "client"})
)
--}}}

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move
    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}
    end
    globalkeys = my_table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local curr_screen = awful.screen.focused()
                        local curr_tag = curr_screen.tags[i]
                        if curr_tag then
                           curr_tag:view_only()
                        end
                  end,
                  descr_view),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local curr_screen = awful.screen.focused()
                      local curr_tag = curr_screen.tags[i]
                      if curr_tag then
                         awful.tag.viewtoggle(curr_tag)
                      end
                  end,
                  descr_toggle),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local curr_tag = client.focus.screen.tags[i]
                          if curr_tag then
                              client.focus:move_to_tag(curr_tag)
                          end
                     end
                  end,
                  descr_move)
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false
     }
    },

    -- Dialogs
    { rule_any = { type = { "dialog", "normal" } },
        properties = { titlebars_enabled = true },
        callback = function (c)
            awful.placement.centered(c,nil)
        end
    },

    -- Set Firefox to always map on the first tag on screen 1.
    { rule = { class = "Firefox" },
      properties = { screen = 1, tag = awful.util.tagnames[1] } },

    { rule = { class = "Gimp", role = "gimp-image-window" },
          properties = { maximized = true } },
    -- floating
    { rule_any = {
            class = {
                "Blueman-manager",
                "emustudio-main-Main",
                "gcr-prompter", "Gcr-prompter",
                "gnome-calculator", "Gnome-calculator",
            },
            name = {
                "Picture in picture",
                "Execute File",
                "Open Folder",
            },
        },
        properties = { floating = true },
        callback = function (c)
            awful.placement.centered(c,nil)
        end
    },
    -- JetBrains: Sub menu floating
    { rule_any = {
        instance = {
            "jetbrains-webstorm",
            "jetbrains-goland",
            "jetbrains-idea",
            "jetbrains-phpstorm",
            "jetbrains-pycharm-ce",
            "jetbrains-pycharm",
            "jetbrains-rubymine",
        }, },
        properties = {
            floating = true,
            titlebars_enabled = false,
        },
        callback = function (c)
            awful.titlebar.hide(c)
            awful.placement.next_to_mouse(c)
            awful.placement.no_offscreen(c, {honor_workarea = true, margins = 5})
        end
    },
    -- pcmanfm
    { rule = { class = "pcmanfm", name = "Copying files" },
        properties = { floating = true },
        callback = function (c)
            awful.placement.centered(c,nil)
        end
    },
    -- "Xephyr", "Xephyr"
    { rule_any = { class = { "Xephyr", "Xephyr" }, },
        properties = {
            floating = false,
            maximized = true,
        },
    },
    -- Zenity
    { rule_any = { class = { "zenity", "Zenity" }, },
        properties = {
            floating = false,
            maximized = true,
        },
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = my_table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 2, function() c:kill() end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {size = dpi(16)}) : setup {
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
    awful.titlebar.hide(c)
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = vi_focus})
end)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)

client.connect_signal("property::floating", function (c)
    if c.floating then
        awful.titlebar.show(c)
    else
        awful.titlebar.hide(c)
    end
end)
-- }}}
