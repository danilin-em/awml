-- network

local wibox = require("wibox")
local lain = require("lain")
local markup = lain.util.markup


init = function ( theme )
    theme.widget_net        = theme.dir .. "/widgets/network/icons/net.png"
    theme.widget_net_wired  = theme.dir .. "/widgets/network/icons/net_wired.png"
    local _icon = wibox.widget.imagebox(theme.widget_net)
    local _widget = lain.widget.net {
        notify = "off",
        wifi_state = "on",
        eth_state = "on",
        settings = function()
            local eth0 = net_now.devices.eth0
            if eth0 then
                if eth0.ethernet then
                    eth_icon:set_image(theme.widget_net_wired)
                else
                    eth_icon:set_image()
                end
            end
            local wlan0 = net_now.devices.wlp2s0
            if wlan0 then
                if wlan0.wifi then
                    local signal = wlan0.signal
                    widget:set_markup(markup.font(theme.font, string.format("%03d", signal) .. " dBm"))
                else
                    widget:set_markup(markup.font(theme.font, "X"))
                end
            end
        end
    }
    return wibox.widget {
        _icon,
        _widget,
        layout  = wibox.layout.align.horizontal
    }
end

return init
