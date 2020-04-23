-- service clock
local awesome = awesome

local watch = require("awful.widget.watch")
local gears_timer = require("gears.timer")

local default = {
    id = 'main',
    timeout = 1,
}

return function ( args )
    args = args or {}
    args.id = tostring(args.id or default.id)
    args.timeout = tonumber(args.timeout or default.timeout)
    local signal = 'service:clock:'..args.id
    local service = watch("true", args.timeout, function(_, _)
        local time = os.date("!*t")
        awesome.emit_signal(signal..':time', time)
    end)
    service.timers = {}
    awesome.connect_signal(signal..':timer:new', function ( props )
        props.id = tostring(props.id) or default.id
        if not service.timers[props.id] then
            service.timers[props.id] = gears_timer(props)
        end
        awesome.emit_signal(signal..':timer:'..props.id..':init', service.timers[props.id])
    end)
    awesome.emit_signal(signal..':init', service)
    return service
end
