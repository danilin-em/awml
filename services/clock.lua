-- service clock
local awesome = awesome

local watch = require("awful.widget.watch")

local default = {
    id = 'main',
    timeout = 1,
}

return function ( args )
    args = args or {}
    args.id = tostring(args.id or default.id)
    args.timeout = tonumber(args.timeout or default.timeout)
    local signal = 'service:clock:'..args.id
    local service = watch("true", args.timeout, function(_, stdout)
        local time = os.date("!*t")
        awesome.emit_signal(signal..':time', time)
    end)
    awesome.emit_signal(signal..':init', service)
    return service
end
