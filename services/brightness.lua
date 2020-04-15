-- service brightness
local awesome = awesome

local watch = require("awful.widget.watch")
local easy_async = require("awful.spawn").easy_async
local dump = require("gears.debug").dump

local default = {
    id = 'main',
    timeout = 5
}

local calc_brightness = function ( )
    local min_brightness = 5
    local max_brightness = 100
    local max_birghtness_time = 6
    local hour = tonumber(os.date("%H.%M"))
    return min_brightness + ((hour + max_birghtness_time) % 24) * (max_brightness - min_brightness) / 24
end

return function ( args )
    args = args or {}
    args.id = tostring(args.id or default.id)
    args.timeout = tonumber(args.timeout or default.timeout)
    local signal = 'service:brightness:'..args.id
    -- Service
    local service = {
        widget = watch("xbacklight -get", args.timeout, function(_, stdout)
            local value = tonumber(stdout) or 100
            awesome.emit_signal(signal..':watch', value)
        end),
        auto = false,
        value = 100,
    }
    function service.cmd( self, args )
        easy_async('xbacklight '.. tostring(args), function(stdout)
            easy_async('xbacklight -get', function(stdout)
                self.value = tonumber(stdout) or 100
                awesome.emit_signal(signal..':props', {
                    value = self.value,
                    auto = self.auto,
                })
            end)
        end)
    end
    function service.set( self, value )
        self:cmd('-set '..tostring(value))
    end
    function service.inc( self, value )
        self:set_auto(false)
        self:cmd('-inc '..tostring(value))
    end
    function service.dec( self, value )
        self:set_auto(false)
        self:cmd('-dec '..tostring(value))
    end
    function service.set_auto( self, value )
        self.auto = value
        awesome.emit_signal(signal..':watch', self.value)
    end
    function service.is_auto( self )
        return self.auto
    end
    function service.auto_toggle( self )
        self:set_auto(not self:is_auto())
    end
    -- Connect Signals
    awesome.connect_signal(signal..':watch', function(value)
        service.value = value
        if service.auto then
            service.value = calc_brightness()
            service:set(service.value)
        end
        awesome.emit_signal(signal..':props', {
            value = service.value,
            auto = service.auto,
        })
    end)
    awesome.connect_signal(signal..':auto_toggle', function()
        service:auto_toggle()
    end)
    awesome.connect_signal(signal..':set', function(value)
        service:set(value)
    end)
    awesome.connect_signal(signal..':inc', function(value)
        service:inc(value)
    end)
    awesome.connect_signal(signal..':dec', function(value)
        service:dec(value)
    end)
    awesome.connect_signal(signal..':sync', function(name, value)
        awesome.emit_signal(signal..':sync>'..tostring(name), value)
    end)
    -- Init Signal
    awesome.emit_signal(signal..':init', service)
    return service
end
