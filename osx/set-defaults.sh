# Sets reasonable macOS defaults.
#
# Or, in other words, set shit how I like in macOS.
#
# The original idea (and a couple settings) were grabbed from:
#   https://github.com/mathiasbynens/dotfiles/blob/master/.macos
#
# Run ./set-defaults.sh and you'll be good to go.

# Play sound feedback when changing volume.
defaults write -g com.apple.sound.beep.feedback -int 1

# Disable press-and-hold for keys in favor of key repeat.
defaults write -g ApplePressAndHoldEnabled -bool false

# Use AirDrop over every interface. srsly this should be a default.
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

# Always open everything in Finder's list view. This is important.
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

# Show the ~/Library folder.
chflags nohidden ~/Library

# Set a really fast key repeat.
defaults write NSGlobalDomain KeyRepeat -int 1

# Set the Finder prefs for showing a few different volumes on the Desktop.
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Run the screensaver if we're in the bottom-left hot corner.
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0

# Hide Safari's bookmark bar.
defaults write com.apple.Safari ShowFavoritesBar -bool false 2>/dev/null || true

# Set up Safari for development.
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true 2>/dev/null || true
defaults write com.apple.Safari IncludeDevelopMenu -bool true 2>/dev/null || true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true 2>/dev/null || true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true 2>/dev/null || true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Keyboard shortcut: Ctrl+Up for Mission Control / show all windows (shortcut IDs 32 and 34).
# -dict-add is safe to run multiple times (overwrites, doesn't duplicate).
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 32 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>126</integer><integer>8650752</integer></array><key>type</key><string>standard</string></dict></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 34 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>126</integer><integer>8781824</integer></array><key>type</key><string>standard</string></dict></dict>"

# Keyboard shortcut: Ctrl+1 for Launchpad (shortcut ID 160).
# -dict-add is safe to run multiple times (overwrites, doesn't duplicate).
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 160 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>49</integer><integer>18</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>"
# Applies symbolic hotkey changes immediately by restarting UI services.
# Safe to run repeatedly but mildly disruptive if the machine is in active use.
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u