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
local theme_path = string.format("%s/.config/awesome/themes/%s/", os.getenv("HOME"), "artytheme")

local theme = {}

theme.font = gtk_vars.font_family .. " " .. gtk_vars.font_size

-- possible palettes, taken from https://tailwindcolor.com/
local possible_palettes =
{
    { color_900 = "#7F1D1D", color_800 = "#991B1B", color_700 = "#B91C1C", color_600 = "#DC2626", color_500 = "#EF4444", color_400 = "#F87171", color_300 = "#FCA5A5", color_200 = "#FECACA", color_100 = "#FEE2E2", color_50 = "#FEF2F2" }, -- red
    { color_900 = "#7C2D12", color_800 = "#9A3412", color_700 = "#C2410C", color_600 = "#EA580C", color_500 = "#F97316", color_400 = "#FB923C", color_300 = "#FDBA74", color_200 = "#FED7AA", color_100 = "#FFEDD5", color_50 = "#FFF7ED" }, -- orange
    { color_900 = "#78350F", color_800 = "#92400E", color_700 = "#B45309", color_600 = "#D97706", color_500 = "#F59E0B", color_400 = "#FBBF24", color_300 = "#FCD34D", color_200 = "#FDE68A", color_100 = "#FEF3C7", color_50 = "#FFFBEB" }, -- amber
    { color_900 = "#713F12", color_800 = "#854D0E", color_700 = "#A16207", color_600 = "#CA8A04", color_500 = "#EAB308", color_400 = "#FACC15", color_300 = "#FDE047", color_200 = "#FEF08A", color_100 = "#FEF9C3", color_50 = "#FEFCE8" }, -- yellow
    { color_900 = "#365314", color_800 = "#3F6212", color_700 = "#4D7C0F", color_600 = "#65A30D", color_500 = "#84CC16", color_400 = "#A3E635", color_300 = "#BEF264", color_200 = "#D9F99D", color_100 = "#ECFCCB", color_50 = "#F7FEE7" }, -- lime
    { color_900 = "#14532D", color_800 = "#166534", color_700 = "#15803D", color_600 = "#16A34A", color_500 = "#22C55E", color_400 = "#4ADE80", color_300 = "#86EFAC", color_200 = "#BBF7D0", color_100 = "#DCFCE7", color_50 = "#F0FDF4" }, -- green
    { color_900 = "#064E3B", color_800 = "#065F46", color_700 = "#047857", color_600 = "#059669", color_500 = "#10B981", color_400 = "#34D399", color_300 = "#6EE7B7", color_200 = "#A7F3D0", color_100 = "#ECFDF5", color_50 = "#ECFDF5" }, -- emerald
    { color_900 = "#134E4A", color_800 = "#115E59", color_700 = "#0F766E", color_600 = "#059669", color_500 = "#14B8A6", color_400 = "#2DD4BF", color_300 = "#5EEAD4", color_200 = "#99F6E4", color_100 = "#F0FDFA", color_50 = "#F0FDFA" }, -- teal
    { color_900 = "#164E63", color_800 = "#155E75", color_700 = "#0E7490", color_600 = "#0891B2", color_500 = "#14B8A6", color_400 = "#22D3EE", color_300 = "#67E8F9", color_200 = "#A5F3FC", color_100 = "#ECFEFF", color_50 = "#ECFEFF" }, -- cyan
    { color_900 = "#0C4A6E", color_800 = "#075985", color_700 = "#0369A1", color_600 = "#0284C7", color_500 = "#0EA5E9", color_400 = "#38BDF8", color_300 = "#7DD3FC", color_200 = "#BAE6FD", color_100 = "#F0F9FF", color_50 = "#F0F9FF" }, -- light blue
    { color_900 = "#1E3A8A", color_800 = "#1E40AF", color_700 = "#1D4ED8", color_600 = "#2563EB", color_500 = "#3B82F6", color_400 = "#60A5FA", color_300 = "#93C5FD", color_200 = "#BFDBFE", color_100 = "#DBEAFE", color_50 = "#EFF6FF" }, -- blue
    { color_900 = "#312E81", color_800 = "#3730A3", color_700 = "#4338CA", color_600 = "#4F46E5", color_500 = "#6366F1", color_400 = "#818CF8", color_300 = "#A5B4FC", color_200 = "#C7D2FE", color_100 = "#E0E7FF", color_50 = "#EEF2FF" }, -- indigo
    { color_900 = "#4C1D95", color_800 = "#5B21B6", color_700 = "#6D28D9", color_600 = "#7C3AED", color_500 = "#8B5CF6", color_400 = "#A78BFA", color_300 = "#C4B5FD", color_200 = "#DDD6FE", color_100 = "#EDE9FE", color_50 = "#F5F3FF" }, -- violet
    { color_900 = "#581C87", color_800 = "#6B21A8", color_700 = "#7E22CE", color_600 = "#9333EA", color_500 = "#A855F7", color_400 = "#C084FC", color_300 = "#D8B4FE", color_200 = "#E9D5FF", color_100 = "#F3E8FF", color_50 = "#FAF5FF" }, -- purple
    { color_900 = "#701A75", color_800 = "#86198F", color_700 = "#A21CAF", color_600 = "#9333EA", color_500 = "#D946EF", color_400 = "#E879F9", color_300 = "#F0ABFC", color_200 = "#F5D0FE", color_100 = "#FAE8FF", color_50 = "#FDF4FF" }, -- fuchsia
    { color_900 = "#831843", color_800 = "#9F1239", color_700 = "#BE185D", color_600 = "#DB2777", color_500 = "#EC4899", color_400 = "#F472B6", color_300 = "#F9A8D4", color_200 = "#FBCFE8", color_100 = "#FCE7F3", color_50 = "#FDF2F8" }, -- pink
    { color_900 = "#881337", color_800 = "#9F1239", color_700 = "#BE123C", color_600 = "#E11D48", color_500 = "#F43F5E", color_400 = "#FB7185", color_300 = "#FDA4AF", color_200 = "#FECDD3", color_100 = "#FFE4E6", color_50 = "#FFF1F2" }, -- rose
}

