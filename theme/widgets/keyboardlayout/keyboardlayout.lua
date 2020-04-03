-- keyboardlayout
-- Keyboard map indicator and switcher

local wibox = require("wibox")
local awful = require("awful")

init = function ( theme )
    local _widget = wibox.widget {
        {
            widget = awful.widget.keyboardlayout
        },
        halign = "center",
        valign = "center",
        forced_width = 23,
        layout = wibox.container.place,
    }
    return wibox.widget {
        _widget,
        layout  = wibox.layout.align.horizontal
    }
end

return init
