-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library
local wibox = require("wibox")

local volume_control = {}

function volume_control.new()
    volume_control.widget = wibox.widget.imagebox()
end