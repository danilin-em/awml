-- service network

local awesome = awesome

local net = require("lain.widget.net")

local default = {
    id = 'main',
}

return function ( args )
    args = args or {}
    args.id = tostring(args.id or default.id)
    local signal = 'service:network:'..args.id
    args.settings = function()
        awesome.emit_signal(signal..':value', net_now) -- luacheck: ignore
    end
    local service = net(args)
    awesome.emit_signal(signal..':init', service)
    awesome.connect_signal(signal..':update', service.update)
    return service
end

