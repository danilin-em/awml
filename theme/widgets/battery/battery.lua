-- battery

local awful = require("awful")
local wibox = require("wibox")
local lain = require("lain")
local markup = lain.util.markup

local color = function ( perc )
    local hex = '#ffffff'
    if tonumber(perc) <= 10 then
        hex = '#FF0000'
    elseif tonumber(perc) <= 25 then
        hex = '#FF7F00'
    elseif tonumber(perc) <= 35 then
        hex = '#FFFF00'
    elseif tonumber(perc) <= 45 then
        hex = '#7FFF00'
    elseif tonumber(perc) <= 50 then
        hex = '#00FF00'
    end
    return hex
end

init = function ( theme, panel )
    theme.widget_battery = theme.dir .. "/widgets/battery/icons/battery.png"
    theme.widget_ac = theme.dir .. "/widgets/battery/icons/ac.png"
    local _value = 0
    local _icon = wibox.widget.imagebox(theme.widget_battery)
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
    awful.tooltip {
        objects = { _widget },
        align = "bottom_left",
        timer_function = function()
            return "Battery: " .. _value .. "%"
        end,
    }
    lain.widget.bat({
        notify = "off",
        timeout = 5,
        settings = function()
            if bat_now.status and bat_now.status ~= "N/A" then
                _icon:set_image(theme.widget_battery)
                _value = bat_now.perc
                _widget.value = bat_now.perc
                _widget.colors = {color(bat_now.perc)}
                if bat_now.ac_status == 1 then
                    _icon:set_image(theme.widget_ac)
                    _widget.colors = {'#ffffff'}
                end
            end
        end
    })
    return _widget
end

return init
