local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local theme_vars = require("beautiful").get()

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

    local titlebar_size = 32
    if COMPACT_MODE then
        titlebar_size = 24
    end

    awful.titlebar(c, { size = titlebar_size }) : setup {
        {
            wibox.container.margin(nil, theme_vars.titlebar_margins, 0, 0, 0),
            wibox.container.margin(awful.titlebar.widget.iconwidget(c), 0, theme_vars.titlebar_margins / 2, theme_vars.titlebar_margins, theme_vars.titlebar_margins, nil, false),
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