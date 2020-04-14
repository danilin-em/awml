-- volume

local awful = require("awful")
local wibox = require("wibox")
local lain = require("lain")
local markup = lain.util.markup

init = function ( theme )
    theme.widget_vol      = theme.dir .. "/widgets/volume/icons/vol.png"
    theme.widget_vol_mute = theme.dir .. "/widgets/volume/icons/vol_mute.png"
    local _value = {}
    local _icon = wibox.widget.imagebox(theme.widget_vol)
    local _widget = wibox.widget {
        _icon,
        value = 0,
        min_value = 0,
        max_value = 100,
        thickness = 1,
        border_width = 0,
        bg = theme.bg_normal,
        colors = {'#ffffff'},
        start_angle = 0.5 * math.pi,
        widget = wibox.container.arcchart,
    }
    awesome.connect_signal('service:volume:alsa:value', function ( volume_now )
        _value = volume_now
        _widget.value = volume_now.level
        if volume_now.status == "off" then
            _icon:set_image(theme.widget_vol_mute)
            _widget.colors = {'#DDDDFF'}
        else
            _icon:set_image(theme.widget_vol)
            _widget.colors = {'#ffffff'}
        end
    end)
    awful.tooltip {
        objects = { _widget },
        align = "bottom_left",
        timer_function = function()
            return "Volume: " .. tostring(_value.status) .. " " .. tostring(_value.level) .. "%"
        end,
    }
    _widget:buttons(awful.util.table.join(
        awful.button({}, 1, function ()
             awful.spawn("amixer -D pulse set Master 1+ toggle")
             awesome.emit_signal('service:volume:alsa:update')
        end),
        awful.button({}, 4, function ()
            awful.spawn("amixer -D pulse set Master 1%+")
            awesome.emit_signal('service:volume:alsa:update')
        end),
        awful.button({}, 5, function ()
            awful.spawn("amixer -D pulse set Master 5%-")
            awesome.emit_signal('service:volume:alsa:update')
        end)
    ))
    return _widget
end

return init
