local wibox = require("wibox")
local beautiful = require("beautiful")

local this = {}

this.layout_box = require("components.widgets.layout_box")
this.volume_control = require("components.widgets.volume_control")
this.system_tray = require("components.widgets.system_tray")
this.keyboard_layout = require("components.widgets.keyboard_layout")
this.gpaste = require("components.widgets.gpaste")

function this.create_widget(s)
    local margin = wibox.container.margin(nil, 4, 0, 0, 0)
    local bg = wibox.container.background(margin, beautiful.get().bg_systray)
    margin:setup {
        layout = wibox.layout.fixed.horizontal,
        this.keyboard_layout.create_widget(),
        this.gpaste.create_widget(),
        this.system_tray.create_widget(),
        this.volume_control.create_widget(),
        this.layout_box.create_widget(s),
    }
    return bg
end

return this