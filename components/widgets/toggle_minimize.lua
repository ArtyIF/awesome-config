-- standard awesome stuff
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local this = {minimized = false, minimize_history = {}}

function this.create_widget(s)
    local toggle_minimize = wibox.container.background(nil, beautiful.get().bg_focus)
    toggle_minimize.forced_width = 4

    toggle_minimize:buttons({
        awful.button({}, 1, function ()
            if not this.minimized then this.minimize_history = {} end
            for i, client in ipairs(s.all_clients) do
                if not this.minimized then
                    this.minimize_history[client.window] = client.minimized
                    client.minimized = true
                else
                    client.minimized = this.minimize_history[client.window] or false
                end
            end
            this.minimized = not this.minimized
        end)
    })

    client.connect_signal("focus", function ()
        this.minimized = false
    end)

    return toggle_minimize
end

return this