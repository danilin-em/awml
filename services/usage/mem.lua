-- service usage mem

local awesome = awesome

local lain = require("lain")

return function ( args )
    lain.widget.mem({
        settings = function()
            awesome.emit_signal('service:usage:mem:value', mem_now)
        end
    })
end

