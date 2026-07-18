#!/usr/bin/env bash

###############################################################################
#
# Mouse Optimization Module
#
###############################################################################

set -euo pipefail


log() {
    printf "[Mouse] %s\n" "$1"
}


apply() {
    defaults write "$1" "$2" "-$3" "$4" 2>/dev/null || true
}


log "Configuring mouse..."


###############################################################################
# Faster pointer
###############################################################################

apply NSGlobalDomain com.apple.mouse.scaling float 2.5


###############################################################################
# Faster scrolling
###############################################################################

apply NSGlobalDomain com.apple.scrollwheel.scaling float 2


###############################################################################
# Enable secondary click
###############################################################################

apply NSGlobalDomain com.apple.mouse.tapBehavior int 1


###############################################################################
# Natural scrolling
# Change to false if you prefer Windows style
###############################################################################

apply NSGlobalDomain com.apple.swipescrolldirection bool true


log "Mouse optimization completed."