#!/usr/bin/env bash

###############################################################################
# Accessibility / UI Performance
###############################################################################

set -euo pipefail


log() {
    printf "[Accessibility] %s\n" "$1"
}


log "Configuring accessibility..."


###############################################################################
# Reduce animations
###############################################################################

defaults write com.apple.universalaccess reduceMotion -bool true


###############################################################################
# Reduce transparency
###############################################################################

defaults write com.apple.universalaccess reduceTransparency -bool true


###############################################################################
# Increase contrast slightly
###############################################################################

defaults write com.apple.universalaccess increaseContrast -bool false


log "Accessibility optimization completed."