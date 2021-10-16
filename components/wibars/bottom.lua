local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local this = {}

this.task_list = require("components.widgets.task_list")
this.toggle_minimize = require("components.widgets.toggle_minimize")

function this.create_bar(s)
    local bar_height = 64
    if COMPACT_MODE then
        bar_height = 24
    end
    local bar = awful.wibar({ position = "bottom", screen = s, height = bar_height, ontop = true })
    bar.y = s.geometry.height - 1
    bar:struts({ bottom = 0 })

    local hide_timer = gears.timer({
        timeout = 0.25,
        autostart = false,
        call_now = false,
        callback = function ()
            bar.y = s.geometry.height - 1
            bar:struts({ bottom = 0 })
        end
    })
    bar:connect_signal("mouse::enter", function ()
        hide_timer:stop()
        bar.y = s.geometry.height - bar_height
        bar:struts({ bottom = 0 })
    end)
    bar:connect_signal("mouse::leave", function ()
        hide_timer:start()
    end)

    bar:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        nil,
        this.task_list.create_widget(s),
        this.toggle_minimize.create_widget(s),
    }
    return bar
end

return this