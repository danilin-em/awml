--[[
    Powerarrow Dark Awesome WM theme
    github.com/lcpz
--]]
local awesome, client, mouse, screen, tag --luacheck: no unused
    = awesome, client, mouse, screen, tag

local ipairs, string, os, table, tostring, tonumber, type --luacheck: no unused
    = ipairs, string, os, table, tostring, tonumber, type

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi


local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local AWESOME_ROOT = os.getenv("AWESOME_ROOT") or os.getenv("HOME") .. "/.config/awesome"

local theme                                     = {}
theme.dir                                       = AWESOME_ROOT .. "/theme"
theme.wallpaper                                 = AWESOME_ROOT .. "/wallpaper.jpg"
theme.font                                      = "Terminus 9"
theme._color_white                              = "#FFFFFF"
theme._color_black                              = "#000000"
theme._color_red                                = "#FF0000"
theme.fg_normal                                 = "#DDDDFF"
theme.fg_focus                                  = theme._color_white
theme.fg_urgent                                 = "#CC9393"
theme.bg_normal                                 = "#1A1A1A"
theme.bg_focus                                  = "#313131"
theme.bg_urgent                                 = "#1A1A1A"
theme.bg_warn                                   = "#FF7F00"
theme.bg_critical                               = theme._color_red
theme.border_width                              = dpi(1)
theme.border_normal                             = "#3F3F3F"
theme.border_focus                              = "#7F7F7F"
theme.border_marked                             = "#CC9393"
theme.tasklist_bg_focus                         = "#404040"
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_focus                         = theme.fg_focus
theme.menu_height                               = dpi(16)
theme.menu_width                                = dpi(140)
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = false
theme.useless_gap                               = dpi(0)

-- {{ Icons:
theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"

theme.layout_dwindle                            = theme.dir .. "/icons/layout/dwindle.png"
theme.layout_fairh                              = theme.dir .. "/icons/layout/fairh.png"
theme.layout_fairv                              = theme.dir .. "/icons/layout/fairv.png"
theme.layout_floating                           = theme.dir .. "/icons/layout/floating.png"
theme.layout_magnifier                          = theme.dir .. "/icons/layout/magnifier.png"
theme.layout_max                                = theme.dir .. "/icons/layout/max.png"
theme.layout_spiral                             = theme.dir .. "/icons/layout/spiral.png"
theme.layout_tile                               = theme.dir .. "/icons/layout/tile.png"
theme.layout_tilebottom                         = theme.dir .. "/icons/layout/tilebottom.png"
theme.layout_tileleft                           = theme.dir .. "/icons/layout/tileleft.png"
theme.layout_tiletop                            = theme.dir .. "/icons/layout/tiletop.png"
theme.layout_fullscreen                         = theme.dir .. "/icons/layout/fullscreen.png"

theme.taglist_squares_sel                       = theme.dir .. "/icons/taglist/square_sel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/taglist/square_unsel.png"

theme.titlebar_close_button_focus               = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.dir .. "/icons/titlebar/close_normal.png"
theme.titlebar_floating_button_focus_active     = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_normal_inactive  = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"
theme.titlebar_ontop_button_focus_active        = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_normal_inactive     = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_normal_inactive    = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"

-- Widgets Settings
theme.widget_power_popup_use_wallpaper = false

-- Battery notifications
theme.bat_notification_charged_preset = {
    title = "Battery full",
    text = "You can unplug the cable",
    timeout = 5,
    fg = theme.fg_normal,
    bg = theme.bg_normal,
}
theme.bat_notification_low_preset = {
    title = "Battery low",
    text = "Plug the cable!",
    timeout = 30,
    fg = theme.fg_normal,
    bg = theme.bg_warn,
}
theme.bat_notification_critical_preset = {
    title = "Battery exhausted",
    text = "Shutdown imminent",
    timeout = 0,
    fg = theme.fg_normal,
    bg = theme.bg_critical,
}
-- }}

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 4, function () awful.layout.inc( 1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist{
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = awful.util.tasklist_buttons,
        layout   = {
            max_widget_size = dpi(350),
            layout =  wibox.layout.flex.horizontal,
        },
        widget_template = {
            {
                {
                    {
                        {
                            id     = 'icon_role',
                            widget = wibox.widget.imagebox,
                        },
                        margins = 2,
                        widget  = wibox.container.margin,
                    },
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    {
                        id     = 'tasklist_window_buttons',
                        layout = wibox.layout.flex.horizontal,
                    },
                    layout = wibox.layout.align.horizontal,
                },
                left = dpi(2),
                right = dpi(2),
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
            create_callback = function(self, c, index, objects) --luacheck: no unused
                c.tasklist_window_buttons = self:get_children_by_id('tasklist_window_buttons')[1]
                c.tasklist_window_buttons:insert(1, awful.titlebar.widget.floatingbutton(c))
                c.tasklist_window_buttons:insert(2, awful.titlebar.widget.closebutton(c))
            end,
        }
    }

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        height = dpi(18),
        bg = theme.bg_normal,
        fg = theme.fg_normal,
    })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            {
                require('theme.widgets.menu')(theme),
                widget = wibox.container.margin,
            },
            s.mytaglist,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            spacing = dpi(5),
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            require('theme.widgets.keyboardlayout')(theme),
            require('theme.widgets.volume')(theme),
            require('theme.widgets.mem')(theme),
            require('theme.widgets.battery')(theme),
            require('theme.widgets.brightness')(theme),
            require('theme.widgets.network')(theme),
            require('theme.widgets.clock')(theme),
            s.mylayoutbox,
            require('theme.widgets.power')(theme, s),
        },
    }
end

return theme
