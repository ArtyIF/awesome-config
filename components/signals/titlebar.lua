local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
local theme_vars = require("beautiful").get()

local this = {}

local gdk = require("lgi").Gdk

local function get_dominant_color(c)
    local c_content = gears.surface(c.content)
    local c_geometry = c:geometry()

    local colors = {}

    for x = 0, c_geometry.width - 1, 4 do
        local top_part_buffer = gdk.pixbuf_get_from_surface(c_content, x, 0, 1, 1):get_pixels()
        local current_color = "#" .. top_part_buffer:gsub(".", function(col) return ("%02x"):format(col:byte()) end):sub(1, 6)
        if colors[current_color] then
            colors[current_color] = colors[current_color] + 1
        else
            colors[current_color] = 1
        end
    end

    local dom_color = "#000000"
    local dom_color_times = 0
    for color, times in pairs(colors) do
        if times > dom_color_times then
            dom_color = color
            dom_color_times = times
        end
    end

    --naughty.notification({ title = c.name, text = dom_color })
    return dom_color
end

local function get_gradient_color(col)
    local r = tonumber(col:sub(2, 3), 16)
    local g = tonumber(col:sub(4, 5), 16)
    local b = tonumber(col:sub(6, 7), 16)

    r = r + 8
    g = g + 8
    b = b + 8

    if r > 255 then r = 255 end
    if g > 255 then g = 255 end
    if b > 255 then b = 255 end

    return "#" .. string.format("%02x", r) .. string.format("%02x", g) .. string.format("%02x", b)
end

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

    local titlebar_widgets = {
        {
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
            layout = wibox.layout.align.horizontal,
        },
        bg = "transparent",
        widget = wibox.container.background
    }

    awful.titlebar(c, { size = titlebar_size }):setup(titlebar_widgets)

    --[[ gears.timer({
        timeout = 0.25,
        autostart = true,
        call_now = false,
        single_shot = true,
        callback = function ()
            local dom_color = get_dominant_color(c)
            titlebar_widgets.bg = {
                type = "linear",
                from = { 0, 0 },
                to = { 0, 32 },
                stops = {
                    { 0, get_gradient_color(dom_color) },
                    { 1, dom_color }
                }
            }
            awful.titlebar(c, { size = titlebar_size }):setup(titlebar_widgets)
        end
    }) ]]
end

function this.connect_signals()
    client.connect_signal("request::titlebars", this.signal_callback)
end

return this