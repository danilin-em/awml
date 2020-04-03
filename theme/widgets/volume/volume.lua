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
    theme.volume = lain.widget.alsa({
        settings = function()
            _value = volume_now
            _widget.value = volume_now.level
            if volume_now.status == "off" then
                _icon:set_image(theme.widget_vol_mute)
                _widget.colors = {'#DDDDFF'}
            else
                _icon:set_image(theme.widget_vol)
                _widget.colors = {'#ffffff'}
            end
        end
    })
    awful.tooltip {
        objects = { _widget },
        align = "bottom_left",
        timer_function = function()
            return "Volume: " .. _value.status .. " " .. _value.level .. "%"
        end,
    }
    _widget:buttons(awful.util.table.join(
        awful.button({}, 1, function ()
             awful.spawn("amixer -D pulse set Master 1+ toggle")
             theme.volume.update()
        end),
        awful.button({}, 4, function ()
            awful.spawn("amixer -D pulse set Master 1%+")
            theme.volume.update()
        end),
        awful.button({}, 5, function ()
            awful.spawn("amixer -D pulse set Master 5%-")
            theme.volume.update()
        end)
    ))
    return _widget
end

return init
