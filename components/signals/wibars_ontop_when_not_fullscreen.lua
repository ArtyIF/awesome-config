local this = {}

this.affected_wibars = {}

function this.signal_callback(c)
    for _, wibar in ipairs(this.affected_wibars) do
        wibar.ontop = not (c.fullscreen or c.type == "fullscreen")
    end
end

function this.connect_signals()
    client.connect_signal("focus", this.signal_callback)
    client.connect_signal("request::geometry", this.signal_callback)
end

return this