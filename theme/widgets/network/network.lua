-- network

local wibox = require("wibox")
local lain = require("lain")
local markup = lain.util.markup


init = function ( theme )
    theme.widget_net        = theme.dir .. "/widgets/network/icons/net.png"
    theme.widget_net_wired  = theme.dir .. "/widgets/network/icons/net_wired.png"
    local _icon = wibox.widget.imagebox(theme.widget_net)
    local _widget = wibox.widget {
        _icon,
        value = 30,
        min_value = 30,
        max_value = 67,
        thickness = 1,
        border_width = 0,
        bg = theme.bg_normal,
        colors = {'#ffffff'},
        start_angle = 0.5 * math.pi,
        visible = false,
        widget = wibox.container.arcchart,
    }
    lain.widget.net {
        notify = "off",
        wifi_state = "on",
        eth_state = "on",
        settings = function()
            _widget.visible = true
            local eth0 = net_now.devices.eth0
            if eth0 then
                if eth0.ethernet then
                    _icon:set_image(theme.widget_net_wired)
                end
            end
            local wlan0 = net_now.devices.wlp2s0
            if wlan0 then
                if wlan0.wifi then
                    _widget.value = 0 - wlan0.signal
                end
            end
        end
    }
    return _widget
end

return init
