-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

local layout_box = {}

awful.layout.layouts = {
    awful.layout.suit.max,
    awful.layout.suit.fair,
}

layout_box.buttons = gears.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end),
    awful.button({ }, 4, function () awful.layout.inc( 1) end),
    awful.button({ }, 5, function () awful.layout.inc(-1) end)
)

function layout_box.new(s)
    local layoutbox = awful.widget.layoutbox(s)
    layoutbox:buttons(layout_box.buttons)
    return layoutbox
end

return layout_box.new