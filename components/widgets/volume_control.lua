-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library
local wibox = require("wibox")
local theme_vars = require("beautiful").get()

local this = {}

this.cmd = "amixer -D pulse "
this.get_arg = "get Master"
this.up_arg = "set Master 5%+"
this.down_arg = "set Master 5%-"
this.toggle_arg = "set Master toggle"

this.icons_path = "/usr/share/icons/breeze-dark/status/symbolic/"
this.icon_high = "audio-volume-high-symbolic.svg"
this.icon_medium = "audio-volume-medium-symbolic.svg"
this.icon_low = "audio-volume-low-symbolic.svg"
this.icon_muted = "audio-volume-muted-symbolic.svg"

this.margin_top = theme_vars.wibar_icon_margins
this.margin_right = theme_vars.wibar_icon_margins
this.margin_bottom = theme_vars.wibar_icon_margins
this.margin_left = theme_vars.wibar_icon_margins / 2

function this.callback(volume, muted)
    if muted or volume == 0 then
        this.image_widget.image = this.icons_path .. this.icon_muted
    elseif volume <= 33 then
        this.image_widget.image = this.icons_path .. this.icon_low
    elseif volume <= 67 then
        this.image_widget.image = this.icons_path .. this.icon_medium
    else
        this.image_widget.image = this.icons_path .. this.icon_high
    end
    this.text_widget.text = volume .. "%"
end

function this.parse_cmd_out(cmd)
    local file = io.popen(cmd)
    local out = file:read('*all')
    file:close()
    local volume = tonumber(out:match("(%d?%d?%d)%%"))
    local muted = out:match("%[o[nf]f?%]") == "[off]"
    this.callback(volume, muted)
    return volume, muted
end

function this.get()
    return this.parse_cmd_out(this.cmd .. this.get_arg)
end

function this.up()
    awful.spawn.with_shell("canberra-gtk-play --id=audio-volume-change")
    return this.parse_cmd_out(this.cmd .. this.up_arg)
end

function this.down()
    awful.spawn.with_shell("canberra-gtk-play --id=audio-volume-change")
    return this.parse_cmd_out(this.cmd .. this.down_arg)
end

function this.toggle()
    awful.spawn.with_shell("canberra-gtk-play --id=audio-volume-change")
    return this.parse_cmd_out(this.cmd .. this.toggle_arg)
end


this.image_widget = wibox.widget.imagebox(nil, true)
this.text_widget = wibox.widget.textbox(nil)

this.callback_timer = gears.timer({
    timeout = 1,
    autostart = true,
    call_now = true,
    callback = this.get
})

function this.create_widget()
    this.widget = wibox.container.margin(wibox.layout.fixed.horizontal(this.image_widget, this.text_widget), this.margin_left, this.margin_right, this.margin_top, this.margin_bottom)

    this.widget:buttons({
        awful.button({ }, 1, function ()
            awful.spawn.spawn("pavucontrol")
        end),
        awful.button({ }, 3, function ()
            this.toggle()
        end),
        awful.button({ }, 4, function ()
            this.up()
        end),
        awful.button({ }, 5, function ()
            this.down()
        end),
    })
    
    return this.widget
end

VOLUME_CONTROL = this -- todo: do something similar to other widgets
-- todo: actually, make a global registry with widgets or something
return this