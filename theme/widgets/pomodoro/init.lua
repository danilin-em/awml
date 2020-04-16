-- pomodoro
local wibox = require("wibox")
local tooltip = require("awful.tooltip")

return function ( theme ) -- luacheck: no unused
    theme.widget_pomodoro_timer_stopped = theme.dir .. "/widgets/pomodoro/icons/timer_stopped.png"
    theme.widget_pomodoro_timer_active = theme.dir .. "/widgets/pomodoro/icons/timer_active.png"
    theme.widget_pomodoro_timer_break = theme.dir .. "/widgets/pomodoro/icons/timer_break.png"
    local _icon = wibox.widget.imagebox(theme.widget_pomodoro_timer_stopped)
    local _widget = wibox.widget {
        _icon,
        value = 0,
        min_value = 0,
        max_value = 100,
        thickness = 1,
        border_width = 0,
        bg = theme.bg_normal,
        colors = {'#ffffff'},
        start_angle = 0.5 * math.pi,
        widget = wibox.container.arcchart,
        -- Props
        states = {
            stopped = 'Decide on the task to be done. And click me :)',
            active = 'Work on the task...',
            short_break = 'Take a short break',
            long_break = 'Good job! Take a long break',
        },
        state_line = {
            'stopped',
            'active',
            'short_break',
            'active',
            'long_break',
        },
        state_current = 1,
    }
    function _widget.state_text (self)
        local state = self.state_line[self.state_current]
        return self.states[state]
    end
    tooltip {
        objects = { _widget },
        align = "bottom_left",
        timer_function = function()
            return _widget:state_text()
        end,
    }
    return _widget
end
