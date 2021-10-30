local gears = require("gears")

local this = {}

function this.signal_callback(c)
    if c.floating and not c.fullscreen and not c.maximized then
        gears.surface.apply_shape_bounding(c, gears.shape.rounded_rect, 8)
    else
        gears.surface.apply_shape_bounding(c, gears.shape.rectangle)
    end
end

function this.connect_signals()
    client.connect_signal("manage", this.signal_callback)
    client.connect_signal("request::geometry", this.signal_callback)
    client.connect_signal("property::floating", this.signal_callback)
end

return this