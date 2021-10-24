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
this.max_vol_arg = "set-sink-volume 0 100%"
this.toggle_arg = "set-sink-mute 0 toggle"

this.icons_path = colors.full_icon_theme_path .. "symbolic/status/"
this.icon_high = "audio-volume-high-symbolic.svg"
this.icon_medium = "audio-volume-medium-symbolic.svg"
this.icon_low = "audio-volume-low-symbolic.svg"
this.icon_muted = "audio-volume-muted-symbolic.svg"

function this.callback(volume, muted)
    if not volume then
        return
    end
    if volume > 100 then
        this.execute_and_get_output(this.cmd .. this.max_vol_arg)
        return this.get()
    end
    if muted or volume == 0 then
        this.image_widget.image = this.icons_path .. this.icon_muted
    elseif volume <= 33 then
        this.image_widget.image = this.icons_path .. this.icon_low
    elseif volume <= 67 then
        this.image_widget.image = this.icons_path .. this.icon_medium
    else
        this.image_widget.image = this.icons_path .. this.icon_high
    end
    this.text_widget.text = " " .. volume .. "%"
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
    awful.spawn.with_shell("canberra-gtk-play --id=audio-volume-change")
    return this.get()
end

function this.down()
    this.execute_and_get_output(this.cmd .. this.down_arg)
    awful.spawn.with_shell("canberra-gtk-play --id=audio-volume-change")
    return this.get()
end

function this.toggle()
    this.execute_and_get_output(this.cmd .. this.toggle_arg)
    awful.spawn.with_shell("canberra-gtk-play --id=audio-volume-change")
    return this.get()
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
    this.widget = button.create_widget(
        wibox.layout.fixed.horizontal(this.image_widget, this.text_widget),
        function ()
            awful.spawn.spawn("pavucontrol")
        end,
        {
            on_right_click = function ()
                this.toggle()
            end,
            on_scroll_up = function ()
                this.up()
            end,
            on_scroll_down = function ()
                this.down()
            end,
            imageboxes_to_recolor = { this.image_widget },
        })

    return this.widget
end

VOLUME_CONTROL = this -- todo: do something similar to other widgets
-- todo: actually, make a global registry with widgets or something
return this