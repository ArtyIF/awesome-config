local awful = require("awful")
local wibox = require("wibox")

local this = {}

this.main_menu = require("components.widgets.main_menu")
this.tag_list = require("components.widgets.tag_list")
this.clock = require("components.widgets.clock")
this.top_wibar_right_part = require("components.widgets.top_wibar_right_part")

function this.create_bar(s)
    local bar_height = 32
    if COMPACT_MODE then
        bar_height = 24
    end
    local bar = awful.wibar({ position = "top", screen = s, height = bar_height, ontop = true })
    bar:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        { 
            this.main_menu.create_widget(),
            this.tag_list.create_widget(s),
            widget = wibox.layout.align.horizontal,
        },
        this.clock.create_widget(),
        this.top_wibar_right_part.create_widget(s)
    }
    return bar
end

return this