-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library
local wibox = require("wibox")
local theme_vars = require("beautiful").get()
local colors = require("theme.colors")
local button = require("components.widgets.common.button")

local this = {}

this.cmd = "pactl "
this.get_volume_arg = "get-sink-volume 0"
this.get_mute_arg = "get-sink-mute 0"
this.up_arg = "set-sink-volume 0 +5%"
this.down_arg = "set-sink-volume 0 -5%"
this.toggle_arg = "set-sink-mute 0 toggle"
this.clamp_volume_arg = "set-sink-volume 0 100%"

this.icons_path = colors.full_icon_theme_path .. "symbolic/status/"
this.icon_high = "audio-volume-high-symbolic.svg"
this.icon_medium = "audio-volume-medium-symbolic.svg"
this.icon_low = "audio-volume-low-symbolic.svg"
this.icon_muted = "audio-volume-muted-symbolic.svg"

this.margins = theme_vars.wibar_icon_margins

function this.callback(volume, muted)
    if not volume then
        return
    end
    if volume > 100 then
        this.execute_and_get_output(this.cmd .. this.clamp_volume_arg)
	    volume = 100
    end
    if muted or volume == 0 then
        this.widget:set_image(this.icons_path .. this.icon_muted)
    elseif volume <= 33 then
        this.widget:set_image(this.icons_path .. this.icon_low)
    elseif volume <= 67 then
        this.widget:set_image(this.icons_path .. this.icon_medium)
    else
        this.widget:set_image(this.icons_path .. this.icon_high)
    end
    this.widget:set_text(volume .. "%")
end

function this.execute_and_get_output(cmd)
    local file = io.popen(cmd)
    local out = file:read('*all')
    file:close()
    return out
end

function this.get()
    local volume_out = this.execute_and_get_output(this.cmd .. this.get_volume_arg)
    local mute_out = this.execute_and_get_output(this.cmd .. this.get_mute_arg)
    local volume = tonumber(volume_out:match("(%d?%d?%d)%%"))
    local muted = mute_out:match("Mute: yes")
    this.callback(volume, muted)
    return volume, muted
end

function this.up()
    this.execute_and_get_output(this.cmd .. this.up_arg)
    awful.spawn.spawn("canberra-gtk-play --id=audio-volume-change", false)
    return this.get()
end

function this.down()
    this.execute_and_get_output(this.cmd .. this.down_arg)
    awful.spawn.spawn("canberra-gtk-play --id=audio-volume-change", false)
    return this.get()
end

function this.toggle()
    this.execute_and_get_output(this.cmd .. this.toggle_arg)
    awful.spawn.spawn("canberra-gtk-play --id=audio-volume-change", false)
    return this.get()
end

function this.create_widget()
    this.widget = button.create_widget {
        image = this.icons_path .. this.icon_muted,
        margins = this.margins,
        text = "...%",
        on_left_click = function ()
            awful.spawn.spawn("pavucontrol")
        end,
        on_right_click = function ()
            this.toggle()
        end,
        on_scroll_up = function ()
            this.up()
        end,
        on_scroll_down = function ()
            this.down()
        end
    }
    
    this.callback_timer = gears.timer({
        timeout = 1,
        autostart = true,
        call_now = true,
        callback = this.get
    })
    
    return this.widget
end

VOLUME_CONTROL = this -- todo: do something similar to other widgets
-- todo: actually, make a global registry with widgets or something
return this
