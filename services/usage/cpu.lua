-- service usage cpu

local awesome = awesome

local cpu = require("lain.widget.cpu")

local default = {
    id = 'main',
    timeout = 2,
}

return function ( args )
    args = args or {}
    args.id = tostring(args.id or default.id)
    args.timeout = tonumber(args.timeout or default.timeout)
    local signal = 'service:usage:cpu:'..args.id
    local service = cpu({
        timeout = args.timeout,
        settings = function()
            awesome.emit_signal(signal..':value', cpu_now)
        end
    })
    awesome.emit_signal(signal..':init', service)
    awesome.connect_signal(signal..':update', service.update)
    return service
end

