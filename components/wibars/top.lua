local awful = require("awful")
local wibox = require("wibox")
local theme_vars = require("beautiful").get()

local this = {}

this.main_menu = require("components.widgets.main_menu")
this.tag_list = require("components.widgets.tag_list")
this.clock = require("components.widgets.clock")
this.layout_box = require("components.widgets.layout_box")
this.volume_control = require("components.widgets.volume_control")
this.system_tray = require("components.widgets.system_tray")
this.keyboard_layout = require("components.widgets.keyboard_layout")
this.paste = require("components.widgets.paste")

function this.create_bar(s)
    local bar = awful.wibar({ position = "top", screen = s, height = theme_vars.top_wibar_height, ontop = true })
    bar:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        { 
            this.main_menu.create_widget(),
            this.tag_list.create_widget(s),
            widget = wibox.layout.align.horizontal,
        },
        this.clock.create_widget(),
        {
            layout = wibox.layout.fixed.horizontal,
            this.keyboard_layout.create_widget(),
            this.paste.create_widget(),
            this.system_tray.create_widget(),
            this.volume_control.create_widget(),
            this.layout_box.create_widget(s),
        }
    }
    return bar
end

return this