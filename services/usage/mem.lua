-- service usage mem

local awesome = awesome

local mem = require("lain.widget.mem")

local default = {
    id = 'main',
    timeout = 2,
}

return function ( args )
    args = args or {}
    args.id = tostring(args.id or default.id)
    args.timeout = tonumber(args.timeout or default.timeout)
    local signal = 'service:usage:mem:'..args.id
    local service = mem({
        timeout = args.timeout,
        settings = function()
            awesome.emit_signal(signal..':value', mem_now)
        end
    })
    awesome.emit_signal(signal..':init', service)
    awesome.connect_signal(signal..':update', service.update)
    return service
end

