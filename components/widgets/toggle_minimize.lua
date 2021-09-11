-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library, might need in the future
local wibox = require("wibox")
-- theme handling library
local beautiful = require("beautiful")

local toggle_minimize = {}

function toggle_minimize.new(s)
    -- not sure if that's the best option for multiple screens, gotta fix it later
    toggle_minimize.button = awful.widget.button({image = "/usr/share/icons/breeze-dark/places/24/desktop.svg"})

    toggle_minimize.button:buttons({
        awful.button({}, 1, function ()
            -- todo: history
            for i, client in ipairs(s.all_clients) do
                client.minimized = true
            end
        end)
    })

    return toggle_minimize.button
end

return toggle_minimize.new