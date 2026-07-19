#!/usr/bin/env bash

###############################################################################
# Notification Optimization
###############################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/module.sh"

apply_module_config() {


log "Reducing notification noise..."


###############################################################################
# Disable notification previews
###############################################################################

defaults write com.apple.ncprefs content_visibility -int 0 \
2>/dev/null || true


###############################################################################
# Disable Siri suggestions
###############################################################################

defaults write com.apple.Siri StatusMenuVisible -bool false 2>/dev/null || true


###############################################################################
# Disable tips
###############################################################################

defaults write com.apple.tips dismissedTips -bool true \
2>/dev/null || true


killall NotificationCenter 2>/dev/null || true


log "Notifications optimized."
}

run_module_command "${1:-apply}" "${2:-}"
