-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library
local wibox = require("wibox")
local theme_vars = require("beautiful").get()
local colors = require("theme.colors")
local naughty = require("naughty")

local button = {
    margins = theme_vars.wibar_icon_margins,
    icon = "",
    do_not_recolor_icon = false,
    mouse_is_over = false,
    text = "",
    widget = wibox.container.background()
}

function button:update_icon()
    if not self.do_not_recolor_icon then
        if self.mouse_is_over then
            self.widget.margin_role.layout_role.icon_role.image = gears.color.recolor_image(self.icon, colors.accent_bg)
        else
            self.widget.margin_role.layout_role.icon_role.image = gears.color.recolor_image(self.icon, colors.base_fg)
        end
    else
        self.widget.margin_role.layout_role.icon_role.image = self.icon
    end
end

function button:update_text()
    self.widget.margin_role.layout_role.text_role.text = self.text
end

function button:new(args)
    if not args then args = {} end

    local o = {}
    setmetatable(o, self)
    self.__index = self

    self.margins = args.margins or theme_vars.wibar_icon_margins

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
    if args.icon and args.text then
        table.insert(content, 2, {
            id = "padding_role",
            margins = { left = self.margins },
            widget = wibox.container.margin
        })
    end

    self.widget:setup {
        content,
        id = "margin_role",
        margins = self.margins,
        widget = wibox.container.margin
    }

    self.widget:connect_signal("mouse::enter", function ()
        o.mouse_is_over = true
        o.widget.fg = colors.accent_bg
        o:update_icon()
    end)

    self.widget:connect_signal("mouse::leave", function ()
        o.mouse_is_over = false
        o.widget.fg = colors.base_fg
        o:update_icon()
    end)

    self.widget:buttons({
        awful.button({ }, 1, args.on_left_click),
        awful.button({ }, 2, args.on_middle_click),
        awful.button({ }, 3, args.on_right_click),
        awful.button({ }, 4, args.on_scroll_up),
        awful.button({ }, 5, args.on_scroll_down),
    })

    self.icon = args.icon
    self:update_icon()

    self.text = args.text
    self:update_text()

    self.widget.button_wrapper = self

    return o
end

return button