local awful = require("awful")

local this = {}

function this.signal_callback(c)
    if not awesome.startup then awful.client.setslave(c) end
end

function this.connect_signals()
    client.connect_signal("manage", this.signal_callback)
end

return this