-- service brightness
local awesome = awesome

local watch = require("awful.widget.watch")
local easy_async = require("awful.spawn").easy_async

local default = {
    id = 'main',
    timeout = 5
}

return function ( args )
    args = args or {}
    args.id = tostring(args.id or default.id)
    args.timeout = tonumber(args.timeout or default.timeout)
    local signal = 'service:brightness:'..args.id
    local service = watch("xbacklight -get", args.timeout, function(_, stdout)
        local value = tonumber(stdout) or 100
        awesome.emit_signal(signal..':value', value)
    end)
    function service.inc( self, value )
        easy_async('xbacklight -inc '.. tostring(value), function(stdout)
            easy_async('xbacklight -get', function(stdout)
                local value = tonumber(stdout) or 100
                awesome.emit_signal(signal..':value', value)
            end)
        end)
    end
    function service.dec( self, value )
        easy_async('xbacklight -dec '.. tostring(value), function(stdout)
            easy_async('xbacklight -get', function(stdout)
                local value = tonumber(stdout) or 100
                awesome.emit_signal(signal..':value', value)
            end)
        end)
    end
    awesome.connect_signal(signal..':sync', function(name, value)
        awesome.emit_signal(signal..':sync>'..tostring(name), value)
    end)
    awesome.emit_signal(signal..':init', service)
    return service
end
