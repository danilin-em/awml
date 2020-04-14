-- service battery
local awesome = awesome

local bat = require("lib.lain.widget.bat")

local default = {
    id = 'main',
}

return function ( args )
    args = args or {}
    args.id = tostring(args.id or default.id)
    local signal = 'service:battery:'..args.id
    args.settings = function()
        awesome.emit_signal(signal..':value', bat_now) 
    end
    local service = bat(args)
    awesome.emit_signal(signal..':init', service)
    awesome.connect_signal(signal..':update', service.update)
    return service
end
