-- service screen
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
    local signal = 'service:screen:'..args.id
    -- Service
    local service = {
        widget = watch("xrandr -q --current", args.timeout, function(_, _)
            awesome.emit_signal(signal..':watch', nil)
        end),
    }
    function service.auto( )
        easy_async("xrandr --auto", function ( _ )
            -- body
        end)
    end
    -- Connect Signals
    awesome.connect_signal(signal..':watch', function()
        awesome.emit_signal(signal..':auto')
        -- body
    end)
    awesome.connect_signal(signal..':auto', function()
        -- body
        service:auto()
    end)
    -- Init Signal
    awesome.emit_signal(signal..':init', service)
    return service
end
