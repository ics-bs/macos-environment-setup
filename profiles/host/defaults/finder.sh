#!/bin/bash
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.sidebarlists systemitems -dict-add VolumesList '<dict><key>ShowEjectables</key><true/></dict>'
killall Finder
