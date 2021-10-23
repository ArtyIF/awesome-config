local this = {}

this.light_color = "#d7d7d7"
this.dark_color = "#171717"

if not LIGHT_MODE then
    this.base.bg = this.dark_color
    this.accent.bg = "#ff7f00"
    this.urgent.bg = "#7f00ff"
    this.icon_theme = "oomox-ArtyTheme-Dark"
else
    this.base.bg = this.light_color
    this.accent.bg = "#bf772f"
    this.urgent.bg = "#772fbf"
    this.icon_theme = "oomox-ArtyTheme"
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

this.base.fg = this.get_contrast_color(this.base.bg)
this.accent.fg = this.get_contrast_color(this.accent.bg)
this.urgent.fg = this.get_contrast_color(this.urgent.bg)

return this