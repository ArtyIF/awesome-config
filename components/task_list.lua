-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- widget and layout library
local wibox = require("wibox")
-- theme handling library
local beautiful = require("beautiful")

local task_list = {}

local task_list_buttons = gears.table.join(
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

local task_list_template = {
    {
        {
            {
                id     = 'icon_role',
                widget = wibox.widget.imagebox,
            },
            margins = 8,
            widget  = wibox.container.margin,
        },
        {
            {
                id     = 'text_role',
                widget = wibox.widget.textbox,
                forced_width = beautiful.menu_width
            },
            right = 8,
            widget = wibox.container.margin,
        },
        layout = wibox.layout.align.horizontal
    },
    id     = 'background_role',
    widget = wibox.container.background,
}

function task_list.new(s)
    return awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = task_list_buttons,
        layout = {
            layout = wibox.layout.fixed.horizontal,
        },
        widget_template = task_list_template
    }
end

return task_list