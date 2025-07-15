#!/bin/bash
defaults write com.apple.Siri StatusMenuVisible -bool false
defaults write com.apple.Spotlight SuggestionsEnabled -bool false
defaults write com.apple.Spotlight UniversalSearchEnabled -bool false
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
defaults write com.apple.SubmitDiagInfo AutoSubmit -bool false

# Enables moving of windows using cmd + ctrl + mouse drag
defaults write -g NSWindowShouldDragOnGesture -bool true

# Auto-hide the dock
defaults write com.apple.dock autohide -bool true;

# Set speed at which dock appears after mouseover
defaults write com.apple.dock autohide-time-modifier -float 0.5
defaults write com.apple.dock autohide-delay -float 0; killall Dock

# File associations
duti -s com.apple.Safari pdf all
duti -s md.obsidian.md md all
duti -s com.microsoft.VSCode tex all
duti -s org.libreoffice script all
duti -s com.apple.Preview png all

# Comprehensive development file associations to Visual Studio Code
duti -s com.microsoft.VSCode java all
duti -s com.microsoft.VSCode cs all
duti -s com.microsoft.VSCode py all
duti -s com.microsoft.VSCode js all
duti -s com.microsoft.VSCode ts all
duti -s com.microsoft.VSCode go all
duti -s com.microsoft.VSCode rb all
duti -s com.microsoft.VSCode php all
duti -s com.microsoft.VSCode swift all
duti -s com.microsoft.VSCode kt all

duti -s com.microsoft.VSCode html all
duti -s com.microsoft.VSCode css all
duti -s com.microsoft.VSCode scss all
duti -s com.microsoft.VSCode less all

duti -s com.microsoft.VSCode sh all
duti -s com.microsoft.VSCode bash all
duti -s com.microsoft.VSCode zsh all
duti -s com.microsoft.VSCode ps1 all

duti -s com.microsoft.VSCode json all
duti -s com.microsoft.VSCode yml all
duti -s com.microsoft.VSCode yaml all
duti -s com.microsoft.VSCode xml all
duti -s com.microsoft.VSCode toml all
duti -s com.microsoft.VSCode ini all
duti -s com.microsoft.VSCode env all

duti -s com.microsoft.VSCode md all
duti -s com.microsoft.VSCode rst all
duti -s com.microsoft.VSCode txt all

duti -s com.microsoft.VSCode plist all
duti -s com.microsoft.VSCode gradle all
duti -s com.microsoft.VSCode csproj all
duti -s com.microsoft.VSCode sln all
duti -s com.microsoft.VSCode xcodeproj all

duti -s com.microsoft.VSCode sql all
