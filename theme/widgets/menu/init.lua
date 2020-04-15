-- menu

local awful = require("awful")
local wibox = require("wibox")

local init = function ( theme )
    theme.widget_menu = theme.dir .. "/widgets/menu/menu.png"
    local _icon = wibox.widget.imagebox(theme.widget_menu)
    local _widget = wibox.widget {
        _icon,
        widget = wibox.container.margin,
    }
    _widget:buttons(awful.util.table.join(
        awful.button({ }, 1, function ()
            awful.spawn.easy_async_with_shell("rofi -show-icons true -combi-modi drun -show combi -modi combi", function(_) end)
        end)
    ))
    return _widget
end

return init
