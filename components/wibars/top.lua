local awful = require("awful")
local wibox = require("wibox")

local layout_box = require("components.widgets.layout_box")
local main_menu = require("components.widgets.main_menu")
local volume_control = require("components.widgets.volume_control")
local system_tray = require("components.widgets.system_tray")
local clock = require("components.widgets.clock")
local keyboard_layout = require("components.widgets.keyboard_layout")

local this = {}

function this.create_bar(s)
    local bar = awful.wibar({ position = "top", screen = s, height = 32, ontop = true })
    bar:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        main_menu.create_widget(),
        clock.create_widget(),
        {
            layout = wibox.layout.fixed.horizontal,
            keyboard_layout.create_widget(),
            system_tray.create_widget(),
            volume_control.create_widget(),
            layout_box.create_widget(s),
        },
    }
    return bar
end

return this