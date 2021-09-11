-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

local this = {}

awful.layout.layouts = {
    awful.layout.suit.max,
    awful.layout.suit.fair,
}

this.buttons = gears.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end),
    awful.button({ }, 4, function () awful.layout.inc( 1) end),
    awful.button({ }, 5, function () awful.layout.inc(-1) end)
)

function this.create_widget(s)
    local layoutbox = awful.widget.layoutbox(s)
    layoutbox:buttons(this.buttons)
    return layoutbox
end

return this