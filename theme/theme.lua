---------------------------
-- artytheme awesome theme --
---------------------------

local awful = require("awful")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local gtk_vars = require("beautiful.gtk").get_theme_variables()
local dpi = xresources.apply_dpi
local gears = require("gears")

local naughty = require("naughty") -- debugging stuff

local gfs = require("gears.filesystem")
local theme_path = gears.filesystem.get_configuration_dir() .. "theme/"

local colors = require("theme.colors")

local theme = {}

theme.font = gtk_vars.font_family .. " " .. gtk_vars.font_size

theme.bg_normal     = colors.base_bg
theme.bg_focus      = colors.accent_bg
theme.bg_urgent     = colors.urgent_bg
theme.bg_systray    = colors.base_bg
theme.bg_minimize   = colors.accent_bg .. "0f"

theme.fg_normal     = colors.base_fg
theme.fg_focus      = colors.accent_fg
theme.fg_urgent     = colors.urgent_fg
theme.fg_minimize   = colors.base_fg
theme.fg_systray    = colors.accent_fg

theme.tasklist_bg_normal = colors.accent_bg .. "5f"
theme.tasklist_bg_focus = colors.accent_bg
theme.tasklist_bg_minimize = "#00000000"

theme.taglist_bg_occupied = theme.bg_minimize

theme.systray_icon_spacing = 4

theme.hotkeys_modifiers_fg = colors.accent_bg
theme.hotkeys_font = "Cascadia Code " .. gtk_vars.font_size
theme.hotkeys_description_font = theme.font

theme.border_width = 0

theme.titlebar_bg_normal = "transparent"
theme.titlebar_fg_normal = colors.middle_color
theme.titlebar_bg_focus = "transparent"
theme.titlebar_fg_focus = colors.base_fg

theme.menu_submenu = "▶ "
theme.menu_height = 32
theme.menu_width  = 256
if COMPACT_MODE then
    theme.menu_height = 24
    theme.menu_width = 192
end

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
theme.layout_fairh = colors.recolor_icon(theme_path.."layouts/fairh.png")
theme.layout_fairv = colors.recolor_icon(theme_path.."layouts/fairv.png")
theme.layout_floating  = colors.recolor_icon(theme_path.."layouts/floating.png")
theme.layout_magnifier = colors.recolor_icon(theme_path.."layouts/magnifier.png")
theme.layout_max = colors.recolor_icon(theme_path.."layouts/max.png")
theme.layout_fullscreen = colors.recolor_icon(theme_path.."layouts/fullscreen.png")
theme.layout_tilebottom = colors.recolor_icon(theme_path.."layouts/tilebottom.png")
theme.layout_tileleft   = colors.recolor_icon(theme_path.."layouts/tileleft.png")
theme.layout_tile = colors.recolor_icon(theme_path.."layouts/tile.png")
theme.layout_tiletop = colors.recolor_icon(theme_path.."layouts/tiletop.png")
theme.layout_spiral  = colors.recolor_icon(theme_path.."layouts/spiral.png")
theme.layout_dwindle = colors.recolor_icon(theme_path.."layouts/dwindle.png")
theme.layout_cornernw = colors.recolor_icon(theme_path.."layouts/cornernw.png")
theme.layout_cornerne = colors.recolor_icon(theme_path.."layouts/cornerne.png")
theme.layout_cornersw = colors.recolor_icon(theme_path.."layouts/cornersw.png")
theme.layout_cornerse = colors.recolor_icon(theme_path.."layouts/cornerse.png")

theme.awesome_icon = theme_assets.awesome_icon(
    32, colors.accent_bg, colors.base_bg
)

theme.icon_theme = colors.icon_theme
-- right now only "###x###/category/icon" is supported, but, say, breeze uses "category/###/icon" (### is size dimension)

-- unfocused colors
theme = theme_assets.recolor_titlebar(theme, colors.middle_color, "normal", nil, nil)
theme = theme_assets.recolor_titlebar(theme, colors.middle_color, "normal", nil, "inactive")
theme = theme_assets.recolor_titlebar(theme, colors.accent_bg, "normal", nil, "active")
theme = theme_assets.recolor_titlebar(theme, colors.accent_bg, "normal", "hover", nil)
theme = theme_assets.recolor_titlebar(theme, colors.accent_bg, "normal", "press", nil)

-- focused colors
theme = theme_assets.recolor_titlebar(theme, colors.base_fg, "focus", nil, nil)
theme = theme_assets.recolor_titlebar(theme, colors.base_fg, "focus", nil, "inactive")
theme = theme_assets.recolor_titlebar(theme, colors.accent_bg, "focus", nil, "active")
theme = theme_assets.recolor_titlebar(theme, colors.accent_bg, "focus", "hover", nil)
theme = theme_assets.recolor_titlebar(theme, colors.accent_bg, "focus", "press", nil)

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

theme.wallpaper = function (s)
    awful.wallpaper {
        screen = s,
        bg     = colors.wallpaper,
        widget = nil
    }
end

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
