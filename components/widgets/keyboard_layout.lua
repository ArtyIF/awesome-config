local awful = require("awful")

local this = {}

function this.create_widget()
    return awful.widget.keyboardlayout()
end

return this