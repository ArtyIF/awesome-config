local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
local colors = require("theme.colors")
local theme_vars = require("beautiful").get()
local gdk = require("lgi").Gdk

local this = {}

local titlebars = {}
local titlebar_timers = {}

local call_times = 0

local function get_dominant_color(c)
    call_times = call_times + 1

    local c_content = gears.surface(c.content)
    local c_geometry = c:geometry()

    local top_part_colors = {}

    local top_part_string = ""
    local top_part_stride = 0

    do
        local top_part_buffer = gdk.pixbuf_get_from_surface(c_content, 0, 3, c_geometry.width, 1)
        if top_part_buffer then
            local top_part_pixels = top_part_buffer:get_pixels()
            top_part_stride = top_part_buffer:get_n_channels() * 2
            top_part_string = top_part_pixels:gsub(".", function(ch) return ("%02x"):format(ch:byte()) end)
        end

    end

    local current_color = ""
    for x = 0, (c_geometry.width * top_part_stride) - 1, top_part_stride do
        current_color = "#" .. top_part_string:sub(x + 1, x + top_part_stride)
        if top_part_colors[current_color] then
            top_part_colors[current_color] = top_part_colors[current_color] + 1
        else
            top_part_colors[current_color] = 1
        end
    end
    current_color = nil
    top_part_string = nil
    top_part_stride = nil

    collectgarbage()

    local dom_color = ""
    local dom_color_times = 0

    for color, times in pairs(top_part_colors) do
        if times > dom_color_times then
            dom_color = color
            dom_color_times = times
        end
    end

    if dom_color == "#00000000" then
        return colors.base
    end

    return dom_color
end

local function set_titlebar_color(c)
    if titlebars[c.window] and not c.minimized and not c.hidden then
        local dom_color = get_dominant_color(c)
        titlebars[c.window].titlebar_background_domcolor.bg = colors.get_gradient(dom_color)
        titlebars[c.window].titlebar_background_domcolor.fg = colors.get_contrast_color(dom_color)
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
    if SMALL_ELEMENTS then
        titlebar_size = 24
    end

    local this_titlebar = awful.titlebar(c, { size = titlebar_size })
    -- todo: adjust text and buttons color for icons
    this_titlebar:setup({
        {
            {
                wibox.container.margin(nil, theme_vars.titlebar_margins / 2, 0, 0, 0),
                wibox.container.margin(awful.titlebar.widget.iconwidget(c), theme_vars.titlebar_margins / 2, theme_vars.titlebar_margins / 2, theme_vars.titlebar_margins, theme_vars.titlebar_margins, nil, false),
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
        bg = colors.get_gradient(colors.base),
        widget = wibox.container.background
    })
    titlebars[c.window] = this_titlebar
end

function this.manage_signal_callback(c)
    if SMART_TITLEBAR_COLOR == "static" then
        gears.timer({
            timeout = 0.5,
            autostart = true,
            call_now = false,
            single_shot = true,
            callback = function () set_titlebar_color(c) end
        })
    elseif SMART_TITLEBAR_COLOR == "dynamic" then
        titlebar_timers[c.window] = gears.timer({
            timeout = 0.5,
            autostart = true,
            call_now = false,
            single_shot = false,
            callback = function () set_titlebar_color(c) end
        })
    end
end

function this.unmanage_signal_callback(c)
    if SMART_TITLEBAR_COLOR == "once" then
        titlebar_timers[c.window]:stop()
        titlebar_timers[c.window] = nil
    end
    titlebars[c.window] = nil
end

function this.connect_signals()
    client.connect_signal("request::titlebars", this.signal_callback)
    client.connect_signal("request::manage", this.manage_signal_callback)
    client.connect_signal("request::unmanage", this.unmanage_signal_callback)
end

return this
