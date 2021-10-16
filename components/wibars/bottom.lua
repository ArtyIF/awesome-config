local awful = require("awful")
local wibox = require("wibox")

local this = {}

this.task_list = require("components.widgets.task_list")
this.toggle_minimize = require("components.widgets.toggle_minimize")

function this.create_bar(s)
    local bar_height = 32
    if COMPACT_MODE then
        bar_height = 24
    end
    local bar = awful.wibar({ position = "bottom", screen = s, height = bar_height, ontop = true })
    bar:setup {
        layout = wibox.layout.align.horizontal,
        nil,
        this.task_list.create_widget(s),
        this.toggle_minimize.create_widget(s),
    }
    return bar
end

return this