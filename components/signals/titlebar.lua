local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local this = {}

function this.signal_callback(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, { size = 32 }) : setup {
        {
            wibox.container.margin(nil, 8, 0, 0, 0),
            wibox.container.margin(awful.titlebar.widget.iconwidget(c), 0, 4, 8, 8, nil, false),
            awful.titlebar.widget.floatingbutton(c),
            --awful.titlebar.widget.ontopbutton(c),
            --awful.titlebar.widget.stickybutton(c),
            layout = wibox.layout.fixed.horizontal
        },
        {
            {
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal
        },
        {
            awful.titlebar.widget.minimizebutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end

function this.connect_signals()
    client.connect_signal("request::titlebars", this.signal_callback)
end

return this