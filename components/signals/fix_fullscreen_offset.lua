local this = {}

function this.signal_callback(c)
    if c.fullscreen or c.type == "fullscreen" then
        c.x = 0
        c.y = 0
        c.width = c.screen.geometry.width
        c.height = c.screen.geometry.height
    end
end

function this.connect_signals()
    client.connect_signal("focus", this.signal_callback)
    client.connect_signal("request::geometry", this.signal_callback)
end

return this