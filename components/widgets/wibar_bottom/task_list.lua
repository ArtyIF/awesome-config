-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library
local wibox = require("wibox")
local theme_vars = require("beautiful").get()
local modkeys = require("components.keybinds.modkeys")

local this = {}

this.layout = {
    layout = wibox.layout.fixed.horizontal,
}

-- todo: move to keybinds
this.buttons = gears.table.join(
    awful.button({ }, 1,
        function (c)
            if c == client.focus then
                c.minimized = true
            else
                c:emit_signal("request::activate", "tasklist", { raise = true })
            end
        end
    ),
    awful.button({ modkeys.super }, 1, function (c)
        c:swap(client.focus)
    end),
    awful.button({ }, 3,
        function()
            awful.menu.client_list() -- todo: replace with a better menu
        end
    ),
    awful.button({ }, 4,
        function ()
            awful.client.focus.byidx(1)
        end
    ),
    awful.button({ }, 5,
        function ()
            awful.client.focus.byidx(-1)
        end
    )
)

this.template = {
    {
        nil,
        {
            {
                widget = awful.widget.clienticon,
                forced_width = theme_vars.bottom_wibar_height - theme_vars.titlebar_margins * 2
            },
            left = theme_vars.titlebar_margins * 2,
            right = theme_vars.titlebar_margins * 2,
            top = theme_vars.titlebar_margins - 2,
            bottom = theme_vars.titlebar_margins - 2,
            widget  = wibox.container.margin,
        },
        {
            id = 'background_role',
            forced_height = 4,
            widget = wibox.container.background,
        },
        layout = wibox.layout.align.vertical,
    },
    bg = theme_vars.bg_minimize,
    widget = wibox.container.background,
}

this.filter = awful.widget.tasklist.filter.currenttags

function this.create_widget(s)
    return awful.widget.tasklist {
        screen = s,
        filter = this.filter,
        buttons = this.buttons,
        layout = this.layout,
        widget_template = this.template
    }
end

return this -- todo: grouping