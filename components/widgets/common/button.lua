-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library
local wibox = require("wibox")
local theme_vars = require("beautiful").get()
local colors = require("theme.colors")
local naughty = require("naughty")

local this = {}

function this.create_widget(content, on_left_click, args)
    local margin_left = args.margin_left or args.margins or theme_vars.wibar_icon_margins
    local margin_right = args.margin_right or args.margins or theme_vars.wibar_icon_margins
    local margin_top = args.margin_top or args.margins or theme_vars.wibar_icon_margins
    local margin_bottom = args.margin_bottom or args.margins or theme_vars.wibar_icon_margins

    local button = wibox.container.margin(wibox.container.background(content), margin_left, margin_right, margin_top, margin_bottom)
    button.widget.fg = colors.base_fg

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
    button:buttons(buttons)

    button:connect_signal("mouse::enter", function ()
        button.widget.fg = colors.accent_bg
        if args.imageboxes_to_recolor then
            for _, img in ipairs(args.imageboxes_to_recolor) do
                img.image = gears.color.recolor_image(img.image, colors.accent_bg)
            end
        end
    end)
    button:connect_signal("mouse::leave", function ()
        button.widget.fg = colors.base_fg
        if args.imageboxes_to_recolor then
            for _, img in ipairs(args.imageboxes_to_recolor) do
                --img.image = gears.color.recolor_image(img.image, colors.base_fg)
            end
        end
    end)

    return button
end

return this