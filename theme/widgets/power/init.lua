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
    function button( image, buttons )
        local x = wibox.container.place()
        x:setup({
            {
                image  = image,
                resize = false,
                widget = wibox.widget.imagebox
            },
            bg = theme.bg_normal,
            buttons = buttons,
            widget  = wibox.container.background
        })
        x:get_children()[1]:connect_signal('mouse::enter', function ( curr )
            curr.bg = theme.bg_focus
        end)
        x:get_children()[1]:connect_signal('mouse::leave', function ( curr )
            curr.bg = theme.bg_normal
        end)
        return x
    end
    local _icon = wibox.container.background(wibox.widget.imagebox(theme.widget_power_menu))
    _icon.bg = theme.bg_normal
    local _popup = wibox{
        widget = wibox.widget {
            button(theme.widget_reload_awesome, awful.util.table.join(
                awful.button({}, 1, awesome.restart)
            )),
            button(theme.widget_quit_awesome, awful.util.table.join(
                awful.button({}, 1, function ( )
                    awesome.quit()
                end)
            )),
            button(theme.widget_sleep, awful.util.table.join(
                awful.button({}, 1, function ( )
                    awful.spawn.with_shell("systemctl suspend")
                end)
            )),
            button(theme.widget_restart, awful.util.table.join(
                awful.button({}, 1, function ( )
                    awful.spawn.with_shell("systemctl reboot")
                end)
            )),
            button(theme.widget_power_off, awful.util.table.join(
                awful.button({}, 1, function ( )
                    awful.spawn.with_shell("systemctl poweroff")
                end)
            )),
            layout = wibox.layout.flex.horizontal,
        },
        id = 'popup',
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
    _icon:connect_signal('mouse::enter', function ( )
        _icon.bg = theme.bg_focus
    end)
    _icon:connect_signal('mouse::leave', function ( )
        _icon.bg = theme.bg_normal
    end)
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
