#!/bin/zsh

set -e

BACKUP_DIR="$HOME/mac_settings_backup_$(date +%Y%m%d_%H%M%S)"
BACKUP_FILE="$HOME/mac_settings_backup.plist"

function backup_settings() {

    echo "Creating backup..."

    mkdir -p "$BACKUP_DIR"

    # Global settings
    defaults export NSGlobalDomain "$BACKUP_DIR/global.plist"

    # Finder
    defaults export com.apple.finder "$BACKUP_DIR/finder.plist"

    # Dock
    defaults export com.apple.dock "$BACKUP_DIR/dock.plist"

    # Screenshot
    defaults export com.apple.screencapture "$BACKUP_DIR/screenshot.plist"

    echo "Backup created:"
    echo "$BACKUP_DIR"
}


function restore_settings() {

    echo "Restoring settings..."

    if [ ! -d "$1" ]; then
        echo "Backup directory not found"
        exit 1
    fi


    defaults import NSGlobalDomain "$1/global.plist"

    defaults import com.apple.finder "$1/finder.plist"

    defaults import com.apple.dock "$1/dock.plist"

    defaults import com.apple.screencapture "$1/screenshot.plist"


    killall Finder 2>/dev/null || true
    killall Dock 2>/dev/null || true
    killall SystemUIServer 2>/dev/null || true


    echo "Restore completed."
}


function apply_settings() {

echo "Applying macOS optimizations..."


################################
# Finder
################################

defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true


################################
# Dock
################################

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 42


################################
# Keyboard
################################

defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false


################################
# Screenshots
################################

mkdir -p "$HOME/Screenshots"

defaults write com.apple.screencapture location "$HOME/Screenshots"
defaults write com.apple.screencapture disable-shadow -bool true


################################
# Restart services
################################

killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true


echo "Optimization applied."
}


case "$1" in

backup)
    backup_settings
    ;;

apply)
    apply_settings
    ;;

restore)
    restore_settings "$2"
    ;;

*)
echo "
Usage:

Backup:
  ./mac_setup.sh backup

Apply:
  ./mac_setup.sh apply

Restore:
  ./mac_setup.sh restore ~/mac_settings_backup_YYYYMMDD_HHMMSS

"
;;

esac