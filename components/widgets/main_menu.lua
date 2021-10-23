
-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library, might need in the future
local wibox = require("wibox")
-- theme handling library
local beautiful = require("beautiful")
local theme_vars = beautiful.get()
-- menugen from menubar
local menu_gen = require("menubar.menu_gen")
local menu_utils = require("menubar.utils")
-- hotkeys popup, we might not need it
local hotkeys_popup = require("awful.hotkeys_popup")


local naughty = require("naughty")

local this = {
    favorite_items = { "Firefox", "Nemo", "Alacritty", "Discord", "Steam (Runtime)" },
    menus = {
        favorites = {},
        apps = {},
        awesome = {
            { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end }, -- remove?
            { "Config", "code " .. gears.filesystem.get_configuration_dir() .. "/awesome-config.code-workspace" },
            { "Restart", awesome.restart },
        },
        system = {
            { "Upgrade", function()
                awful.spawn.spawn("alacritty -e yay -Syu --devel")
            end },
        },
        session = {
            { "Lock", function () awful.spawn.spawn("light-locker-command -l", false) end },
            { "Log Out", function() awesome.quit() end },
        },
        power = {
            { "Sleep", function() awful.spawn.spawn("systemctl suspend", false) end },
            { "Reboot", function() awful.spawn.spawn("systemctl reboot", false) end },
            { "Shut Down", function() awful.spawn.spawn("systemctl poweroff", false) end },
        },
    }
}

function this.build_menu()
    menu_gen.generate(function (entries)
        for id, category in pairs(menu_gen.all_categories) do
            table.insert(this.menus.apps, { id, {}, os.getenv("HOME") .. "/.icons/oomox-ArtyTheme-Dark/32x32/categories/" .. category.icon_name .. ".svg" })
        end

        for _, entry in pairs(entries) do
            for _, category in pairs(this.menus.apps) do
                if category[1] == entry.category then
                    table.insert(category[2], { entry.name, entry.cmdline, entry.icon })
                    for _, fav_entry in ipairs(this.favorite_items) do
                        if string.sub(entry.name, 1, #fav_entry) == fav_entry then
                            table.insert(this.menus.favorites, { entry.name, entry.cmdline, entry.icon })
                            break
                        end
                    end
                    break
                end
            end
        end

        for id = #this.menus.apps, 1, -1 do -- doing it in reverse prevents shifting
            local category = this.menus.apps[id]
            if #category[2] == 0 then
                table.remove(this.menus.apps, id)
            else
                if category[1] ~= "Favorites" then
                    category[1] = menu_gen.all_categories[category[1]].name
                end
            end
        end

        table.sort(this.menus.apps, function (a, b) return string.byte(a[1]) < string.byte(b[1]) end)
        for _, category in ipairs(this.menus.apps) do
            table.sort(category[2], function (a, b) return string.byte(a[1]) < string.byte(b[1]) end)
        end

        table.sort(this.menus.favorites, function (a, b)
            local a_index = 0
            local b_index = 0
            for index, value in ipairs(this.favorite_items) do
                if a[1] == value then
                    a_index = index
                elseif b[1] == value then
                    b_index = index
                end
            end

            return a_index < b_index
        end)

        table.insert(this.menus.apps, 1, { "Favorites", this.menus.favorites })


        this.items = {}
        for _, category in pairs(this.menus.apps) do
            table.insert(this.items, category)
        end
        table.insert(this.items, { "System", this.menus.system })
        table.insert(this.items, { "Awesome", this.menus.awesome, beautiful.awesome_icon })
        table.insert(this.items, { "Session", this.menus.session })
        table.insert(this.items, { "Power", this.menus.power })

        this.menu = awful.menu({ items = this.items })
        root.buttons({
            awful.button({}, 1, function ()
                this.menu:hide()
            end),
            awful.button({}, 3, function ()
                this.menu:toggle()
            end)
        })

        this.button:buttons({
            awful.button({}, 1, function ()
                this.menu:toggle()
            end)
        })
    end)
end

function this.create_widget()
    -- todo: make it more elaborate than a simple dropdown. i'm leaning windows 10 style
    this.button = wibox.container.margin(wibox.widget.imagebox(gears.filesystem.get_configuration_dir() .. "theme/icons/menu.png"))
    this.button.margins = theme_vars.wibar_icon_margins
    this.build_menu()
    return this.button
end

return this