# ArtyIF's awesomewm config

Yes, it's mine. Uh... yeah.

## Dependencies

All dependencies are shown to be for Arch Linux. Some are only in AUR (they're tagged).
Files that use the dependencies are also shown.

### Autostart
- `easyeffects` (audio fx (my headphones are too bassy by default), `rc.lua`)
- `light-locker` (lock screen, `rc.lua`)
- `xorg-xset` (enabling or disabling turning off the screen, `rc.lua`)
- `picom-jonaburg-git`<sup>AUR</sup> (compositing manager, `rc.lua` and `picom` directory)
- `copyq` (clipboard manager, `rc.lua`)
- `network-manager-applet` (I use it to connect to my university's VPN mostly, `rc.lua`)
- `networkmanager` (what it says on the tin, required for `network-manager-applet` to work properly)
- `nm-connection-editor` (for an easy way to manage connections and VPNs, recommended for `network-manager-applet` to work properly)

### Keybinds
- `spectacle` (for screenshots (just works the best for me, suggest alternatives though), `components/keybinds/screenshot_spectacle.lua` => `rc.lua`)
- `playerctl` (for play/pause, `components/keybinds/sound.lua`)

### Widgets
- `copyq` (clipboard manager, `components/widgets/paste.lua` => `components/widgets/top_wibar_right_part.lua` => `components/wibars/top.lua` => `rc.lua`)
- `light-locker` (lock screen, `components/widgets/main_menu.lua` => `components/wibars/top.lua` => `rc.lua`)
- `systemd` (sleep/reboot/shut down, `components/widgets/main_menu.lua` => `components/wibars/top.lua` => `rc.lua`)
- `alacritty` (terminal emulator, used for upgrade menu, `components/widgets/main_menu.lua` => `components/wibars/top.lua` => `rc.lua`)
- `libcanberra` (sound effects, `components/widgets/volume_control.lua` => `components/widgets/top_wibar_right_part.lua` => `components/wibars/top.lua` => `rc.lua`)
- `libpulse` (volume control, `components/widgets/volume_control.lua` => `components/widgets/top_wibar_right_part.lua` => `components/wibars/top.lua` => `rc.lua`)
- `pavucontrol` (advanced sound management, `components/widgets/volume_control.lua` => `components/widgets/top_wibar_right_part.lua` => `components/wibars/top.lua` => `rc.lua`)

### Favorites, all under `components/widgets/main_menu.lua` => `components/wibars/top.lua` => `rc.lua`
- `vivaldi` (web browser and email client)
- `nemo` (file manager)
- `alacritty` (terminal emulator)
- `visual-studio-code-bin`<sup>AUR</sup> (text/code editor)
- `discord` (messenger I often use)
- `steam` (game store and launcher I and many others use)

### Other
- `alacritty` (default terminal emulator, `rc.lua`)
- `gtk3-classic`<sup>AUR</sup> (recommended fork of GTK3 to disable CSD, `rc.lua`)
asdf