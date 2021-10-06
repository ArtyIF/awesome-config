local awful = require("awful")

local this = {}

function this.create_widget()
    KEYBOARD_LAYOUT = awful.widget.keyboardlayout()
    return KEYBOARD_LAYOUT
end

return this