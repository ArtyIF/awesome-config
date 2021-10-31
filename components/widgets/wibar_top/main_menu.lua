
-- standard awesome stuff
local gears = require("gears")
local awful = require("awful")
-- widget and layout library, might need in the future
local wibox = require("wibox")
-- theme handling library
local beautiful = require("beautiful")
local theme_vars = beautiful.get()
-- menugen from menubar
local menubar = require("menubar")
-- hotkeys popup, we might not need it
local hotkeys_popup = require("awful.hotkeys_popup")

local colors = require("theme.colors")
local button = require("components.widgets.common.button")

menubar.utils.wm_name = ""

local this = {
    favorite_items = { "Firefox", "Nemo", "Alacritty", "Visual Studio Code", "Discord", "Steam (Runtime)" },
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
    menubar.menu_gen.generate(function (entries)
        for id, category in pairs(menubar.menu_gen.all_categories) do
            table.insert(this.menus.apps, { id, {}, colors.full_icon_theme_path .. "32x32/categories/" .. category.icon_name .. ".svg" })
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
                    category[1] = menubar.menu_gen.all_categories[category[1]].name
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

        this.button.widget:buttons({
            awful.button({}, 1, function ()
                this.menu:toggle()
            end)
        })
    end)
end

function this.create_widget()
    -- todo: make it more elaborate than a simple dropdown. i'm leaning windows 10 style
    this.button = button.new {
        icon = gears.filesystem.get_configuration_dir() .. "theme/icons/menu.png",
        -- text = "Menu"
    }
    this.build_menu()
    return this.button
end

return this