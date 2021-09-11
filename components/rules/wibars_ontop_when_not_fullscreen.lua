local this = {}

this.affected_wibars = {}

local function signal_callback(client)
    for i, wibar in ipairs(this.affected_wibars) do
        wibar.ontop = not (client.fullscreen or client.type == "fullscreen")
    end
end

client.connect_signal("focus", signal_callback)
client.connect_signal("request::geometry", signal_callback)

return this