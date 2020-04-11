-- power

local awful = require("awful")
local wibox = require("wibox")
local lain = require("lain")
local gears = require("gears")

init = function ( theme, panel )
    theme.widget_power_menu = theme.dir .. "/widgets/power/icons/power_menu.png"
    theme.widget_power_off = theme.dir .. "/widgets/power/icons/power_off.png"
    theme.widget_reload_awesome = theme.dir .. "/widgets/power/icons/reload_awesome.png"
    theme.widget_restart = theme.dir .. "/widgets/power/icons/restart.png"
    theme.widget_sleep = theme.dir .. "/widgets/power/icons/sleep.png"
    local _icon = wibox.widget.imagebox(theme.widget_power_menu)
    local _popup = awful.popup {
        widget = {
            {
                {
                    {
                        image  = theme.widget_reload_awesome,
                        resize = true,
                        widget = wibox.widget.imagebox
                    },
                    margins = 5,
                    forced_width = 36,
                    forced_height = 36,
                    buttons = awful.util.table.join(
                        awful.button({}, 1, awesome.restart)
                    ),
                    widget  = wibox.container.margin
                },
                {
                    {
                        image  = theme.widget_sleep,
                        resize = true,
                        widget = wibox.widget.imagebox
                    },
                    margins = 5,
                    forced_width = 36,
                    forced_height = 36,
                    buttons = awful.util.table.join(
                        awful.button({}, 1, function ( )
                            awful.spawn.with_shell("systemctl suspend")
                        end)
                    ),
                    widget  = wibox.container.margin
                },
                {
                    {
                        image  = theme.widget_restart,
                        resize = true,
                        widget = wibox.widget.imagebox
                    },
                    margins = 5,
                    forced_width = 36,
                    forced_height = 36,
                    buttons = awful.util.table.join(
                        awful.button({}, 1, function ( )
                            awful.spawn.with_shell("systemctl reboot")
                        end)
                    ),
                    widget  = wibox.container.margin
                },
                {
                    {
                        image  = theme.widget_power_off,
                        resize = true,
                        widget = wibox.widget.imagebox
                    },
                    margins = 5,
                    forced_width = 36,
                    forced_height = 36,
                    buttons = awful.util.table.join(
                        awful.button({}, 1, function ( )
                            awful.spawn.with_shell("systemctl poweroff")
                        end)
                    ),
                    widget  = wibox.container.margin
                },
                layout = wibox.layout.fixed.vertical,
            },
            margins = 10,
            widget  = wibox.container.margin
        },
        hide_on_right_click = true,
        bg           = theme.bg_normal,
        fg           = theme.fg_normal,
        border_color = theme.border_normal,
        border_width = 1,
        placement    = awful.placement.top_right,
        shape        = gears.shape.partially_rounded_rect,
        ontop        = true,
        visible      = false,
    }
    _popup:bind_to_widget(_icon, 1)
    _popup:connect_signal('mouse::leave', function ( )
        _popup.visible = false
    end)
    return _icon
end

return init
