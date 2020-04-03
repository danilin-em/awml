-- menu

local awful = require("awful")
local wibox = require("wibox")
local freedesktop = require("freedesktop")
local dpi = require("beautiful.xresources").apply_dpi

local init = function ( theme )
    theme.widget_menu = theme.dir .. "/widgets/menu/menu.png"
    local _icon = wibox.widget.imagebox(theme.widget_menu)
    local _widget = wibox.widget {
        _icon,
        layout  = wibox.layout.align.horizontal
    }
    _widget:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.util.mymainmenu:toggle() end)
    ))
    return _widget
end

return init