local function process_transparency(color)
    if PERFORMANCE_MODE and string.len(color) == 9 then
        return string.sub(1, 7)
    end
end

math.randomseed(os.time())
local chosen_palette = possible_palettes[math.random(#possible_palettes)]
-- if you want to have a specific color at all times, replace the above line with the line below:
-- local chosen_palette = possible_palettes[3]

if PERFORMANCE_MODE then
    theme.bg_normal     = "#171717"
    theme.bg_focus      = chosen_palette.color_900
else
    theme.bg_normal     = "#171717BF"
    theme.bg_focus      = chosen_palette.color_900 .. "BF"
end
theme.bg_urgent     = chosen_palette.color_500
theme.bg_minimize   = string.sub(theme.bg_focus, 1, 7) .. "3F"
theme.bg_systray    = string.sub(theme.bg_normal, 1, 7)

theme.fg_normal     = "#E5E5E5"
theme.fg_focus      = chosen_palette.color_50
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
theme.tasklist_bg_normal = "#00000000"
theme.taglist_bg_occupied = theme.bg_minimize
theme.systray_icon_spacing = 4
theme.hotkeys_modifiers_fg = chosen_palette.color_900
theme.hotkeys_font = "Cascadia Code " .. gtk_vars.font_size
theme.hotkeys_description_font = theme.font

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

theme.wallpaper = function(s)
    local result = "/usr/share/backgrounds/gnome/VNC.png"
    while result == "/usr/share/backgrounds/gnome/VNC.png" do
        result = "/usr/share/backgrounds/gnome/" .. gfs.get_random_file_from_dir("/usr/share/backgrounds/gnome/", { "jpg", "png" })
    end
    return result
    -- return "/usr/share/backgrounds/gnome/Loveles.jpg"
    -- todo: replace with https://source.unsplash.com/1920x1080/?wallpaper
    -- todo: use https://www.shadertoy.com/view/fdy3Wy to filter it maybe?
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
    32, theme.bg_urgent, theme.fg_urgent
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Yaru" -- todo: chnage once there's support for other types of paths
-- right now only "###x###/category/icon" is supported, but, say, breeze uses "category/###/icon" (### is size dimension)

-- unfocused colors
theme = theme_assets.recolor_titlebar(theme, theme.fg_normal         , "normal", nil, nil)
theme = theme_assets.recolor_titlebar(theme, theme.fg_normal         , "normal", nil, "inactive")
theme = theme_assets.recolor_titlebar(theme, chosen_palette.color_300, "normal", nil, "active")
theme = theme_assets.recolor_titlebar(theme, chosen_palette.color_300, "normal", "hover", nil)
theme = theme_assets.recolor_titlebar(theme, chosen_palette.color_500, "normal", "press", nil)

-- focused colors
theme = theme_assets.recolor_titlebar(theme, chosen_palette.color_50 , "focus", nil, nil)
theme = theme_assets.recolor_titlebar(theme, chosen_palette.color_50 , "focus", nil, "inactive")
theme = theme_assets.recolor_titlebar(theme, chosen_palette.color_300, "focus", nil, "active")
theme = theme_assets.recolor_titlebar(theme, chosen_palette.color_300, "focus", "hover", nil)
theme = theme_assets.recolor_titlebar(theme, chosen_palette.color_500, "focus", "press", nil)

-- close button
theme.titlebar_close_button_normal_hover = gears.color.recolor_image(theme.titlebar_close_button_normal, possible_palettes[1].color_300)
theme.titlebar_close_button_normal_press = gears.color.recolor_image(theme.titlebar_close_button_normal, possible_palettes[1].color_500)
theme.titlebar_close_button_focus_hover  = gears.color.recolor_image(theme.titlebar_close_button_focus , possible_palettes[1].color_300)
theme.titlebar_close_button_focus_press  = gears.color.recolor_image(theme.titlebar_close_button_focus , possible_palettes[1].color_500)

theme.titlebar_margins = 8
if COMPACT_MODE then
    theme.titlebar_margins = 6
end

theme.wibar_icon_margins = 4
if COMPACT_MODE then
    theme.wibar_icon_margins = 3
end

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
