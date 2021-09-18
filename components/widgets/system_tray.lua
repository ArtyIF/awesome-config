local wibox = require("wibox")

local this = {}

this.icon_size = nil
this.mode = "horizontal"
this.reverse = false

this.margin_top = 4
this.margin_right = 0
this.margin_bottom = 4
this.margin_left = 4

function this.create_widget()
    local system_tray = wibox.widget.systray()

    system_tray.base_size = this.icon_size
    system_tray.horizontal = this.mode == "horizontal"
    system_tray.reverse = this.reverse

    this.widget = wibox.container.margin(system_tray, this.margin_left, this.margin_right, this.margin_top, this.margin_bottom, nil, false)
    
    return this.widget
end

return this