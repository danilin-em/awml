-- service usage cpu

local awesome = awesome

local lain = require("lain")

return function ( args )
    lain.widget.cpu({
        settings = function()
            awesome.emit_signal('service:usage:cpu:value', cpu_now)
        end
    })
end

