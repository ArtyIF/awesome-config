-- standard awesome stuff
local awful = require("awful")
local theme_vars = require("beautiful").get()
local wibox = require("wibox")

local this = {minimized = false, minimize_history = {}}

function this.create_widget(s)
    local toggle_minimize = wibox.container.background(nil, theme_vars.tasklist_bg_normal)
    toggle_minimize.forced_width = 2

    toggle_minimize:buttons({
        awful.button({}, 1, function ()
            if not this.minimized then this.minimize_history = {} end
            for _, client in ipairs(s.all_clients) do
                if not this.minimized then
                    this.minimize_history[client.window] = client.minimized
                    client.minimized = true
                else
                    client.minimized = this.minimize_history[client.window] or false
                end
            end
            this.minimized = not this.minimized
            if this.minimized then
                toggle_minimize.bg = theme_vars.tasklist_bg_focus
            else
                toggle_minimize.bg = theme_vars.tasklist_bg_normal
            end
        end)
    })

    client.connect_signal("focus", function ()
        this.minimized = false
        toggle_minimize.bg = theme_vars.tasklist_bg_normal
    end)

    return toggle_minimize
end

return this