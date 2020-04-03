-- battery

local wibox = require("wibox")
local lain = require("lain")
local markup = lain.util.markup

init = function ( theme )
    theme.widget_battery = theme.dir .. "/widgets/battery/icons/battery.png"
    theme.widget_battery_empty = theme.dir .. "/widgets/battery/icons/battery_empty.png"
    theme.widget_battery_low = theme.dir .. "/widgets/battery/icons/battery_low.png"
    local icon = wibox.widget.imagebox(theme.widget_battery)
    local widget = lain.widget.bat({
        notify = "off",
        settings = function()
            if bat_now.status and bat_now.status ~= "N/A" then
                if bat_now.ac_status == 1 then
                    icon:set_image(theme.widget_ac)
                elseif tonumber(bat_now.perc) == 100 then
                    icon:set_image(theme.widget_ac)
                elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
                    icon:set_image(theme.widget_battery_empty)
                elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
                    icon:set_image(theme.widget_battery_low)
                else
                    icon:set_image(theme.widget_battery)
                end
                widget:set_markup(markup.font(theme.font, " " .. string.format("%02d", bat_now.perc) .. "% "))
            else
                widget:set_markup(markup.font(theme.font, " AC "))
                icon:set_image(theme.widget_ac)
            end
        end
    })
    return wibox.widget {
        icon,
        widget,
        layout  = wibox.layout.align.horizontal
    }
end

return init
