-- service volume alsa

local awesome = awesome

local alsa = require("lain.widget.alsa")

return function ( )
    local service = alsa({
        settings = function()
            awesome.emit_signal('service:volume:alsa:value', volume_now)
        end
    })
    awesome.emit_signal('service:volume:alsa:init', service)
    awesome.connect_signal('service:volume:alsa:update', service.update)
end

