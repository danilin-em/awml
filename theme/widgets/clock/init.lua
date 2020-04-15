-- clock
local wibox = require("wibox")
local tooltip = require("awful.tooltip")

return function ( theme ) -- luacheck: no unused
    -- Textclock
    local textclock = wibox.widget.textclock('%H:%M', 30)
    local _widget = wibox.widget {
        textclock,
        margins = 0,
        widget = wibox.container.margin,
    }
    tooltip {
        objects = { _widget },
        align = "bottom_left",
        timer_function = function()
            return os.date('%Y-%m-%d\n%A %B')
        end,
    }
    return _widget
end
