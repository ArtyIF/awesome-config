local awful = require("awful")
local wibox = require("wibox")

local main_menu = require("components.widgets.main_menu")
local clock = require("components.widgets.clock")
local top_wibar_right_part = require("components.widgets.top_wibar_right_part")

local this = {}

function this.create_bar(s)
    local bar = awful.wibar({ position = "top", screen = s, height = 32, ontop = true })
    bar:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        main_menu.create_widget(),
        clock.create_widget(),
        top_wibar_right_part.create_widget(s)
    }
    return bar
end

return this