-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library
local wibox = require("wibox")

local task_list = {}

task_list.layout = {
    layout = wibox.layout.flex.horizontal,
}

-- todo: move to keybinds
task_list.buttons = gears.table.join(
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

task_list.template = {
    {
        {
            {
                id     = 'icon_role',
                widget = wibox.widget.imagebox,
            },
            margins = 4,
            widget  = wibox.container.margin,
        },
        {
            {
                id     = 'text_role',
                widget = wibox.widget.textbox,
            },
            left = 4,
            right = 4,
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
        buttons = task_list.buttons,
        layout = task_list.layout,
        widget_template = task_list.template
    }
end

return task_list.new