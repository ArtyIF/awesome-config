-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

require("config")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notification({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notification({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
local theme_path = gears.filesystem.get_configuration_dir() .. "theme/theme.lua"
beautiful.init(theme_path)

-- components
local top_wibar = require("components.wibars.top")
local bottom_wibar = require("components.wibars.bottom")

local modkeys = require("components.keybinds.modkeys")
local leftover_keybinds = require("components.keybinds.leftover_keybinds")
local screenshot_spectacle_keybinds = require("components.keybinds.screenshot_spectacle")
local sound_keybinds = require("components.keybinds.sound")
local awesome_keybinds = require("components.keybinds.awesome")
local window_keybinds = require("components.keybinds.window")
local keyboard_layout_keybinds = require("components.keybinds.keyboard_layout")

local wibars_ontop_when_not_fullscreen = require("components.signals.wibars_ontop_when_not_fullscreen")
local titlebar = require("components.signals.titlebar")
local fix_fullscreen = require("components.signals.fix_fullscreen")
local debug_notification = require("components.signals.debug_notification")
local reverse_window_order = require("components.signals.reverse_window_order")
local rounded_corners = require("components.signals.rounded_corners")

local terminal = "alacritty"

-- for future
local function run_in_terminal(command)
    awful.spawn(terminal .. " -e \"" .. command .. "\"")
end

-- Menubar configuration
menubar.utils.terminal = terminal
-- }}}

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", beautiful.wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    beautiful.wallpaper(s)

    s.top_wibar = top_wibar.create_bar(s)
    s.bottom_wibar = bottom_wibar.create_bar(s)

    wibars_ontop_when_not_fullscreen.affected_wibars = { s.top_wibar, s.bottom_wibar }
end)
-- }}}

-- {{{ Key bindings, todo work on them
local globalkeys = {}

globalkeys = leftover_keybinds.connect_keybinds(globalkeys)
globalkeys = screenshot_spectacle_keybinds.connect_keybinds(globalkeys)
globalkeys = sound_keybinds.connect_keybinds(globalkeys)
globalkeys = awesome_keybinds.connect_keybinds(globalkeys)
globalkeys = keyboard_layout_keybinds.connect_keybinds(globalkeys)

local clientkeys = window_keybinds.connect_keybinds({})

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
for i = 1, 3 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkeys.super }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkeys.super, modkeys.ctrl }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkeys.super, modkeys.shift }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkeys.super, modkeys.ctrl, modkeys.shift }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

local clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ }, 3, function (c)
        if c.role == "PictureInPicture" then -- firefox's PIP, not sure about others
            awful.mouse.client.move(c)
        end
    end),
    awful.button({ modkeys.super }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkeys.super }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen+awful.placement.centered+awful.placement.skip_fullscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = true } },

    { rule = { requests_no_titlebar = true }, properties = { titlebars_enabled = false } },

    { rule_any = { class = { "easyeffects" } }, properties = { titlebars_enabled = true } },

    { rule = { role = "PictureInPicture" }, properties = { placement = awful.placement.bottom_right }},

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
fix_fullscreen.connect_signals()
wibars_ontop_when_not_fullscreen.connect_signals()
titlebar.connect_signals()
--debug_notification.connect_signals()
reverse_window_order.connect_signals()
rounded_corners.connect_signals()
-- }}}

awful.spawn.spawn("easyeffects --gapplication-service", false)
awful.spawn.spawn("light-locker --lock-after-screensaver=900 --late-locking --lock-on-lid", false) -- todo replace with something lighter and easier for configuration
awful.spawn.with_shell("sleep 1; xset s off") -- does this even work???
if PERFORMANCE_MODE then
    awful.spawn.spawn("picom --experimental-backends --config=" .. gears.filesystem.get_xdg_config_home() .. "awesome/picom/picom-barebones.conf", false)
else
    awful.spawn.spawn("picom --experimental-backends --config=" .. gears.filesystem.get_xdg_config_home() .. "awesome/picom/picom.conf", false)
end
awful.spawn.spawn("copyq", false)
if not os.execute("pgrep thunderbird") then
    awful.spawn.spawn("kdocker -d 60 thunderbird", false) -- make sure to install Simple Startup Minimizer (https://addons.thunderbird.net/en-US/thunderbird/addon/simple-startup-minimizer/) and Minimize On Close (https://addons.thunderbird.net/en-US/thunderbird/addon/minimize-on-close/)
end
awful.spawn.spawn("nm-applet", false)

naughty.connect_signal("request::display", function(n)
	naughty.layout.box({
		notification = n
	})
end)