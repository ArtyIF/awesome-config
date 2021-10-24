-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library
local wibox = require("wibox")
local theme_vars = require("beautiful").get()
local colors = require("theme.colors")
local naughty = require("naughty")

local this = {}

function this.create_widget(image, on_left_click, args)
    local margin_left = args.margin_left or args.margins or theme_vars.wibar_icon_margins
    local margin_right = args.margin_right or args.margins or theme_vars.wibar_icon_margins
    local margin_top = args.margin_top or args.margins or theme_vars.wibar_icon_margins
    local margin_bottom = args.margin_bottom or args.margins or theme_vars.wibar_icon_margins

    local content = {
        {
            id = "button_image",
            wibox.widget.imagebox(image),
        },
        id = "button_root",
        layout = wibox.layout.fixed.horizontal,
        widget = wibox.container.background
    }
    if args.text then
        content[2] = {
            id = "button_text",
            wibox.widget.textbox(image),
        }
    end
    local button = wibox.widget {
        id = "button_image",
        wibox.widget.imagebox(image),
    }
    --[[ button.button_root.fg = colors.base_fg

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
        button.button_root.fg = colors.accent_bg
        button.button_root.button_image.image = gears.color.recolor_image(button.widget.button_image.image, colors.base_fg)
    end)
    button:connect_signal("mouse::leave", function ()
        button.widget.fg = colors.base_fg
        if args.imageboxes_to_recolor then
            for _, img in ipairs(args.imageboxes_to_recolor) do
                --img.image = gears.color.recolor_image(img.image, colors.base_fg)
            end
        end
    end) ]]

    return button
end

return this