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
    if not args then args = {} end

    local margins = args.margins or theme_vars.wibar_icon_margins

    local content = {
        {
            {
                id = "image_role",
                image = gears.color.recolor_image(image, colors.base_fg),
                widget = wibox.widget.imagebox
            },
            id = "image_margin_role",
            margins = { right = margins },
            widget = wibox.container.margin
        },
        id = "layout_role",
        layout = wibox.layout.fixed.horizontal
    }
    if args.text then
        content[2] = {
            id = "text_role",
            text = args.text,
            widget = wibox.widget.textbox,
        }
    end

    local button = wibox.widget {
        {
            content,
            id = "margin_role",
            margins = margins,
            widget = wibox.container.margin
        },
        widget = wibox.container.background
    }

    button:connect_signal("mouse::enter", function ()
        button.fg = colors.accent_bg
        button.margin_role.layout_role.image_margin_role.image_role.image = gears.color.recolor_image(image, colors.accent_bg)
    end)

    button:connect_signal("mouse::leave", function ()
        button.fg = colors.base_fg
        button.margin_role.layout_role.image_margin_role.image_role.image = gears.color.recolor_image(image, colors.base_fg)
    end)

    return button
end

return this