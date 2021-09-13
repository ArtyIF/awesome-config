local wibox = require("wibox")
local beautiful = require("beautiful")

local layout_box = require("components.widgets.layout_box")
local volume_control = require("components.widgets.volume_control")
local system_tray = require("components.widgets.system_tray")
local keyboard_layout = require("components.widgets.keyboard_layout")

local this = {}

function this.create_widget(s)
    local margin = wibox.container.margin(nil, 4, 0, 0, 0)
    local bg = wibox.container.background(margin, beautiful.get().bg_systray)
    margin:setup {
        layout = wibox.layout.fixed.horizontal,
        keyboard_layout.create_widget(),
        system_tray.create_widget(),
        volume_control.create_widget(),
        layout_box.create_widget(s),
    }
    return bg
end

return this