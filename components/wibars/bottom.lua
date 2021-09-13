local awful = require("awful")
local wibox = require("wibox")

local tag_list = require("components.widgets.tag_list")
local task_list = require("components.widgets.task_list")
local toggle_minimize = require("components.widgets.toggle_minimize")

local this = {}

function this.create_bar(s)
    local bar = awful.wibar({ position = "bottom", screen = s, height = 32, ontop = true })
    bar:setup {
        layout = wibox.layout.align.horizontal,
        tag_list.create_widget(s),
        task_list.create_widget(s),
        toggle_minimize.create_widget(s),
    }
    return bar
end

return this