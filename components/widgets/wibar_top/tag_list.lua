-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library
local wibox = require("wibox")
-- theme handling library
local beautiful = require("beautiful")
local modkeys = require("components.keybinds.modkeys")

local this = {}

-- todo: move to keybinds
this.buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkeys.super }, 1, function(t)
                                if client.focus then
                                    client.focus:move_to_tag(t)
                                    t:view_only() -- more logical this way
                                end
                            end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkeys.super }, 3, function(t)
                                if client.focus then
                                    client.focus:toggle_tag(t)
                                end
                            end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

this.layout = {
    layout = wibox.layout.fixed.horizontal,
}

this.filter = awful.widget.taglist.filter.all

this.tag = { "1", "2", "3" }

function this.create_widget(s)
    awful.tag(this.tag, s, awful.layout.layouts[1]) -- todo: make more dynamic. right now i can switch between them using the 1-2-3 macros on my keyboard, that behaviour is in rc.lua for now
    return awful.widget.taglist {
        screen  = s,
        filter  = this.filter,
        buttons = this.buttons
    }
end

return this