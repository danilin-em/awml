-- network

local awful = require("awful")
local wibox = require("wibox")

init = function ( theme )
    theme.widget_net_wifi     = theme.dir .. "/widgets/network/icons/wifi.png"
    theme.widget_net_wifi_off = theme.dir .. "/widgets/network/icons/wifi_off.png"
    theme.widget_net_ethernet = theme.dir .. "/widgets/network/icons/ethernet.png"
    theme.widget_net_airplanemode = theme.dir .. "/widgets/network/icons/airplanemode.png"

    local _devices = wibox.widget{
        layout = wibox.layout.fixed.horizontal,
    }
    function _devices.create ( self, name, device )
        local icon = wibox.widget.imagebox(theme.widget_net_airplanemode)
        if device.wifi then
            icon = wibox.widget.imagebox(theme.widget_net_wifi)
        elseif device.ethernet then
            icon = wibox.widget.imagebox(theme.widget_net_ethernet)
        end
        local widget = wibox.widget {
            icon,
            bg = theme.bg_normal,
            visible = (device.state == "up"),
            widget = wibox.container.margin,
            -- Device props
            name = name,
            state = 'down',
        }
        awful.tooltip {
            objects = { widget },
            align = "bottom_left",
            timer_function = function()
                return name
            end,
        }
        function widget.update( self, device )
            if device.wifi then
                self._private.widget:set_image(theme.widget_net_wifi)
            elseif device.ethernet then
                self._private.widget:set_image(theme.widget_net_ethernet)
            end
            self.visible = (device.state == "up")
        end
        self:add(widget)
        return widget
    end
    function _devices.init ( self, name, device )
        local widget = nil
        for _, w in pairs(self._private.widgets) do
            if w.name == name then
                widget = w
                break
            end
        end
        if widget then
            widget:update(device)
        else
            self:create(name, device)
        end
    end
    awesome.connect_signal('service:network:main:value', function ( net_now )
        for name, device in pairs(net_now.devices) do
            _devices:init(name, device)
        end
    end)
    return _devices
end

return init
