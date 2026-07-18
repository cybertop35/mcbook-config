#!/usr/bin/env bash

###############################################################################
# Privacy Optimization
###############################################################################

set -euo pipefail


log() {
    printf "[Privacy] %s\n" "$1"
}


log "Applying privacy settings..."


###############################################################################
# Disable personalized advertising
###############################################################################

defaults write com.apple.AdLib \
allowApplePersonalizedAdvertising -bool false


###############################################################################
# Disable analytics
###############################################################################

sudo defaults write /Library/Application\ Support/CrashReporter \
DiagnosticMessagesHistory -array


###############################################################################
# Disable Siri analytics
###############################################################################

defaults write com.apple.Siri \
Siri Data Sharing Opt-In Status -int 2 \
2>/dev/null || true


###############################################################################
# Disable location based suggestions
###############################################################################

defaults write com.apple.locationd \
LocationServicesEnabled -bool true


log "Privacy settings completed."