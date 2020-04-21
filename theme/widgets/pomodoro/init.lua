-- pomodoro
local wibox = require("wibox")
local tooltip = require("awful.tooltip")
local button = require("awful.button")
local table_join = require("awful.util").table.join
local notify = require("naughty").notify

return function ( theme ) -- luacheck: no unused
    theme.widget_pomodoro_timer_stopped = theme.dir .. "/widgets/pomodoro/icons/timer_stopped.png"
    theme.widget_pomodoro_timer_active = theme.dir .. "/widgets/pomodoro/icons/timer_active.png"
    theme.widget_pomodoro_timer_break = theme.dir .. "/widgets/pomodoro/icons/timer_break.png"
    local _icon = wibox.widget.imagebox(theme.widget_pomodoro_timer_stopped)
    function _icon.set_state (self, state)
        local states = {
            stopped = theme.widget_pomodoro_timer_stopped,
            active = theme.widget_pomodoro_timer_active,
            short_break = theme.widget_pomodoro_timer_break,
            long_break = theme.widget_pomodoro_timer_break,
        }
        self:set_image(states[state])
    end
    local _widget = wibox.widget {
        _icon,
        value = 0,
        min_value = 0,
        max_value = 1500, -- Seconds
        thickness = 1,
        border_width = 0,
        bg = theme.bg_normal,
        colors = {'#ffffff'},
        start_angle = 0.5 * math.pi,
        widget = wibox.container.arcchart,
        -- Props
        states = {
            stopped = 'Decide on the task to be done',
            active = 'Work on the task...',
            short_break = 'Take a short break',
            long_break = 'Good job! Take a long break',
        },
        state_line = {
            'stopped', -- 1
            'active', -- 2
            'short_break', -- 3
            'active', -- 4
            'long_break', -- 5
        },
        state_current = 1,
    }
    function _widget.state_name (self)
        return self.state_line[self.state_current]
    end
    function _widget.state_text (self)
        local state = self:state_name()
        return self.states[state]
    end
    function _widget.set_state (self, index)
        if index > #self.state_line then
            index = 1
        end
        self.state_current = index
        return index
    end
    function _widget.inc_state (self)
        return self:set_state(self.state_current + 1)
    end
    function _widget.Start (self)
        self:inc_state()
        _icon:set_state(self:state_name())
        self:Notify()
    end
    function _widget.Stop (self)
        self:set_state(1)
        _icon:set_state(self:state_name())
    end
    function _widget.Notify (self)
        self.notify_id = notify({
            preset = theme.widget_pomodoro_notify_preset or {
                title = "Pomodoro",
                text = self:state_text(),
                timeout = 5,
                fg = theme.fg_normal,
                bg = theme.bg_normal,
            },
            replaces_id = self.notify_id
        }).id
    end
    tooltip {
        objects = { _widget },
        align = "bottom_left",
        timer_function = function()
            return _widget:state_text()
        end,
    }
    awesome.connect_signal('widget:pomodoro:Start', function ( )
        _widget:Start()
    end)
    awesome.connect_signal('widget:pomodoro:Stop', function ( )
        _widget:Stop()
    end)
    _widget:buttons(table_join(
        button({}, 1, function ()
            awesome.emit_signal('widget:pomodoro:Start')
        end),
        button({}, 3, function ()
            awesome.emit_signal('widget:pomodoro:Stop')
        end)
    ))
    return _widget
end
