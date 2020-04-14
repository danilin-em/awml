-- service_clock
local awesome = awesome

local awful = require("awful")

local default = {
    settings = {
        id = 'main',
        timeout = 1,
    },
}

return function( args )
    args = args or default
    local settings = args.settings or default.settings
    -- Defaults
    settings.timeout = settings.timeout or default.settings.timeout
    settings.id = settings.id or default.settings.id
    -- Watcher
    awful.widget.watch("true", settings.timeout, function(_, stdout)
        local time = os.date("!*t")
        awesome.emit_signal('service:clock:'..settings.id..':time', time)
        awesome.emit_signal('service:clock:time', time)
    end)
end
