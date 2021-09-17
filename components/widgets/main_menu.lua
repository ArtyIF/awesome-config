-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library, might need in the future
local wibox = require("wibox")
-- theme handling library
local beautiful = require("beautiful")
-- hotkeys popup, we might not need it
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

local this = {menus = {}}

-- generate the app menu (sync) and require it
-- todo: replace with a better option since these files aren't easily editable neither by alacarte or kmenuedit
os.execute("xdg_menu --fullmenu --format awesome --root-menu /etc/xdg/menus/applications.menu > ~/.config/awesome/appmenu.lua")
require("appmenu")

-- awesomewm menu
this.menus.awesome = {
    { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end }, -- remove?
    { "Local Awesome Config", "code " .. gears.filesystem.get_configuration_dir() .. "/awesome-config.code-workspace" },
    { "Restart", awesome.restart },
 }

-- favorites menu
-- todo: make this as part of xdgmenu somehow
this.menus.favorites = {
    { "Web Browser", "firefox" },
    { "Email Client", "thunderbird" },
    { "Files", "pcmanfm" },
    { "Terminal", "konsole" },
    { "Discord", "discord" },
    { "Steam", "steam-runtime" },
}

-- taken from roblox docs, clones a table
-- todo: move to separate file for everything
local function shallow_copy(original)
    local copy = {}
    for key, value in pairs(original) do
        copy[key] = value
    end
    return copy
end

-- the entries that are actually going to be in the menu. first favorites, then all the xdg categories, then awesomewm and then an option to log out
this.items = shallow_copy(xdgmenu)
table.insert(this.items, 1, { "Favorites", this.menus.favorites })
table.insert(this.items, { "Awesome", this.menus.awesome, beautiful.awesome_icon })
table.insert(this.items, { "Log Out", function() awesome.quit() end }) -- todo: make it fade out again, but properly

-- the menu itself
this.menu = awful.menu({ items = this.items })

root.buttons({
    awful.button({}, 1, function ()
        this.menu:hide()
    end),
    awful.button({}, 3, function ()
        this.menu:toggle()
    end)
})

function this.create_widget()
    -- todo: make it more elaborate than a simple dropdown. i'm leaning windows 10 style
    local menu_button = awful.widget.button({ image = "/usr/share/icons/breeze-dark/actions/32/application-menu.svg" })

    menu_button:buttons({
        awful.button({}, 1, function ()
            this.menu:toggle()
        end)
    })

    return menu_button
end

return this