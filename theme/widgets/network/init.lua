-- network

local awful = require("awful")
local wibox = require("wibox")
local lain = require("lain")
local markup = lain.util.markup


init = function ( theme )
    theme.widget_net_wifi     = theme.dir .. "/widgets/network/icons/wifi.png"
    theme.widget_net_wifi_off = theme.dir .. "/widgets/network/icons/wifi_off.png"
    local _value = ""
    local _icon = wibox.widget.imagebox(theme.widget_net_wifi_off)
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
    awful.tooltip {
        objects = { _widget },
        align = "bottom_left",
        timer_function = function()
            return _value
        end,
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
                    -- TODO: Wired icon
                end
            end
            local wlan0 = net_now.devices.wlp2s0
            if wlan0 then
                if wlan0.wifi then
                    _value = wlan0.signal .. " dBm"
                    _widget.value = 0 - wlan0.signal
                    _icon:set_image(theme.widget_net_wifi)
                end
            end
        end
    }
    return _widget
end

return init
