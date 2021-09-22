-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library
local wibox = require("wibox")
local beautiful = require("beautiful")

local this = {}

this.placement = awful.placement.top_right+awful.placement.no_offscreen
this.contents = {
    widget = wibox.container.margin,
    margins = 4,
    {
        text   = 'foobar',
        widget = wibox.widget.textbox
    }
}

function this.create_popup()
    this.popup = awful.popup {
        placement = this.placement,
        widget = this.contents,
        ontop = true,
        bg = beautiful.get().bg_systray,
        visible = false,
    }
    return this.popup -- todo keep working
end

return this