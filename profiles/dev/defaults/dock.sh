#!/bin/bash
dockutil --remove all

# Add only preferred apps in specified order for dev environment
dockutil --add /Applications/Visual\ Studio\ Code.app
dockutil --add /Applications/Safari.app

killall Dock
