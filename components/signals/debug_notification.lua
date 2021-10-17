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

    if c.size_hints then
        local size_hints_text = "\nSize Hints:\n"
        for key, value in pairs(c.size_hints) do
            if type(value) == "table" then
                for key2, value2 in pairs(value) do
                    size_hints_text = size_hints_text .. key .. "." .. key2 .. ": " .. tostring(value2) .. "\n"
                end
            else
                size_hints_text = size_hints_text .. key .. ": " .. tostring(value) .. "\n"
            end
        end
        notification_text = notification_text .. "\n" .. size_hints_text
    end

    notification_text = notification_text .. "\n" .. "X: " .. c.x
    notification_text = notification_text .. "\n" .. "Y: " .. c.y
    notification_text = notification_text .. "\n" .. "Width: " .. c.width
    notification_text = notification_text .. "\n" .. "Height: " .. c.height

    notification_text = notification_text .. "\n" .. "Fullscreen: " .. tostring(c.fullscreen)

    naughty.notification({
        title = c.name .. " (" .. c.class .. ")",
        text = notification_text
    })
end

function this.connect_signals()
    client.connect_signal("request::manage", this.signal_callback)
    client.connect_signal("request::geometry", this.signal_callback)
end

return this