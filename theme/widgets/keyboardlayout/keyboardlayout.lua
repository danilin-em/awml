-- keyboardlayout
-- Keyboard map indicator and switcher

local wibox = require("wibox")
local awful = require("awful")


return wibox.widget {
    {
        widget = awful.widget.keyboardlayout
    },
    halign = "center",
    valign = "center",
    forced_width = 23,
    layout = wibox.container.place,
}
