-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library
local wibox = require("wibox")
local theme_vars = require("beautiful").get()
local colors = require("theme.colors")

local this = {}

function this.create_widget(content, on_left_click, args)
    local margin_left = args.left or args.margins or 0
    local margin_right = args.right or args.margins or 0
    local margin_top = args.top or args.margins or 0
    local margin_bottom = args.bottom or args.margins or 0

    local widget = wibox.container.margin(content, margin_left, margin_right, margin_top, margin_bottom)

    local buttons = {
        awful.button({ }, 1, on_left_click),
    }
    if args.on_middle_click then
        table.insert(buttons, awful.button({ }, 2, args.on_middle_click))
    end
    if args.on_right_click then
        table.insert(buttons, awful.button({ }, 3, args.on_right_click))
    end
    if args.on_scroll_up then
        table.insert(buttons, awful.button({ }, 4, args.on_scroll_up))
    end
    if args.on_scroll_down then
        table.insert(buttons, awful.button({ }, 5, args.on_scroll_down))
    end
    widget:buttons(buttons)

    return widget
end

return this