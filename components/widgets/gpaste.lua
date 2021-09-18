-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library
local wibox = require("wibox")

local this = {}

this.cmd = "gpaste-client "
this.ui_arg = "ui"
-- below are for when i get to writing my own ui with blackjack and wiboxes
this.history_arg = "$(" .. this.cmd .. "get-history) --oneline"
this.select_arg = "select "
this.empty_arg = "empty"

this.icon = "/usr/share/icons/breeze-dark/actions/24/edit-paste.svg"

this.margin_top = 4
this.margin_right = 0
this.margin_bottom = 4
this.margin_left = 0

function this.ui()
    return awful.spawn.spawn(this.cmd .. this.ui_arg)
end

function this.history_arg()
    return awful.spawn.with_shell(this.cmd .. this.history_arg)
end

function this.select(uuid)
    return awful.spawn.with_shell(this.cmd .. this.select_arg .. uuid)
end

function this.empty_arg()
    return awful.spawn.with_shell(this.cmd .. this.empty_arg)
end


this.widget = wibox.widget.imagebox(this.icon, true)

function this.create_widget()
    this.margin = wibox.container.margin(this.widget, this.margin_left, this.margin_right, this.margin_top, this.margin_bottom)

    this.margin:buttons({
        awful.button({ }, 1, function ()
            this.ui()
        end)
    })
    
    return this.margin
end

return this