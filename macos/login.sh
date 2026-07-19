#!/usr/bin/env bash

###############################################################################
# Login Optimization
###############################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/module.sh"

apply_module_config() {


log "Optimizing startup..."


###############################################################################
# Disable automatic reopening applications
###############################################################################

defaults write com.apple.loginwindow \
TALLogoutSavesState -bool false 2>/dev/null || true


###############################################################################
# Faster login
###############################################################################

defaults write com.apple.loginwindow \
DisableFDEAutoLogin -bool false 2>/dev/null || true


###############################################################################
# List login items
###############################################################################

osascript <<EOF
tell application "System Events"
    get the name of every login item
end tell
EOF


log "Login optimization completed."
}

run_module_command "${1:-apply}" "${2:-}"
