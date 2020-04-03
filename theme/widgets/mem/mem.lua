-- mem
-- Memury Usage
local wibox = require("wibox")
local awful = require("awful")
local lain = require("lain")
local markup = lain.util.markup

init = function ( theme )
    theme.widget_mem = theme.dir .. "/widgets/mem/mem.png"
    local icon = wibox.widget.imagebox(theme.widget_mem)
    local widget = lain.widget.mem({
        settings = function()
            widget:set_markup(markup.font(theme.font, " " .. string.format("%03d", mem_now.perc) .. "% "))
        end
    })
    return wibox.widget {
        icon,
        widget,
        layout  = wibox.layout.align.horizontal
    }
end

return init