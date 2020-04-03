-- volume

local awful = require("awful")
local wibox = require("wibox")
local lain = require("lain")
local markup = lain.util.markup

init = function ( theme )
    theme.widget_vol      = theme.dir .. "/widgets/volume/icons/vol.png"
    theme.widget_vol_low  = theme.dir .. "/widgets/volume/icons/vol_low.png"
    theme.widget_vol_mute = theme.dir .. "/widgets/volume/icons/vol_mute.png"
    theme.widget_vol_no   = theme.dir .. "/widgets/volume/icons/vol_no.png"
    local icon = wibox.widget.imagebox(theme.widget_vol)
    theme.volume = lain.widget.alsa({
        settings = function()
            if volume_now.status == "off" then
                icon:set_image(theme.widget_vol_mute)
            elseif tonumber(volume_now.level) == 0 then
                icon:set_image(theme.widget_vol_no)
            elseif tonumber(volume_now.level) <= 50 then
                icon:set_image(theme.widget_vol_low)
            else
                icon:set_image(theme.widget_vol)
            end
            widget:set_markup(markup.font(theme.font, "" .. string.format("%03d", volume_now.level) .. "% "))
        end
    })
    theme.volume.widget:buttons(awful.util.table.join(
        awful.button({}, 1, function ()
             awful.util.spawn("amixer set Master 1+ toggle")
             theme.volume.update()
        end),
        awful.button({}, 4, function ()
            awful.util.spawn("amixer set Master 1%+")
            theme.volume.update()
        end),
        awful.button({}, 5, function ()
            awful.util.spawn("amixer set Master 5%-")
            theme.volume.update()
        end)
    ))
    return wibox.widget {
        icon,
        theme.volume.widget,
        layout  = wibox.layout.align.horizontal
    }
end
return init
