#!/usr/bin/env bash

###############################################################################
#
# Finder Optimization Module
#
# Optimizes:
# - Developer file visibility
# - Navigation
# - Search
# - Performance
#
###############################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/module.sh"

apply_module_config() {


log "Configuring Finder..."


###############################################################################
# Show file extensions
###############################################################################

apply NSGlobalDomain AppleShowAllExtensions bool true


###############################################################################
# Show hidden files
###############################################################################

apply com.apple.finder AppleShowAllFiles bool true


###############################################################################
# Show path bar
###############################################################################

apply com.apple.finder ShowPathbar bool true


###############################################################################
# Show status bar
###############################################################################

apply com.apple.finder ShowStatusBar bool true


###############################################################################
# Default view = List view
###############################################################################

apply com.apple.finder FXPreferredViewStyle string "Nlsv"


###############################################################################
# Search current folder by default
###############################################################################

apply com.apple.finder FXDefaultSearchScope string "SCcf"


###############################################################################
# Keep folders first
###############################################################################

apply com.apple.finder _FXSortFoldersFirst bool true


###############################################################################
# Disable extension warning
###############################################################################

apply com.apple.finder FXEnableExtensionChangeWarning bool false


###############################################################################
# Disable empty trash confirmation
###############################################################################

apply com.apple.finder WarnOnEmptyTrash bool false


###############################################################################
# Disable animations
###############################################################################

apply com.apple.finder DisableAllAnimations bool true


###############################################################################
# Show full POSIX path in title
###############################################################################

apply com.apple.finder _FXShowPosixPathInTitle bool true


###############################################################################
# Disable .DS_Store on network volumes
###############################################################################

defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true 2>/dev/null || true


###############################################################################
# Disable .DS_Store on USB
###############################################################################

defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true 2>/dev/null || true


###############################################################################
# Restart Finder
###############################################################################

killall Finder 2>/dev/null || true


log "Finder optimization completed."
}

run_module_command "${1:-apply}" "${2:-}"
