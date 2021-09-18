-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local this = {}

this.margin_top = 4
this.margin_right = 4
this.margin_bottom = 4
this.margin_left = 2

awful.layout.layouts = {
    awful.layout.suit.max,
    awful.layout.suit.fair,
}

this.buttons = gears.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end)
)

function this.create_widget(s)
    local layoutbox = awful.widget.layoutbox(s)
    local margin = wibox.container.margin(layoutbox, this.margin_left, this.margin_right, this.margin_top, this.margin_bottom)
    margin:buttons(this.buttons)
    return margin
end

return this