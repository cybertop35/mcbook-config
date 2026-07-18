#!/usr/bin/env bash

###############################################################################
# Network Optimization
###############################################################################

set -euo pipefail


log() {
    printf "[Network] %s\n" "$1"
}


log "Optimizing network..."


###############################################################################
# Disable discovery noise
###############################################################################

defaults write com.apple.NetworkBrowser \
BrowseAllInterfaces -bool true


###############################################################################
# Flush DNS cache
###############################################################################

sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder


###############################################################################
# Show WiFi details in menu
###############################################################################

defaults write com.apple.airport.preferences \
ShowWiFiDetails -bool true


log "Network optimization completed."