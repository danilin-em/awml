-- keyboardlayout
-- Keyboard map indicator and switcher

local wibox = require("wibox")
local awful = require("awful")

local _keyboardlayout = awful.widget.keyboardlayout.new()
local _icon = wibox.widget.imagebox(nil)

local update_icon = function ( theme )
    local i = awesome.xkb_get_layout_group() -- TODO: Fix xkb layout name getter
    if _keyboardlayout._layout[i] == "us" then
        _icon:set_image(theme.widget_keyboardlayout_ru)
    else
        _icon:set_image(theme.widget_keyboardlayout_en)
    end
end

init = function ( theme )
    theme.widget_keyboardlayout_ru = theme.dir .. "/widgets/keyboardlayout/icons/indicator-keyboard-Ru.svg"
    theme.widget_keyboardlayout_en = theme.dir .. "/widgets/keyboardlayout/icons/indicator-keyboard-En.svg"
    update_icon(theme)
    local _widget = wibox.widget {
        _icon,
        layout  = wibox.layout.align.horizontal
    }
    _widget:buttons(awful.util.table.join(
        awful.button({}, 1, function ()
            _keyboardlayout.next_layout()
        end)
    ))
    awesome.connect_signal("xkb::map_changed", function ()
        update_icon(theme)
    end)
    awesome.connect_signal("xkb::group_changed", function ()
        update_icon(theme)
    end);
    return _widget
end

return init
