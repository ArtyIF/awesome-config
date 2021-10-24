local awful = require("awful")
local wibox = require("wibox")
local theme_vars = require("beautiful").get()

local this = {}

this.main_menu = require("components.widgets.wibar_top.main_menu")
this.tag_list = require("components.widgets.wibar_top.tag_list")
this.clock = require("components.widgets.wibar_top.clock")
this.layout_box = require("components.widgets.wibar_top.layout_box")
this.volume_control = require("components.widgets.wibar_top.volume_control")
this.system_tray = require("components.widgets.wibar_top.system_tray")
this.keyboard_layout = require("components.widgets.wibar_top.keyboard_layout")
this.paste = require("components.widgets.wibar_top.paste")
this.volume_control_new = require("components.widgets.wibar_top.volume_control_new")

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
            this.volume_control_new.create_widget(),
            this.layout_box.create_widget(s),
        }
    }
    return bar
end

return this