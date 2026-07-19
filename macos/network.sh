#!/usr/bin/env bash

###############################################################################
# Network Optimization
###############################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/module.sh"

apply_module_config() {


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
}

run_module_command "${1:-apply}" "${2:-}"
