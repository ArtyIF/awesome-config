local this = {}

this.affected_wibars = {}

function this.signal_callback()
    if client.focus == nil then
        for _, wibar in ipairs(this.affected_wibars) do
            wibar.ontop = true
        end
        return
    end
    local is_window_fullscreen = (client.focus.width >= client.focus.screen.geometry.width and client.focus.height >= client.focus.screen.geometry.height) or client.focus.type == "fullscreen"
    for _, wibar in ipairs(this.affected_wibars) do
        wibar.ontop = not is_window_fullscreen
    end
end

function this.connect_signals()
    client.connect_signal("focus", this.signal_callback)
    client.connect_signal("request::geometry", this.signal_callback)
end

return this