local awful = require("awful")
local wibox = require("wibox")

local this = {}

this.tag_list = require("components.widgets.tag_list")
this.task_list = require("components.widgets.task_list")
this.toggle_minimize = require("components.widgets.toggle_minimize")

function this.create_bar(s)
    local bar = awful.wibar({ position = "bottom", screen = s, height = 32, ontop = true })
    bar:setup {
        layout = wibox.layout.align.horizontal,
        this.tag_list.create_widget(s),
        this.task_list.create_widget(s),
        this.toggle_minimize.create_widget(s),
    }
    return bar
end

return this