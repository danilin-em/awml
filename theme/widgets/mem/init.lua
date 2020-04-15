-- mem
-- Memory Usage
local wibox = require("wibox")
local awful = require("awful")

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

return function ( theme )
    theme.widget_mem = theme.dir .. "/widgets/mem/mem.png"
    local _value = {}
    local _icon = wibox.widget.imagebox(theme.widget_mem)
    local _cpu = wibox.widget {
        _icon,
        value = 0,
        min_value = 0,
        max_value = 100,
        thickness = 1,
        border_width = 0,
        bg = theme.bg_normal,
        border_color = theme.bg_normal,
        colors = {'#ffffff'},
        start_angle = 0.5 * math.pi,
        widget = wibox.container.arcchart,
    }
    local _mem = wibox.widget {
        _cpu,
        value = 0,
        min_value = 0,
        max_value = 100,
        thickness = 1,
        border_width = 0,
        bg = theme.bg_normal,
        border_color = theme.bg_normal,
        colors = {'#ffffff'},
        start_angle = 0.5 * math.pi,
        widget = wibox.container.arcchart,
    }
    awful.tooltip {
        objects = { _mem },
        align = "bottom_left",
        timer_function = function()
            return "Memory used: ".. tostring(_value.used) .. " (MiB)\n"
                .. "Swap memory used: ".. tostring(_value.swapused) .. " (MiB)\n"
                .. "Memory percentage: ".. tostring(_value.perc) .. "%"
        end,
    }
    awesome.connect_signal('service:usage:cpu:main:value', function ( cpu_now )
        _cpu.value = cpu_now.usage
        _cpu.colors = {color(cpu_now.usage)}
    end)
    awesome.connect_signal('service:usage:mem:main:value', function ( mem_now )
        _value = mem_now
        _mem.value = mem_now.perc
        _mem.colors = {color(mem_now.perc)}
    end)
    return _mem
end
