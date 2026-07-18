#!/usr/bin/env bash

###############################################################################
# Notification Optimization
###############################################################################

set -euo pipefail


log() {
    printf "[Notifications] %s\n" "$1"
}


log "Reducing notification noise..."


###############################################################################
# Disable notification previews
###############################################################################

defaults write com.apple.ncprefs content_visibility -int 0 \
2>/dev/null || true


###############################################################################
# Disable Siri suggestions
###############################################################################

defaults write com.apple.Siri StatusMenuVisible -bool false


###############################################################################
# Disable tips
###############################################################################

defaults write com.apple.tips dismissedTips -bool true \
2>/dev/null || true


killall NotificationCenter 2>/dev/null || true


log "Notifications optimized."