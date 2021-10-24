local gears = require("gears")

local this = {}

this.light_color = "#e0e0e0"
this.middle_color = "#7f7f7f"
this.dark_color = "#101010"

if not LIGHT_MODE then
    this.base_bg = this.dark_color
    this.accent_bg = "#ff7f00"
    this.urgent_bg = "#7f00ff"
    this.icon_theme = "oomox-ArtyTheme-Dark"
    this.wallpaper = this.dark_color
else
    this.base_bg = this.light_color
    this.accent_bg = "#bf772f"
    this.urgent_bg = "#772fbf"
    this.icon_theme = "oomox-ArtyTheme"
    this.wallpaper = this.light_color
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
this.urgent_fg = this.get_contrast_color(this.urgent_bg)

function this.recolor_icon(icon)
    return gears.color.recolor_image(icon, this.base_fg)
end

return this