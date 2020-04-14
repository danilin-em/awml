-- service usage mem

local awesome = awesome

local mem = require("lain.widget.mem")

local default = {
    id = 'main',
}

return function ( args )
    args = args or {}
    args.id = tostring(args.id or default.id)
    local signal = 'service:usage:mem:'..args.id
    args.settings = function()
        awesome.emit_signal(signal..':value', mem_now)
    end
    local service = mem(args)
    awesome.emit_signal(signal..':init', service)
    awesome.connect_signal(signal..':update', service.update)
    return service
end

