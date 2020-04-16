-- service power
local awesome = awesome

local spawn = require("awful.spawn")

local default = {
    id = 'main',
}

return function ( args )
    args = args or {}
    args.id = tostring(args.id or default.id)
    args.timeout = tonumber(args.timeout or default.timeout)
    args.cmd_lock = args.cmd_lock or 'false'
    local signal = 'service:power:'..args.id
    -- Service
    local service = {
        popup = {
            visible = false,
        }
    }
    -- Connect Signals
    awesome.connect_signal(signal..':action:lock', function()
        spawn.with_shell(args.cmd_lock)
    end)
    awesome.connect_signal(signal..':action:quit', function()
        awesome.quit()
    end)
    awesome.connect_signal(signal..':action:reload', function()
        awesome.restart()
    end)
    awesome.connect_signal(signal..':action:suspend', function()
        spawn.with_shell("systemctl suspend")
    end)
    awesome.connect_signal(signal..':action:reboot', function()
        spawn.with_shell("systemctl reboot")
    end)
    awesome.connect_signal(signal..':action:poweroff', function()
        spawn.with_shell("systemctl poweroff")
    end)
    -- Init Signal
    awesome.emit_signal(signal..':init', service)
    return service
end
