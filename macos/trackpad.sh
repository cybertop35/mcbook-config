#!/usr/bin/env bash

###############################################################################
#
# Trackpad Optimization Module
#
# Optimizes:
# - MacBook workflow
# - Developer productivity
#
###############################################################################

set -euo pipefail


log() {
    printf "[Trackpad] %s\n" "$1"
}


apply() {
    defaults write "$1" "$2" "-$3" "$4" 2>/dev/null || true
}


log "Configuring trackpad..."


###############################################################################
# Tap to click
###############################################################################

apply com.apple.AppleMultitouchTrackpad Clicking bool true

apply com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking bool true


###############################################################################
# Secondary click
###############################################################################

apply com.apple.AppleMultitouchTrackpad TrackpadRightClick bool true


###############################################################################
# Three finger drag
###############################################################################

apply com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag bool true


###############################################################################
# Tracking speed
###############################################################################

apply NSGlobalDomain com.apple.trackpad.scaling float 2.5


###############################################################################
# Enable gestures
###############################################################################

apply com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture bool true


###############################################################################
# Disable force click
# Less accidental activation while coding
###############################################################################

apply com.apple.AppleMultitouchTrackpad ForceSuppressed bool true


log "Trackpad optimization completed."