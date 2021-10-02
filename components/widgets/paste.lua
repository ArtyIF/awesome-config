-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library
local wibox = require("wibox")
local theme_vars = require("beautiful").get()

local this = {}

this.cmd = "copyq "
this.ui_arg = "toggle"

this.icon = "/usr/share/icons/breeze-dark/actions/24/edit-paste.svg"

this.margin_top = theme_vars.wibar_icon_margins
this.margin_right = theme_vars.wibar_icon_margins / 2
this.margin_bottom = theme_vars.wibar_icon_margins
this.margin_left = 0

function this.ui()
    return awful.spawn.spawn(this.cmd .. this.ui_arg)
end


this.widget = wibox.widget.imagebox(this.icon, true)

function this.create_widget()
    this.margin = wibox.container.margin(this.widget, this.margin_left, this.margin_right, this.margin_top, this.margin_bottom)

    this.margin:buttons({
        awful.button({ }, 1, function ()
            this.ui()
        end)
    })
    
    return this.margin
end

return this