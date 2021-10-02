-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local theme_vars = require("beautiful").get()

local this = {}

this.margin_top = theme_vars.wibar_icon_margins
this.margin_right = theme_vars.wibar_icon_margins
this.margin_bottom = theme_vars.wibar_icon_margins
this.margin_left = theme_vars.wibar_icon_margins / 2

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