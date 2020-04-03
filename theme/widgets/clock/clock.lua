-- clock
local awful = require("awful")
local wibox = require("wibox")
local lain = require("lain")
local markup = lain.util.markup

init = function ( theme )
    -- Textclock
    local _widget = awful.widget.watch(
        "date +'%a %d %b (%m) %R'", 60,
        function(widget, stdout)
            widget:set_markup(" " .. markup.font(theme.font, stdout))
        end
    )
    -- Calendar
    theme.cal = lain.widget.cal({
        attach_to = { _widget },
        notification_preset = {
            font = "Terminus 10",
            fg   = theme.fg_normal,
            bg   = theme.bg_normal
        }
    })
    return wibox.widget {
        _widget,
        layout  = wibox.layout.align.horizontal
    }
end
return init
