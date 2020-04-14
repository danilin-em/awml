-- brightness

local awful = require("awful")
local wibox = require("wibox")
local lain = require("lain")

local calc_brightness = function ( )
    local min_brightness = 5
    local max_brightness = 100
    local max_birghtness_time = 6
    local hour = tonumber(os.date("%H.%M"))
    return min_brightness + ((hour + max_birghtness_time) % 24) * (max_brightness - min_brightness) / 24
end

init = function ( theme )
    theme.widget_brightness_auto = theme.dir .. "/widgets/brightness/icons/brightness_auto.png"
    theme.widget_brightness_high = theme.dir .. "/widgets/brightness/icons/brightness_high.png"
    theme.widget_brightness_medium = theme.dir .. "/widgets/brightness/icons/brightness_medium.png"
    theme.widget_brightness_low = theme.dir .. "/widgets/brightness/icons/brightness_low.png"
    local _icon = wibox.widget.imagebox(theme.widget_brightness_low)
    local _brightness = wibox.widget {
        _icon,
        value = 0,
        auto_value = true,
        min_value = 0,
        max_value = 100,
        thickness = 1,
        border_width = 0,
        bg = theme.bg_normal,
        border_color = theme.bg_normal,
        colors = {theme._color_white},
        start_angle = 0.5 * math.pi,
        widget = wibox.container.arcchart,
    }
    function _brightness.update_auto_value( value )
        _brightness.auto_value = value
        awesome.emit_signal('service:brightness:sync', 'auto', value)
    end
    function _brightness.update_value( value )
        local set = function ( value )
            _brightness.value = value
            if _brightness.auto_value then
                _icon:set_image(theme.widget_brightness_auto)
                value = calc_brightness()
                awful.spawn.easy_async("xbacklight -set "..value, function (stdout) end)
            elseif value <= 30 then
                _icon:set_image(theme.widget_brightness_low)
            elseif value <= 60 then
                _icon:set_image(theme.widget_brightness_medium)
            else
                _icon:set_image(theme.widget_brightness_high)
            end
            _brightness.value = value
        end
        if value then
            set(value)
        else
            awful.spawn.easy_async('xbacklight -get', function(stdout)
                local value = tonumber(stdout) or 0
                set(value)
            end)
        end
    end
    awesome.connect_signal('service:brightness:value', function(value)
        _brightness.update_value(value)
    end)
    awesome.connect_signal('service:brightness:sync>auto', function(value)
        _brightness.auto_value = value
        _brightness.update_value(false)
    end)
    _brightness:buttons(awful.util.table.join(
        awful.button({}, 1, function ()
            _brightness.update_auto_value(not _brightness.auto_value)
            _brightness.update_value(false)
        end),
        awful.button({}, 4, function ()
            _brightness.update_auto_value(false)
            awful.spawn.easy_async("xbacklight -inc 5", function (stdout) 
                _brightness.update_value(false)
            end)
        end),
        awful.button({}, 5, function ()
            _brightness.update_auto_value(false)
            awful.spawn.easy_async("xbacklight -dec 5", function (stdout) 
                _brightness.update_value(false)
            end)
        end)
    ))
    return _brightness
end

return init

