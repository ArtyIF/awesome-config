local this = {}

function this.signal_callback(c)
    -- todo: ignore steam, since, despite matching all those criteria (it uses CSD), it is not, in fact, fullscreen
    if c.requests_no_titlebar and c.width >= c.screen.geometry.width and c.height >= c.screen.geometry.height and not c.fullscreen then
        c.fullscreen = true
    end
end

function this.connect_signals()
    client.connect_signal("focus", this.signal_callback)
    client.connect_signal("request::geometry", this.signal_callback)
end

return this