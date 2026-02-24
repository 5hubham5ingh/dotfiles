Commands to get the key board shortcuts:
1. dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > shortcuts.conf
2. dconf dump /org/gnome/desktop/wm/keybindings/ > keybinds.conf

Commands to load the shortcuts in new system:
1. dconf load /org/gnome/settings-daemon/plugins/media-keys/ < shortcuts.conf
2. dconf load /org/gnome/desktop/wm/keybindings/ < keybinds.conf
