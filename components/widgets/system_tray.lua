local wibox = require("wibox")
local theme_vars = require("beautiful").get()

local this = {}

this.icon_size = nil
this.mode = "horizontal"
this.reverse = false

this.margin_top = theme_vars.wibar_icon_margins
this.margin_right = theme_vars.wibar_icon_margins / 2
this.margin_bottom = theme_vars.wibar_icon_margins
this.margin_left = theme_vars.wibar_icon_margins / 2

function this.create_widget()
    local system_tray = wibox.widget.systray()

    system_tray.base_size = this.icon_size
    system_tray.horizontal = this.mode == "horizontal"
    system_tray.reverse = this.reverse

    this.widget = wibox.container.margin(system_tray, this.margin_left, this.margin_right, this.margin_top, this.margin_bottom, nil, false)
    
    return this.widget
end

return this