-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library
local wibox = require("wibox")
local theme_vars = require("beautiful").get()
local colors = require("theme.colors")
local naughty = require("naughty")

local button = require("components.widgets.common.button")

local this = {}

this.icons_path = colors.full_icon_theme_path .. "symbolic/status/"
this.icon_muted = "audio-volume-muted-symbolic.svg"

function this.create_widget()
    this.widget = button.create_widget(this.icons_path .. this.icon_muted, function ()
        naughty.notification({ text = "hello!" })
    end)
    
    return this.widget
end

return this