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
    local _value = {}
    local _icon = wibox.widget.imagebox(theme.widget_battery)
    local _battery = wibox.widget {
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
    local _brightness = wibox.widget {
        _battery,
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
    awful.widget.watch("xbacklight -get", 5, function(widget, stdout)
        if tonumber(stdout) then
            _brightness.value = tonumber(stdout)
        end
    end)
    awful.tooltip {
        objects = { _battery },
        align = "bottom_left",
        timer_function = function()
            if not _value.perc then
                _value.perc = 0
            end
            return "Battery: " .. _value.perc .. "%"
        end,
    }
    lain.widget.bat({
        notify = "off",
        timeout = 5,
        settings = function()
            if bat_now.status and bat_now.status ~= "N/A" then
                _icon:set_image(theme.widget_battery)
                _value = bat_now
                _battery.value = bat_now.perc
                _battery.colors = {color(bat_now.perc)}
                if bat_now.ac_status == 1 then
                    _icon:set_image(theme.widget_ac)
                    _battery.colors = {'#ffffff'}
                end
            end
        end
    })
    _brightness:buttons(awful.util.table.join(
        awful.button({}, 1, function ()
            awful.spawn.easy_async("xbacklight -set 50", function ( )
                awful.spawn.easy_async('xbacklight -get', function(stdout)
                    _brightness.value = tonumber(stdout)
                end)
            end)
        end),
        awful.button({}, 4, function ()
            awful.spawn.easy_async("xbacklight -inc 5", function ( )
                awful.spawn.easy_async('xbacklight -get', function(stdout)
                    _brightness.value = tonumber(stdout)
                end)
            end)
        end),
        awful.button({}, 5, function ()
            awful.spawn.easy_async("xbacklight -dec 5", function ( )
                awful.spawn.easy_async('xbacklight -get', function(stdout)
                    _brightness.value = tonumber(stdout)
                end)
            end)
        end)
    ))
    return _brightness
end

return init
