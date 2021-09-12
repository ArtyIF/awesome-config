local wibox = require("wibox")

local this = {}

this.icon_size = nil
this.mode = "horizontal"
this.reverse = false

function this.create_widget()
    local system_tray = wibox.widget.systray()
    system_tray.base_size = this.icon_size
    system_tray.horizontal = this.mode == "horizontal"
    system_tray.reverse = this.reverse
    return system_tray
end

return this