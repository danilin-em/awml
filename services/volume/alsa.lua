-- service volume alsa

local awesome = awesome

local alsa = require("lain.widget.alsa")

local default = {
    id = 'main',
}

return function ( args )
    args = args or {}
    args.id = tostring(args.id or default.id)
    local signal = 'service:volume:alsa:'..args.id
    args.settings = function()
        awesome.emit_signal(signal..':value', volume_now)
    end
    local service = alsa(args)
    awesome.emit_signal(signal..':init', service)
    awesome.connect_signal(signal..':update', service.update)
    return service
end

