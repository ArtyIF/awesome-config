-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library
local wibox = require("wibox")
local theme_vars = require("beautiful").get()
local colors = require("theme.colors")
local button = require("components.widgets.common.button")

local this = {}

this.cmd = "copyq "
this.ui_arg = "toggle"

this.icon = colors.recolor_icon(gears.filesystem.get_configuration_dir() .. "theme/icons/clipboard.png")

this.margins = theme_vars.wibar_icon_margins

function this.ui()
    return awful.spawn.spawn(this.cmd .. this.ui_arg)
end


this.widget = wibox.widget.imagebox(this.icon, true)

function this.create_widget()
    this.button = button.new {
        icon = this.icon,
        --text = "Clipboard",
        on_left_click = function ()
            this.ui()
        end
    }

    return this.button
end

return this