local this = {}

local naughty = require("naughty")

function this.signal_callback(c)
    local notification_text = ""

    if c.type then
        notification_text = notification_text .. "Type: " .. c.type
    end

    if c.role then
        notification_text = notification_text .. "\n" .. "Role: " .. c.role
    end

    if c.size_hints.program_position then
        notification_text = notification_text .. "\n" .. "Program Position Hint: (" .. c.size_hints.program_position.x .. ", " .. c.size_hints.program_position.y .. ")"
    end

    if c.size_hints.program_size then
        notification_text = notification_text .. "\n" .. "Program Size Hint: (" .. c.size_hints.program_position.width .. ", " .. c.size_hints.program_position.height .. ")"
    end
    naughty.notification({
        title = c.name .. " (" .. c.class .. ")",
        text = notification_text
    })
end

function this.connect_signals()
    client.connect_signal("manage", this.signal_callback)
end

return this