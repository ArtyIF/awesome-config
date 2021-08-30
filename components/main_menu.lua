-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- widget and layout library, might need in the future
local wibox = require("wibox")
-- theme handling library
local beautiful = require("beautiful")
-- hotkeys popup, we might not need it
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

local main_menu = {}

-- generate the app menu (sync) and require it
os.execute("xdg_menu --format awesome --root-menu /etc/xdg/menus/arch-applications.menu > ~/.config/awesome/appmenu.lua")
require("appmenu")

-- awesomewm menu
local menu_awesome = {
    { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end }, -- remove?
    { "Local Awesome Config", "code " .. gears.filesystem.get_configuration_dir() .. "/awesome-config.code-workspace" },
    { "Restart", awesome.restart },
 }

-- favorites menu
-- todo: make this as part of xdgmenu somehow
local menu_favorites = {
    { "Firefox", "firefox" },
    { "Discord", "discord" },
    { "Files", "nautilus" },
    { "Terminal", "konsole" },
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
local menu_items = shallow_copy(xdgmenu)
table.insert(menu_items, 1, { "Favorites", menu_favorites })
table.insert(menu_items, { "Awesome", menu_awesome, beautiful.awesome_icon })
table.insert(menu_items, { "Log Out", function() awesome.quit() end }) -- todo: make it fade out again, but properly

-- the menu itself
main_menu.menu = awful.menu({ items = menu_items })

-- the launcher for the menu
-- todo: make it more elaborate than a simple dropdown. i'm leaning windows 10 style
main_menu.launcher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = main_menu.menu })

return main_menu