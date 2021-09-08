-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library
local wibox = require("wibox")


local naughty = require("naughty")

local volume_control = {}

volume_control.cmd = "amixer -D pulse "
volume_control.get_arg = "get Master"
volume_control.up_arg = "set Master 5%+"
volume_control.down_arg = "set Master 5%-"
volume_control.toggle_arg = "set Master toggle"

volume_control.icons_path = "/usr/share/icons/Adwaita++-Dark-Colorful/status/symbolic/"
volume_control.icon_high = "audio-volume-high-symbolic.svg"
volume_control.icon_medium = "audio-volume-medium-symbolic.svg"
volume_control.icon_low = "audio-volume-low-symbolic.svg"
volume_control.icon_muted = "audio-volume-muted-symbolic.svg"

function volume_control.callback(volume, muted)
    if muted or volume == 0 then
        volume_control.widget.image = volume_control.icons_path .. volume_control.icon_muted
    elseif volume <= 33 then
        volume_control.widget.image = volume_control.icons_path .. volume_control.icon_low
    elseif volume <= 67 then
        volume_control.widget.image = volume_control.icons_path .. volume_control.icon_medium
    else
        volume_control.widget.image = volume_control.icons_path .. volume_control.icon_high
    end
end

function volume_control.parse_cmd_out(cmd)
    local file = io.popen(cmd)
    local out = file:read('*all')
    file:close()
    local volume = tonumber(out:match("(%d?%d?%d)%%"))
    local muted = out:match("%[o[nf]f?%]") == "[off]"
    volume_control.callback(volume, muted)
    return volume, muted
end

function volume_control.get()
    return volume_control.parse_cmd_out(volume_control.cmd .. volume_control.get_arg)
end

function volume_control.up()
    return volume_control.parse_cmd_out(volume_control.cmd .. volume_control.up_arg)
end

function volume_control.down()
    return volume_control.parse_cmd_out(volume_control.cmd .. volume_control.down_arg)
end

function volume_control.toggle()
    return volume_control.parse_cmd_out(volume_control.cmd .. volume_control.toggle_arg)
end

function volume_control.new()
    volume_control.widget = wibox.widget.imagebox(nil, true)
    volume_control.widget:buttons({
        awful.button({ }, 1, function ()
            awful.spawn.spawn("pavucontrol")
        end),
        awful.button({ }, 3, function ()
            volume_control.toggle()
        end),
        awful.button({ }, 4, function ()
            volume_control.up()
        end),
        awful.button({ }, 5, function ()
            volume_control.down()
        end),
    })
    gears.timer({
        timeout = 1,
        autostart = true,
        call_now = true,
        callback = volume_control.get
    })
    return volume_control.widget
end

return volume_control.new