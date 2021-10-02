local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local gears = require("gears")
local modkeys = require("components.keybinds.modkeys")

local this = {}

this.group_name = "Awesome"
this.keybinds = gears.table.join(
    awful.key({ modkeys.super                }, "s", hotkeys_popup.show_help, { description="Show This Window", group=this.group_name }),
    awful.key({ modkeys.super, modkeys.ctrl  }, "r", awesome.restart        , { description="Restart Awesome", group=this.group_name }),
    awful.key({ modkeys.super, modkeys.shift }, "q", awesome.quit           , { description="Log Out", group=this.group_name }) -- todo: remove entirely?
)

function this.connect_keybinds(keybinds_dict)
    return gears.table.join(keybinds_dict, this.keybinds)
end

return this