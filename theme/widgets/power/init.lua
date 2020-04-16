-- power

local awful = require("awful")
local wibox = require("wibox")

return function ( theme, screen )
    theme.widget_power_power_menu = theme.dir .. "/widgets/power/icons/power_menu.png"
    theme.widget_power_power_off = theme.dir .. "/widgets/power/icons/power_off.png"
    theme.widget_power_reload_awesome = theme.dir .. "/widgets/power/icons/reload_awesome.png"
    theme.widget_power_restart = theme.dir .. "/widgets/power/icons/restart.png"
    theme.widget_power_sleep = theme.dir .. "/widgets/power/icons/sleep.png"
    theme.widget_power_quit_awesome = theme.dir .. "/widgets/power/icons/exit.png"
    theme.widget_power_lock = theme.dir .. "/widgets/power/icons/lock.png"
    local button = function ( title, image, buttons )
        local margin = 20
        local background = wibox.container.background(
            wibox.container.margin(
                wibox.layout.fixed.vertical(
                    wibox.widget.imagebox(image, false),
                    wibox.container.place(wibox.widget.textbox(title))
                ),
            margin, margin, margin, margin)
        )
        background:connect_signal('mouse::enter', function ( curr )
            curr.bg = theme.bg_focus
        end)
        background:connect_signal('mouse::leave', function ( curr )
            curr.bg = theme.bg_normal
        end)
        background.bg = theme.bg_normal
        background:buttons(buttons)
        return wibox.container.place(background)
    end
    local _icon = wibox.container.background(wibox.widget.imagebox(theme.widget_power_power_menu))
    _icon.bg = theme.bg_normal
    local _popup = wibox{
        widget = wibox.widget {
            button('Reload Awesome', theme.widget_power_reload_awesome, awful.util.table.join(
                awful.button({}, 1, awesome.restart)
            )),
            button('Lock', theme.widget_power_lock, awful.util.table.join(
                awful.button({}, 1, function ( )
                    awful.spawn.with_shell("dm-tool lock") -- TODO: Use global lock command. Linked by #23
                end)
            )),
            button('Quit', theme.widget_power_quit_awesome, awful.util.table.join(
                awful.button({}, 1, function ( )
                    awesome.quit()
                end)
            )),
            button('Sleep', theme.widget_power_sleep, awful.util.table.join(
                awful.button({}, 1, function ( )
                    awful.spawn.with_shell("systemctl suspend") -- TODO: Store this actions in to Power Service
                end)
            )),
            button('Restart', theme.widget_power_restart, awful.util.table.join(
                awful.button({}, 1, function ( )
                    awful.spawn.with_shell("systemctl reboot") -- TODO: Store this actions in to Power Service
                end)
            )),
            button('Power Off', theme.widget_power_power_off, awful.util.table.join(
                awful.button({}, 1, function ( )
                    awful.spawn.with_shell("systemctl poweroff") -- TODO: Store this actions in to Power Service
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
    if theme.widget_power_popup_use_wallpaper then
        _popup.bgimage = theme.wallpaper
    end
    return _icon
end
