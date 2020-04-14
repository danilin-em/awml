-- brightness
local awesome = awesome

local awful = require("awful")
local wibox = require("wibox")

init = function ( theme )
    theme.widget_brightness_auto = theme.dir .. "/widgets/brightness/icons/brightness_auto.png"
    theme.widget_brightness_high = theme.dir .. "/widgets/brightness/icons/brightness_high.png"
    theme.widget_brightness_medium = theme.dir .. "/widgets/brightness/icons/brightness_medium.png"
    theme.widget_brightness_low = theme.dir .. "/widgets/brightness/icons/brightness_low.png"
    local _brightness = wibox.widget {
        wibox.widget.imagebox(theme.widget_brightness_low),
        value = 0,
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
    function _brightness.update( self, props )
        self.value = props.value
        if props:is_auto() then
            self._private.widget:set_image(theme.widget_brightness_auto)
        elseif props.value <= 30 then
            self._private.widget:set_image(theme.widget_brightness_low)
        elseif props.value <= 60 then
            self._private.widget:set_image(theme.widget_brightness_medium)
        else
            self._private.widget:set_image(theme.widget_brightness_high)
        end
    end
    awesome.connect_signal('service:brightness:main:props', function(props)
        _brightness:update(props)
    end)
    _brightness:buttons(awful.util.table.join(
        awful.button({}, 1, function ()
            awesome.emit_signal('service:brightness:main:auto_toggle')
        end),
        awful.button({}, 4, function ()
            awesome.emit_signal('service:brightness:main:inc', 5)
        end),
        awful.button({}, 5, function ()
            awesome.emit_signal('service:brightness:main:dec', 5)
        end)
    ))
    return _brightness
end

return init

