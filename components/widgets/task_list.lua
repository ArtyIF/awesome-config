-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library
local wibox = require("wibox")
local theme_vars = require("beautiful").get()

local this = {}

this.layout = {
    layout = wibox.layout.flex.horizontal,
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
        {
            {
                id = "clienticon",
                widget = awful.widget.clienticon,
            },
            margins = theme_vars.titlebar_margins,
            widget  = wibox.container.margin,
        },
        {
            {
                id     = 'text_role',
                widget = wibox.widget.textbox,
            },
            right = theme_vars.titlebar_margins,
            widget = wibox.container.margin,
        },
        layout = wibox.layout.align.horizontal
    },
    id     = 'background_role',
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

return this