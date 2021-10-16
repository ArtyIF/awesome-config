-- standard awesome stuff
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local this = {minimized = false, minimize_history = {}}

function this.create_widget(s)
    local toggle_minimize = wibox.widget.imagebox(gears.filesystem.get_configuration_dir() .. "themes/artytheme/icons/minimize.png")
    toggle_minimize.forced_width = 6
    toggle_minimize.vertical_fit_policy = "fit"
    toggle_minimize.horizontal_fit_policy = "fit"

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