#!/usr/bin/env bash

###############################################################################
#
# Display Optimization Module
#
# Optimizes:
# - External monitors
# - Reduced animations
# - Better workspace
#
###############################################################################

set -euo pipefail


log() {
    printf "[Display] %s\n" "$1"
}


apply() {
    defaults write "$1" "$2" "-$3" "$4" 2>/dev/null || true
}


log "Configuring display..."


###############################################################################
# Reduce transparency
###############################################################################

apply com.apple.universalaccess reduceTransparency bool true


###############################################################################
# Reduce transparency (for display/rendering optimization)
###############################################################################

apply com.apple.universalaccess reduceTransparency bool true


###############################################################################
# Disable window animations
###############################################################################

apply NSGlobalDomain NSAutomaticWindowAnimationsEnabled bool false


###############################################################################
# Disable Exposé animations
###############################################################################

apply com.apple.dock expose-animation-duration float 0.0


###############################################################################
# Disable Mission Control animation (kept here as it's display-related)
###############################################################################

apply com.apple.dock mcx-exposure-disabled bool true


###############################################################################
# Disable focus ring animation
###############################################################################

apply NSGlobalDomain NSQuaternaryControlTint int 6


###############################################################################
# Disable zoom effect
###############################################################################

apply com.apple.dock largesize int 0


###############################################################################
# Screenshot location
###############################################################################

mkdir -p "$HOME/Screenshots"

defaults write com.apple.screencapture location \
"$HOME/Screenshots"


###############################################################################
# PNG screenshots
###############################################################################

defaults write com.apple.screencapture type png


###############################################################################
# Disable screenshot shadow
###############################################################################

defaults write com.apple.screencapture disable-shadow -bool true


###############################################################################
# Prevent display sleep while plugged in
#
# Actual power policy remains in battery.sh
###############################################################################

log "Display optimization completed."