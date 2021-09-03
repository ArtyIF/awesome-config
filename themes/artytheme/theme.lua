---------------------------
-- artytheme awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local gtk_vars = require("beautiful.gtk").get_theme_variables()
local dpi = xresources.apply_dpi

local naughty = require("naughty") -- debugging stuff

local gfs = require("gears.filesystem")
local theme_path = string.format("%s/.config/awesome/themes/%s/", os.getenv("HOME"), "artytheme")

local theme = {}

theme.font          = gtk_vars.font_family .. " " .. gtk_vars.font_size

local function hex_to_srgb(color)
    color = string.gsub(color, "#", "")
    if string.len(color) == 6 then
        return tonumber("0x" .. string.sub(color, 1, 2)) / 255, tonumber("0x" .. string.sub(color, 3, 4)) / 255, tonumber("0x" .. string.sub(color, 5, 6)) / 255
    elseif string.len(color) == 3 then
        return tonumber("0x" .. string.sub(color, 1, 1)) / 255, tonumber("0x" .. string.sub(color, 2, 2)) / 255, tonumber("0x" .. string.sub(color, 3, 3)) / 255
    end
end

local function gamma_correct(r_srgb, g_srgb, b_srgb)
    local r, g, b = 0, 0, 0

    if r_srgb <= 0.03928 then
        r = r_srgb / 12.92
    else
        r = ((r_srgb + 0.055) / 1.055) ^ 2.4
    end

    if g_srgb <= 0.03928 then
        g = g_srgb / 12.92
    else
        g = ((g_srgb + 0.055) / 1.055) ^ 2.4
    end

    if b_srgb <= 0.03928 then
        b = b_srgb / 12.92
    else
        b = ((b_srgb + 0.055) / 1.055) ^ 2.4
    end

    return r, g, b
end

-- source: https://www.w3.org/TR/WCAG20-TECHS/G17.html
local function best_fg(bg)
    local r_srgb, g_srgb, b_srgb = hex_to_srgb(bg)

    local r_bg, g_bg, b_bg = gamma_correct(r_srgb, g_srgb, b_srgb)
    local l_bg = 0.2126 * r_bg + 0.7152 * g_bg + 0.0722 * b_bg

    local contrast_ratio = (l_bg + 0.05) / 0.05

    if contrast_ratio >= 7 then
        return "#000000"
    else
        return "#ffffff"
    end
end

-- very dirty but good enough. will need to move to a proper color library one day
local function darken_color(color, amount)
    local r, g, b = hex_to_srgb(color)
    r = r * amount
    g = g * amount
    b = b * amount
    return "#" .. string.format("%02x", math.floor(r * 255)) .. string.format("%02x", math.floor(g * 255)) .. string.format("%02x", math.floor(b * 255))
end

-- possible values for colors
-- todo: color button imageboxes too somehow
-- todo: adjust the colors
local possible_colors =
{
    "#ff0000",
    "#ff7f00",
    "#ffff00",
    "#7fff00",
    "#00ff00",
    "#00ff7f",
    "#00ffff",
    "#007fff",
    "#0000ff",
    "#7f00ff",
    "#ff00ff",
    "#ff007f",
}

math.randomseed(os.time())
local random_color_chosen = possible_colors[math.random(#possible_colors)]

theme.bg_normal     = darken_color(random_color_chosen, 0.05)
theme.bg_focus      = darken_color(random_color_chosen, 0.25)
theme.bg_urgent     = random_color_chosen
theme.bg_minimize   = theme.bg_focus .. "3f"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#bfbfbf"
theme.fg_focus      = best_fg(theme.bg_focus)
theme.fg_urgent     = best_fg(theme.bg_urgent)
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = 0
theme.border_width  = 0
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

local taglist_square_size = 32
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
theme.menu_height = 32
theme.menu_width  = 256

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
    return theme_assets.wallpaper(theme.bg_normal, theme.fg_normal, theme.bg_urgent, s)
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
