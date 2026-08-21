#!/bin/sh
set -eu

gsettings set org.gnome.shell.keybindings toggle-application-view '[]'
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>a']"

gsettings set org.gnome.shell.keybindings toggle-quick-settings '[]'
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>s']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>d']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>f']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>g']"

gsettings set org.gnome.desktop.wm.keybindings minimize '[]'
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>h']"

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-7 "['<Super>j']"
