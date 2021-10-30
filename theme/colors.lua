local gears = require("gears")

local this = {}

this.light_color = "#e0e0e0"
this.middle_color = "#7f7f7f"
this.dark_color = "#101010"

this.dark = {}
this.dark.base_bg = this.dark_color
this.dark.accent_bg = "#ff7f00"
this.dark.hover_bg = "#ffdfbf"
this.dark.urgent_bg = "#7f00ff"
this.dark.icon_theme = "oomox-ArtyTheme-Dark"
this.dark.wallpaper = this.dark_color

this.light = {}
this.light.base_bg = this.light_color
this.light.accent_bg = "#bf772f"
this.light.hover_bg = "#402810"
this.light.urgent_bg = "#772fbf"
this.light.icon_theme = "oomox-ArtyTheme"
this.light.wallpaper = this.light_color

if not LIGHT_THEME then
    this.base_bg = this.dark.base_bg
    this.accent_bg = this.dark.accent_bg
    this.hover_bg = this.dark.hover_bg
    this.urgent_bg = this.dark.urgent_bg
    this.icon_theme = this.dark.icon_theme
    this.wallpaper = this.dark.wallpaper
else
    this.base_bg = this.light.base_bg
    this.accent_bg = this.light.accent_bg
    this.hover_bg = this.light.hover_bg
    this.urgent_bg = this.light.urgent_bg
    this.icon_theme = this.light.icon_theme
    this.wallpaper = this.light.wallpaper
end

this.full_icon_theme_path = ""
if gears.filesystem.dir_readable(os.getenv("HOME") .. "/.icons/" .. this.icon_theme) then
    this.full_icon_theme_path = os.getenv("HOME") .. "/.icons/" .. this.icon_theme .. "/"
elseif gears.filesystem.dir_readable("/usr/share/icons/" .. this.icon_theme) then
    this.full_icon_theme_path = "/usr/share/icons/" .. this.icon_theme .. "/"
end

function this.get_gradient_color(base_color)
    if base_color ~= "" then
        local r = tonumber(base_color:sub(2, 3), 16)
        local g = tonumber(base_color:sub(4, 5), 16)
        local b = tonumber(base_color:sub(6, 7), 16)

        r = r + 8
        g = g + 8
        b = b + 8

        if r > 255 then r = 255 end
        if g > 255 then g = 255 end
        if b > 255 then b = 255 end

        local result = "#" .. string.format("%02x", r) .. string.format("%02x", g) .. string.format("%02x", b)
        if base_color:len() == 9 then
            result = result .. base_color:sub(8, 9)
        end

        return result
    else
        return ""
    end
end

function this.get_gradient(base_color, height)
    if not height then
        if SMALL_ELEMENTS then
            height = 24
        else
            height = 32
        end
    end

    return {
        type = "linear",
        from = { 0, 0 },
        to = { 0, height },
        stops = {
            { 0, this.get_gradient_color(base_color) },
            { 1, base_color }
        }
    }
end

function this.get_luminance(color)
    local r = tonumber(color:sub(2, 3), 16) / 255
    local g = tonumber(color:sub(4, 5), 16) / 255
    local b = tonumber(color:sub(6, 7), 16) / 255

    if r <= 0.03928 then r = r / 12.92 else r = ((r + 0.055) / 1.055) ^ 2.4 end
    if g <= 0.03928 then g = g / 12.92 else g = ((g + 0.055) / 1.055) ^ 2.4 end
    if b <= 0.03928 then b = b / 12.92 else b = ((b + 0.055) / 1.055) ^ 2.4 end

    return 0.2126 * r + 0.7152 * g + 0.0722 * b
end

function this.get_contrast_color(bg_color)
    local l1 = this.get_luminance(bg_color)
    local l2 = this.get_luminance(this.light_color)

    if (math.max(l1, l2) + 0.05) / (math.min(l1, l2) + 0.05) >= 4.5 then
        return this.light_color
    else
        return this.dark_color
    end
end

this.base_fg = this.get_contrast_color(this.base_bg)
this.accent_fg = this.get_contrast_color(this.accent_bg)
this.hover_fg = this.get_contrast_color(this.hover_bg)
this.urgent_fg = this.get_contrast_color(this.urgent_bg)

function this.recolor_icon(icon)
    return gears.color.recolor_image(icon, this.base_fg)
end

return this