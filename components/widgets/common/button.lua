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
    local content = {
        {
            id = "button_image",
            image = image,
            widget = wibox.widget.imagebox,
        },
        id = "button_layout",
        layout = wibox.layout.fixed.horizontal,
        widget = wibox.container.background
    }
    if args.text then
        content[2] = {
            id = "button_text",
            text = args.text,
            widget = wibox.widget.textbox,
        }
    end
    local button = wibox.widget {
        content,
        widget = wibox.container.background
    }

    return button
end

return this