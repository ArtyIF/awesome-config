-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library
local wibox = require("wibox")
local theme_vars = require("beautiful").get()
local colors = require("theme.colors")
local naughty = require("naughty")

local button = {}

function button.new(args)
    if not args then args = {} end

    local btn = {}

    function btn:update_icon()
        if self.widget.margin_role.layout_role.icon_role then
            if not self.do_not_recolor_icon then
                if self.mouse_is_over then
                    self.widget.margin_role.layout_role.icon_role.image = colors.recolor_icon(self.icon, colors.accent)
                else
                    self.widget.margin_role.layout_role.icon_role.image = colors.recolor_icon(self.icon)
                end
            else
                self.widget.margin_role.layout_role.icon_role.image = self.icon
            end
        end
    end

    function btn:update_text()
        if self.widget.margin_role.layout_role.text_role then
            self.widget.margin_role.layout_role.text_role.text = self.text
        end
    end

    btn.margins = args.margins or theme_vars.wibar_icon_margins

    local content = {
        id = "layout_role",
        layout = wibox.layout.fixed.horizontal
    }

    if args.icon then
        content[1] = {
            id = "icon_role",
            image = nil,
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
    if args.icon and args.text and not args.do_not_add_padding then
        table.insert(content, 2, {
            id = "padding_role",
            margins = { left = btn.margins },
            widget = wibox.container.margin
        })
    end

    btn.widget = wibox.container.background()
    btn.widget:setup {
        content,
        id = "margin_role",
        margins = btn.margins,
        widget = wibox.container.margin
    }

    btn.widget:connect_signal("mouse::enter", function ()
        btn.mouse_is_over = true
        btn.widget.fg = colors.accent
        btn:update_icon()
    end)

    btn.widget:connect_signal("mouse::leave", function ()
        btn.mouse_is_over = false
        btn.widget.fg = colors.base_text
        btn:update_icon()
    end)

    btn.widget:buttons({
        awful.button({ }, 1, args.on_left_click),
        awful.button({ }, 2, args.on_middle_click),
        awful.button({ }, 3, args.on_right_click),
        awful.button({ }, 4, args.on_scroll_up),
        awful.button({ }, 5, args.on_scroll_down),
    })

    btn.icon = args.icon
    btn:update_icon()

    btn.text = args.text
    btn:update_text()

    return btn
end

return button