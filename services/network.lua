-- service network

local awesome = awesome

local lain = require("lain")

local default = {
    notify = "off",
    wifi_state = "on",
    eth_state = "on",
}

return function ( args )
    args = args or {}
    local settings = {}
    for k,v in pairs(default) do settings[k] = v end
    for k,v in pairs(args) do settings[k] = v end
    settings.settings = settings.settings or function()
        awesome.emit_signal('service:network:value', net_now)
    end
    lain.widget.net(settings)
end

