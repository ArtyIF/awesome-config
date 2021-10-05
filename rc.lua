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
local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), "artytheme") -- modification of default theme
beautiful.init(theme_path)

-- components
local top_wibar = require("components.wibars.top")
local bottom_wibar = require("components.wibars.bottom")

local modkeys = require("components.keybinds.modkeys")
local screenshot_spectacle_keybinds = require("components.keybinds.screenshot_spectacle")
local sound_keybinds = require("components.keybinds.sound")
local awesome_keybinds = require("components.keybinds.awesome")
local window_keybinds = require("components.keybinds.window")

local wibars_ontop_when_not_fullscreen = require("components.signals.wibars_ontop_when_not_fullscreen")
local titlebar = require("components.signals.titlebar")
local fix_fullscreen_offset = require("components.signals.fix_fullscreen_offset")

local terminal = "konsole"

-- for future
local function run_in_terminal(command)
    awful.spawn(terminal .. " -e \"" .. command .. "\"")
end

-- Menubar configuration
menubar.utils.terminal = terminal
-- }}}

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, false)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    s.top_wibar = top_wibar.create_bar(s)
    s.bottom_wibar = bottom_wibar.create_bar(s)

    wibars_ontop_when_not_fullscreen.affected_wibars = { s.top_wibar, s.bottom_wibar }
end)
-- }}}

-- {{{ Key bindings, todo work on them
local globalkeys = gears.table.join(
    awful.key({ modkeys.super,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkeys.super,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkeys.super,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkeys.super,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkeys.super,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkeys.super,           }, "w", function () top_wibar.main_menu.menu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkeys.super, modkeys.shift   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkeys.super, modkeys.shift   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkeys.super, modkeys.ctrl }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkeys.super, modkeys.ctrl }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkeys.super,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkeys.super,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkeys.super,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),

    awful.key({ modkeys.super,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkeys.super,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkeys.super, modkeys.shift   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkeys.super, modkeys.shift   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkeys.super, modkeys.ctrl }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkeys.super, modkeys.ctrl }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkeys.super,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkeys.super, modkeys.shift   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkeys.super, modkeys.ctrl }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkeys.super },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),
              
    -- Menubar
    awful.key({ modkeys.super }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)

globalkeys = screenshot_spectacle_keybinds.connect_keybinds(globalkeys)
globalkeys = sound_keybinds.connect_keybinds(globalkeys)
globalkeys = awesome_keybinds.connect_keybinds(globalkeys)

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

    { rule = { role = "PictureInPicture" }, properties = { placement = awful.placement.bottom_right }},

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
fix_fullscreen_offset.connect_signals()
wibars_ontop_when_not_fullscreen.connect_signals()
titlebar.connect_signals()
-- }}}

awful.spawn.spawn("easyeffects --gapplication-service", false)
awful.spawn.spawn("light-locker --lock-after-screensaver=900 --late-locking --lock-on-lid", false)
awful.spawn.with_shell("sleep 1; xset s off") -- added sleep 1 because i think light-locker overrides it on start
if PICOM_BAREBONES then
    awful.spawn.spawn("picom --experimental-backends --config=" .. gears.filesystem.get_xdg_config_home() .. "awesome/picom/picom-barebones.conf", false)
else
    awful.spawn.spawn("picom --experimental-backends --config=" .. gears.filesystem.get_xdg_config_home() .. "awesome/picom/picom.conf", false)
end
if not os.execute("pgrep thunderbird") then
    awful.spawn.spawn("kdocker thunderbird", false) -- make sure to install Simple Startup Minimizer (https://addons.thunderbird.net/en-US/thunderbird/addon/simple-startup-minimizer/) and Minimize On Close (https://addons.thunderbird.net/en-US/thunderbird/addon/minimize-on-close/)
end
awful.spawn.spawn("copyq", false)
