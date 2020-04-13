-- power

local awful = require("awful")
local wibox = require("wibox")
local lain = require("lain")
local gears = require("gears")
local dpi   = require("beautiful.xresources").apply_dpi

init = function ( theme, screen )
    theme.widget_power_menu = theme.dir .. "/widgets/power/icons/power_menu.png"
    theme.widget_power_off = theme.dir .. "/widgets/power/icons/power_off.png"
    theme.widget_reload_awesome = theme.dir .. "/widgets/power/icons/reload_awesome.png"
    theme.widget_restart = theme.dir .. "/widgets/power/icons/restart.png"
    theme.widget_sleep = theme.dir .. "/widgets/power/icons/sleep.png"
    theme.widget_quit_awesome = theme.dir .. "/widgets/power/icons/exit.png"
    local _icon = wibox.widget.imagebox(theme.widget_power_menu)
    local _popup = wibox{
        widget = wibox.widget {
            {
                {
                    {
                        image  = theme.widget_reload_awesome,
                        resize = true,
                        widget = wibox.widget.imagebox
                    },
                    forced_width = dpi(48),
                    forced_height = dpi(48),
                    buttons = awful.util.table.join(
                        awful.button({}, 1, awesome.restart)
                    ),
                    widget  = wibox.container.margin
                },
                {
                    {
                        image  = theme.widget_quit_awesome,
                        resize = true,
                        widget = wibox.widget.imagebox
                    },
                    forced_width = dpi(48),
                    forced_height = dpi(48),
                    buttons = awful.util.table.join(
                        awful.button({}, 1, function ( )
                            awesome.quit()
                        end)
                    ),
                    widget  = wibox.container.margin
                },
                {
                    {
                        image  = theme.widget_sleep,
                        resize = true,
                        widget = wibox.widget.imagebox
                    },
                    forced_width = dpi(48),
                    forced_height = dpi(48),
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
                    forced_width = dpi(48),
                    forced_height = dpi(48),
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
                    forced_width = dpi(48),
                    forced_height = dpi(48),
                    buttons = awful.util.table.join(
                        awful.button({}, 1, function ( )
                            awful.spawn.with_shell("systemctl poweroff")
                        end)
                    ),
                    widget  = wibox.container.margin
                },
                spacing = dpi(50),
                layout = wibox.layout.fixed.horizontal,
            },
            margins = dpi(50),
            widget  = wibox.container.margin
        },
        ontop = true,
        opacity = 0.5,
        x = 0, y = 0,
        width = screen.geometry.width,
        height = screen.geometry.height,
        visible = false,
        bg = theme.bg_normal,
        fg = theme.fg_normal,
    }
    _icon:buttons(awful.util.table.join(
        awful.button({}, 1, function ( )
            _popup.visible = not _popup.visible
        end)
    ))
    _popup:buttons(awful.util.table.join(
        awful.button({}, 1, function ( )
            _popup.visible = false
        end),
        awful.button({}, 3, function ( )
            _popup.visible = false
        end)
    ))
    return _icon
end

return init
