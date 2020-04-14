-- service_brightness
local awesome = awesome

local awful = require("awful")

local default = {
    theme = {},
    settings = {
        timeout = 5,
    },
}

return function ( args )
    local theme = args.theme or default.theme
    local settings = args.settings or default.settings
    -- Defaults
    settings.timeout = settings.timeout or default.settings.timeout
    -- Watcher
    awful.widget.watch("xbacklight -get", settings.timeout, function(_, stdout)
        local value = tonumber(stdout) or 0
        awesome.emit_signal('service:brightness:value', value)
    end)
    awesome.connect_signal('service:brightness:sync', function(name, value)
        awesome.emit_signal('service:brightness:sync>'..tostring(name), value)
    end)
end
