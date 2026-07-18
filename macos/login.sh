#!/usr/bin/env bash

###############################################################################
# Login Optimization
###############################################################################

set -euo pipefail


log() {
    printf "[Login] %s\n" "$1"
}


log "Optimizing startup..."


###############################################################################
# Disable automatic reopening applications
###############################################################################

defaults write com.apple.loginwindow \
TALLogoutSavesState -bool false


###############################################################################
# Faster login
###############################################################################

defaults write com.apple.loginwindow \
DisableFDEAutoLogin -bool false


###############################################################################
# List login items
###############################################################################

osascript <<EOF
tell application "System Events"
    get the name of every login item
end tell
EOF


log "Login optimization completed."