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
BrowseAllInterfaces -bool true 2>/dev/null || true


###############################################################################
# Flush DNS cache
###############################################################################

sudo dscacheutil -flushcache 2>/dev/null || true
sudo killall -HUP mDNSResponder 2>/dev/null || true


###############################################################################
# Show WiFi details in menu
###############################################################################

defaults write com.apple.airport.preferences \
ShowWiFiDetails -bool true 2>/dev/null || true


log "Network optimization completed."
}

run_module_command "${1:-apply}" "${2:-}"
