local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
local theme_vars = require("beautiful").get()
local gdk = require("lgi").Gdk

local this = {}

local titlebars = {}

local function get_dominant_color(c)
    local c_content = gears.surface(c.content)
    local c_geometry = c:geometry()

    local colors = {}

    local top_part_string = ""
    local top_part_stride = 0

    do
        local top_part_buffer = gdk.pixbuf_get_from_surface(c_content, 0, 0, c_geometry.width, 1)
        if top_part_buffer then
            local top_part_pixels = top_part_buffer:get_pixels()
            top_part_stride = top_part_buffer:get_n_channels() * 2
            top_part_string = top_part_pixels:gsub(".", function(ch) return ("%02x"):format(ch:byte()) end)
        end

    end

    local current_color = ""
    for x = 0, (c_geometry.width * top_part_stride) - 1, top_part_stride do
        current_color = "#" .. top_part_string:sub(x + 1, x + top_part_stride)
        if colors[current_color] then
            colors[current_color] = colors[current_color] + 1
        else
            colors[current_color] = 1
        end
    end
    current_color = nil
    top_part_string = nil
    top_part_stride = nil

    collectgarbage()

    local dom_color = ""
    local dom_color_times = 0

    for color, times in pairs(colors) do
        if times > dom_color_times then
            dom_color = color
            dom_color_times = times
        end
    end

    if dom_color == "#00000000" then
        return "#171717"
    end

    return dom_color
end

local function get_gradient_color(col)
    if col ~= "" then
        local r = tonumber(col:sub(2, 3), 16)
        local g = tonumber(col:sub(4, 5), 16)
        local b = tonumber(col:sub(6, 7), 16)

        r = r + 8
        g = g + 8
        b = b + 8

        if r > 255 then r = 255 end
        if g > 255 then g = 255 end
        if b > 255 then b = 255 end

        local result = "#" .. string.format("%02x", r) .. string.format("%02x", g) .. string.format("%02x", b)
        if col:len() == 9 then
            result = result .. col:sub(8, 9)
        end

        return result
    else
        return ""
    end
end

local function set_titlebar_color(c)
    if titlebars[c.window] and not c.minimized and not c.hidden then
        local dom_color = get_dominant_color(c)
        titlebars[c.window].titlebar_background_domcolor.bg = {
            type = "linear",
            from = { 0, 0 },
            to = { 0, 32 },
            stops = {
                { 0, get_gradient_color(dom_color) },
                { 1, dom_color }
            }
        }
        dom_color = nil
    end
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

    local this_titlebar = awful.titlebar(c, { size = titlebar_size })
    -- todo: adjust text and buttons color for icons
    this_titlebar:setup({
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
        id = "titlebar_background_domcolor",
        bg = "transparent",
        widget = wibox.container.background
    })
    titlebars[c.window] = this_titlebar

    gears.timer({
        timeout = 0.25,
        autostart = true,
        call_now = false,
        single_shot = true,
        callback = function () set_titlebar_color(c) end
    })
end

function this.manage_signal_callback(c)
    gears.timer({
        timeout = 0.1,
        autostart = true,
        call_now = false,
        single_shot = true,
        callback = function () set_titlebar_color(c) end
    })
end

function this.unmanage_signal_callback(c)
    titlebars[c.window] = nil
end

function this.connect_signals()
    client.connect_signal("request::titlebars", this.signal_callback)
    client.connect_signal("request::manage", this.manage_signal_callback)
    client.connect_signal("request::unmanage", this.unmanage_signal_callback)
end

return this
