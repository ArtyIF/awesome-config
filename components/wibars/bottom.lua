local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
local theme_vars = require("beautiful").get()

local this = {}

this.task_list = require("components.widgets.task_list")
this.task_list_new = require("components.widgets.task_list_new")
this.toggle_minimize = require("components.widgets.toggle_minimize")

function this.create_bar(s)
    local bar_height = theme_vars.bottom_wibar_height
    local bar = awful.wibar({ position = "bottom", screen = s, height = bar_height, ontop = true })
    bar.y = s.geometry.height - bar_height
    bar:struts({ bottom = 0 })

    local mouse_over = false

    local show_bar_callback = function ()
        if client.focus == nil or mouse_over then
            bar.y = s.geometry.height - bar_height
        end
        bar:struts({ bottom = 0 })
    end
    local show_timer = gears.timer({
        timeout = 0.15,
        autostart = false,
        call_now = false,
        single_shot = true,
        callback = show_bar_callback
    })

    local hide_bar_callback = function ()
        if client.focus ~= nil and not mouse_over then
            bar.y = s.geometry.height - 1
        end
        bar:struts({ bottom = 0 })
    end
    local hide_timer = gears.timer({
        timeout = 0.3,
        autostart = false,
        call_now = false,
        single_shot = true,
        callback = hide_bar_callback
    })

    bar:connect_signal("mouse::enter", function ()
        mouse_over = true
        show_timer:start()
        hide_timer:stop()
    end)
    bar:connect_signal("mouse::leave", function ()
        mouse_over = false
        show_timer:stop()
        hide_timer:start()
    end)

    client.connect_signal("focus", function ()
        show_timer:stop()
        hide_timer:start()
    end)
    client.connect_signal("unfocus", function ()
        show_timer:start()
        hide_timer:stop()
    end)

    bar:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        nil,
        this.task_list.create_widget(s),
        --this.task_list_new.create_widget(s),
        this.toggle_minimize.create_widget(s),
    }
    return bar
end

return this