-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library
local wibox = require("wibox")
local theme_vars = require("beautiful").get()
local colors = require("theme.colors")
local naughty = require("naughty")

local this = {}

-- todo: rewrite this to be more oop
function this.create_widget(args)
    if not args then args = {} end

    local margins = args.margins or theme_vars.wibar_icon_margins

    local content = {
        id = "layout_role",
        layout = wibox.layout.fixed.horizontal
    }

    if args.image then
        content[1] = {
            id = "image_role",
            image = (function()
                if args.do_not_recolor_icon then
                    return args.image
                else
                    return gears.color.recolor_image(args.image, colors.base_fg)
                end
            end)(),
            widget = wibox.widget.imagebox
        }
    end
    if args.text then
        content[2] = {
            id = "text_role",
            text = args.text,
            widget = wibox.widget.textbox
        }
    end
    if args.image and args.text then
        table.insert(content, 2, {
            id = "padding_role",
            margins = { left = margins },
            widget = wibox.container.margin
        })
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

    function button:set_image(new_image)
        args.image = new_image
        if not args.do_not_recolor_icon then
            if self.mouse_is_over then
                self.margin_role.layout_role.image_role.image = gears.color.recolor_image(args.image, colors.accent_bg)
            else
                self.margin_role.layout_role.image_role.image = gears.color.recolor_image(args.image, colors.base_fg)
            end
        end
    end

    function button:set_text(new_text)
        self.margin_role.layout_role.text_role.text = new_text
    end

    function button:set_markup(new_text)
        self.margin_role.layout_role.text_role.markup = new_text
    end

    button:connect_signal("mouse::enter", function ()
        button.mouse_is_over = true
        button.fg = colors.accent_bg
        if not args.do_not_recolor_icon then
            button.margin_role.layout_role.image_role.image = gears.color.recolor_image(args.image, colors.accent_bg)
        end
    end)

    button:connect_signal("mouse::leave", function ()
        button.mouse_is_over = false
        button.fg = colors.base_fg
        if not args.do_not_recolor_icon then
            button.margin_role.layout_role.image_role.image = gears.color.recolor_image(args.image, colors.base_fg)
        end
    end)

    button:buttons({
        awful.button({ }, 1, args.on_left_click),
        awful.button({ }, 2, args.on_middle_click),
        awful.button({ }, 3, args.on_right_click),
        awful.button({ }, 4, args.on_scroll_up),
        awful.button({ }, 5, args.on_scroll_down),
    })

    return button
end

return this