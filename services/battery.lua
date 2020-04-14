-- service_battery
local awesome = awesome

local bat = require("lib.lain.widget.bat")

local default = {
    settings = {
        perc = {
            low = 15,
            crit = 5,
        },
    },
    theme = {
        fg_normal = '#DDDDFF',
        bg_normal = '#1A1A1A',
        bg_warn = '#FF7F00',
        bg_critical = '#FF0000',
    },
}

local bat_init = function ( theme, settings )
    bat({
        n_perc = settings.perc or default.settings.perc,
        timeout = 5,
        notify = "on",
        bat_notification_charged_preset = settings.bat_notification_charged_preset or {
            title = "Battery full",
            text = "You can unplug the cable",
            timeout = 5,
            fg = theme.fg_normal or default.theme.fg_normal,
            bg = theme.bg_normal or default.theme.bg_normal, 
        },
        bat_notification_low_preset = settings.bat_notification_low_preset or {
            title = "Battery low",
            text = "Plug the cable!",
            timeout = 30,
            fg = theme.fg_normal or default.theme.fg_normal ,
            bg = theme.bg_warn or default.theme.bg_warn 
        },
        bat_notification_critical_preset = settings.bat_notification_critical_preset or {
            title = "Battery exhausted",
            text = "Shutdown imminent",
            timeout = 0,
            fg = theme.fg_normal or default.theme.fg_normal ,
            bg = theme.bg_critical or default.theme.bg_critical 
        },
        settings = function()
            awesome.emit_signal('service:battery:value', bat_now) 
        end
    })
end

return function (args)
    local theme = args.theme or default.theme
    local settings = args.settings or default.settings
    return bat_init(theme, settings)
end
