local wibox = require("wibox")

local this = {}

this.format = "%a %d %b, %H:%M"
this.refresh_rate = 60

function this.create_widget()
    return wibox.widget.textclock(this.format, this.refresh_rate)
end

return this