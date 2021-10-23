---------------------------
-- artytheme awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local gtk_vars = require("beautiful.gtk").get_theme_variables()
local dpi = xresources.apply_dpi
local gears = require("gears")

local naughty = require("naughty") -- debugging stuff

local gfs = require("gears.filesystem")
local theme_path = gears.filesystem.get_configuration_dir() .. "theme/"

local theme = {}

theme.font = gtk_vars.font_family .. " " .. gtk_vars.font_size

theme.bg_normal     = "#171717"
theme.bg_focus      = "#7fff7f"
theme.bg_urgent     = "#ff7f00"
theme.bg_systray    = theme.bg_normal
theme.bg_minimize   = theme.bg_focus .. "0f"

theme.fg_normal     = "#dfdfdf"
theme.fg_focus      = "#171717"
theme.fg_urgent     = theme.bg_normal
theme.fg_minimize   = theme.fg_normal
theme.fg_systray    = theme.fg_normal

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
theme.tasklist_bg_normal = theme.bg_focus .. "3F"
theme.tasklist_bg_focus = theme.bg_focus
theme.tasklist_bg_minimize = "#00000000"
theme.taglist_bg_occupied = theme.bg_minimize
theme.systray_icon_spacing = 4
theme.hotkeys_modifiers_fg = theme.bg_focus
theme.hotkeys_font = "Cascadia Code " .. gtk_vars.font_size
theme.hotkeys_description_font = theme.font
theme.border_width = 0
theme.titlebar_bg_normal = "#171717"
theme.titlebar_fg_normal = "#7f7f7f"
if PERFORMANCE_MODE then
    theme.titlebar_bg_focus = "#171717"
else
    theme.titlebar_bg_focus = {
        type = "linear",
        from = { 0, 0 },
        to = { 0, 32 },
        stops = {
            { 0, "#1f1f1f" },
            { 1, "#171717" }
        }
    }
end
theme.titlebar_fg_focus = "#dfdfdf"

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
--theme.menu_submenu_icon = theme_path.."submenu.png"
theme.menu_submenu = "▶ "
theme.menu_height = 32
theme.menu_width  = 256
if COMPACT_MODE then
    theme.menu_height = 24
    theme.menu_width = 192
end

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = theme_path.."titlebar/close.png"
theme.titlebar_close_button_focus  = theme_path.."titlebar/close.png"

theme.titlebar_minimize_button_normal = theme_path.."titlebar/minimize.png"
theme.titlebar_minimize_button_focus  = theme_path.."titlebar/minimize.png"

theme.titlebar_ontop_button_normal_inactive = theme_path.."titlebar/ontop.png"
theme.titlebar_ontop_button_focus_inactive  = theme_path.."titlebar/ontop.png"
theme.titlebar_ontop_button_normal_active = theme_path.."titlebar/ontop.png"
theme.titlebar_ontop_button_focus_active  = theme_path.."titlebar/ontop.png"

theme.titlebar_sticky_button_normal_inactive = theme_path.."titlebar/sticky.png"
theme.titlebar_sticky_button_focus_inactive  = theme_path.."titlebar/sticky.png"
theme.titlebar_sticky_button_normal_active = theme_path.."titlebar/sticky.png"
theme.titlebar_sticky_button_focus_active  = theme_path.."titlebar/sticky.png"

theme.titlebar_floating_button_normal_inactive = theme_path.."titlebar/floating.png"
theme.titlebar_floating_button_focus_inactive  = theme_path.."titlebar/floating.png"
theme.titlebar_floating_button_normal_active = theme_path.."titlebar/floating.png"
theme.titlebar_floating_button_focus_active  = theme_path.."titlebar/floating.png"

theme.titlebar_maximized_button_normal_inactive = theme_path.."titlebar/maximized.png"
theme.titlebar_maximized_button_focus_inactive  = theme_path.."titlebar/maximized.png"
theme.titlebar_maximized_button_normal_active = theme_path.."titlebar/maximized.png"
theme.titlebar_maximized_button_focus_active  = theme_path.."titlebar/maximized.png"

-- You can use your own layout icons like this:
theme.layout_fairh = theme_path.."layouts/fairhw.png"
theme.layout_fairv = theme_path.."layouts/fairvw.png"
theme.layout_floating  = theme_path.."layouts/floatingw.png"
theme.layout_magnifier = theme_path.."layouts/magnifierw.png"
theme.layout_max = theme_path.."layouts/maxw.png"
theme.layout_fullscreen = theme_path.."layouts/fullscreenw.png"
theme.layout_tilebottom = theme_path.."layouts/tilebottomw.png"
theme.layout_tileleft   = theme_path.."layouts/tileleftw.png"
theme.layout_tile = theme_path.."layouts/tilew.png"
theme.layout_tiletop = theme_path.."layouts/tiletopw.png"
theme.layout_spiral  = theme_path.."layouts/spiralw.png"
theme.layout_dwindle = theme_path.."layouts/dwindlew.png"
theme.layout_cornernw = theme_path.."layouts/cornernww.png"
theme.layout_cornerne = theme_path.."layouts/cornernew.png"
theme.layout_cornersw = theme_path.."layouts/cornersww.png"
theme.layout_cornerse = theme_path.."layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    32, theme.bg_focus, theme.bg_normal
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "oomox-ArtyTheme"
-- right now only "###x###/category/icon" is supported, but, say, breeze uses "category/###/icon" (### is size dimension)

-- unfocused colors
theme = theme_assets.recolor_titlebar(theme, theme.titlebar_fg_normal, "normal", nil, nil)
theme = theme_assets.recolor_titlebar(theme, theme.titlebar_fg_normal, "normal", nil, "inactive")
theme = theme_assets.recolor_titlebar(theme, theme.bg_focus, "normal", nil, "active")
theme = theme_assets.recolor_titlebar(theme, theme.bg_focus, "normal", "hover", nil)
theme = theme_assets.recolor_titlebar(theme, theme.bg_focus, "normal", "press", nil)

-- focused colors
theme = theme_assets.recolor_titlebar(theme, theme.titlebar_fg_focus, "focus", nil, nil)
theme = theme_assets.recolor_titlebar(theme, theme.titlebar_fg_focus, "focus", nil, "inactive")
theme = theme_assets.recolor_titlebar(theme, theme.bg_focus, "focus", nil, "active")
theme = theme_assets.recolor_titlebar(theme, theme.bg_focus, "focus", "hover", nil)
theme = theme_assets.recolor_titlebar(theme, theme.bg_focus, "focus", "press", nil)

--[[ -- close button
theme.titlebar_close_button_normal_hover = gears.color.recolor_image(theme.titlebar_close_button_normal, theme.bg_focus)
theme.titlebar_close_button_normal_press = gears.color.recolor_image(theme.titlebar_close_button_normal, theme.bg_focus)
theme.titlebar_close_button_focus_hover  = gears.color.recolor_image(theme.titlebar_close_button_focus , theme.bg_focus)
theme.titlebar_close_button_focus_press  = gears.color.recolor_image(theme.titlebar_close_button_focus , theme.bg_focus) ]]

theme.titlebar_margins = 8
if COMPACT_MODE then
    theme.titlebar_margins = 6
end

theme.wibar_icon_margins = 4
if COMPACT_MODE then
    theme.wibar_icon_margins = 3
end

theme.top_wibar_height = 32
theme.bottom_wibar_height = 64
if COMPACT_MODE then
    theme.top_wibar_height = 24
    theme.bottom_wibar_height = 48
end

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
