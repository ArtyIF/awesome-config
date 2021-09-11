-- standard awesome stuff
local awful = require("awful")

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

    client.connect_signal("focus", function ()
        toggle_minimize.minimized = false
    end)

    return toggle_minimize.button
end

return toggle_minimize.new