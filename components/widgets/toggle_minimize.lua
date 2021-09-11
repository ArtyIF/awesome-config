-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library, might need in the future
local wibox = require("wibox")
-- theme handling library
local beautiful = require("beautiful")

local toggle_minimize = {minimized = false, minimize_history = {}}

function toggle_minimize.new(s)
    -- not sure if that's the best option for multiple screens, gotta fix it later
    toggle_minimize.button = awful.widget.button({image = "/usr/share/icons/breeze-dark/places/24/desktop.svg"})

    toggle_minimize.button:buttons({
        awful.button({}, 1, function ()
            if not toggle_minimize.minimized then toggle_minimize.minimize_history = {} end
            for i, client in ipairs(s.all_clients) do
                if not toggle_minimize.minimized then
                    toggle_minimize.minimize_history[client.window] = client.minimized
                    client.minimized = true
                else
                    client.minimized = toggle_minimize.minimize_history[client.window] or false
                end
            end
            toggle_minimize.minimized = not toggle_minimize.minimized
        end)
    })

    return toggle_minimize.button
end

return toggle_minimize.new