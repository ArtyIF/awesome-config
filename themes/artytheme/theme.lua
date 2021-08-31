---------------------------
-- artytheme awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local theme_path = string.format("%s/.config/awesome/themes/%s/", os.getenv("HOME"), "artytheme")

local theme = {}

theme.font          = "Inter 10"

theme.bg_normal     = "#171717"
theme.bg_focus      = "#005f2f"
theme.bg_urgent     = "#00ff7f"
theme.bg_minimize   = theme.bg_focus .. "3f"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#bfbfbf"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = theme.bg_normal
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = dpi(0)
theme.border_width  = dpi(0)
theme.border_normal = theme.bg_normal
theme.border_focus  = theme.bg_focus
theme.border_marked = theme.bg_urgent

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
-- theme.titlebar_bg_normal = theme.bg_normal .. "bf"
-- theme.titlebar_bg_focus = theme.bg_focus .. "bf"

local taglist_square_size = dpi(32)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(0, "#00000000")
theme.taglist_squares_unsel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.bg_minimize
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = theme_path.."submenu.png"
theme.menu_height = dpi(32)
theme.menu_width  = dpi(256)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = theme_path.."titlebar/close_normal.png"
theme.titlebar_close_button_focus  = theme_path.."titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = theme_path.."titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = theme_path.."titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = theme_path.."titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = theme_path.."titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = theme_path.."titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = theme_path.."titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = theme_path.."titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = theme_path.."titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = theme_path.."titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = theme_path.."titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = theme_path.."titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = theme_path.."titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = theme_path.."titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = theme_path.."titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = theme_path.."titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme_path.."titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = theme_path.."titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = theme_path.."titlebar/maximized_focus_active.png"

theme.wallpaper = function(s)
    return theme_assets.wallpaper(theme.bg_normal, theme.fg_focus, theme.bg_urgent, s)
end

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
    64, theme.bg_urgent, theme.fg_urgent
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
