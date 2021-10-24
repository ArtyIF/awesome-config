-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library
local wibox = require("wibox")
local theme_vars = require("beautiful").get()
local naughty = require("naughty")

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
            top = theme_vars.titlebar_margins,
            bottom = theme_vars.titlebar_margins - 4,
            widget  = wibox.container.margin,
        },
        {
            nil,
            id     = 'background_role',
            forced_height = 4,
            widget = wibox.container.background,
        },
        layout = wibox.layout.align.vertical,
    },
    bg = theme_vars.bg_minimize,
    widget = wibox.container.background,
}

this.filter = awful.widget.tasklist.filter.currenttags

this.widgets = {}

function this.create_widget(s)
    local wgt = wibox.widget {
        {
            text = "hello world",
            widget = wibox.widget.textbox
        },
        layout = wibox.layout.fixed.horizontal
    }

    client.connect_signal("manage", function (c)
        wgt:add({
            client = c,
            widget = awful.widget.clienticon
        })
    end)
    return wgt
end

return this -- todo: grouping