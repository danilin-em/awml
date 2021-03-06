-- service usage cpu

local awesome = awesome

local cpu = require("lain.widget.cpu")

local default = {
    id = 'main',
}

return function ( args )
    args = args or {}
    args.id = tostring(args.id or default.id)
    local signal = 'service:usage:cpu:'..args.id
    args.settings = function()
        awesome.emit_signal(signal..':value', cpu_now)
    end
    local service = cpu(args)
    awesome.emit_signal(signal..':init', service)
    awesome.connect_signal(signal..':update', service.update)
    return service
end

