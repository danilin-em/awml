-- service volume alsa

local awesome = awesome

local alsa = require("lain.widget.alsa")
local easy_async_with_shell = require("awful.spawn").easy_async_with_shell

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
    -- Service
    local service = alsa(args)
    function service.Raise ( self, value )
        local cmd = string.format("amixer -q set %s %s%%+", self.channel, value)
        easy_async_with_shell(cmd, function(_)
            self.update()
        end)
    end
    function service.Lower ( self, value )
        local cmd = string.format("amixer -q set %s %s%%-", self.channel, value)
        easy_async_with_shell(cmd, function(_)
            self.update()
        end)
    end
    function service.Mute ( self )
        local cmd = string.format("amixer -q set %s toggle", self.togglechannel or self.channel)
        easy_async_with_shell(cmd, function(_)
            self.update()
        end)
    end
    -- Methods Signals
    awesome.connect_signal(signal..':Raise', function ( value )
        service:Raise(value)
    end)
    awesome.connect_signal(signal..':Lower', function ( value )
        service:Lower(value)
    end)
    awesome.connect_signal(signal..':Mute', function ( )
        service:Mute()
    end)
    -- Main Signals
    awesome.connect_signal(signal..':update', service.update)
    awesome.emit_signal(signal..':init', service)
    return service
end

