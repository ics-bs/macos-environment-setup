#!/bin/bash
dockutil --remove all

# Add only preferred apps in specified order
dockutil --add /Applications/Visual\ Studio\ Code.app
dockutil --add /Applications/Safari.app
dockutil --add /Applications/Zotero.app
dockutil --add /Applications/Obsidian.app
dockutil --add /Applications/SelfControl.app

killall Dock
