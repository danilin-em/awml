-- mem
-- Memory Usage
local wibox = require("wibox")
local awful = require("awful")
local lain = require("lain")
local markup = lain.util.markup

local color = function ( perc )
    local hex = '#ffffff'
    if tonumber(perc) > 85 then
        hex = '#FF0000'
    elseif tonumber(perc) > 75 then
        hex = '#FF7F00'
    elseif tonumber(perc) > 70 then
        hex = '#FFFF00'
    end
    return hex
end

init = function ( theme )
    theme.widget_mem = theme.dir .. "/widgets/mem/mem.png"
    local _value = {}
    local _icon = wibox.widget.imagebox(theme.widget_mem)
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
            return "Memory used: ".. _value.used .. " (MiB)\n" 
                .. "Swap memory used: ".. _value.swapused .. " (MiB)\n" 
                .. "Memory percentage: ".. _value.perc .. "%"
        end,
    }
    lain.widget.mem({
        settings = function()
            _value = mem_now
            _widget.value = mem_now.perc
            _widget.colors = {color(mem_now.perc)}
        end
    })
    return _widget
end

return init