#!/usr/bin/env bash

###############################################################################
#
# Desktop Optimization Module
#
# Optimizes:
# - Desktop performance
# - Visual noise
# - External monitor workflow
#
###############################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/module.sh"

apply_module_config() {


log "Configuring Desktop..."


###############################################################################
# Disable desktop icon clutter
#
# Useful for developers using Finder/Desktop only as temporary workspace
###############################################################################

apply com.apple.finder CreateDesktop bool true


###############################################################################
# Finder desktop view
###############################################################################

apply com.apple.finder FXPreferredGroupBy string "None"


###############################################################################
# Disable icon shadow
###############################################################################

apply com.apple.finder DesktopViewSettings -dict-add showIconPreview true


###############################################################################
# Disable animation when changing spaces
###############################################################################

apply com.apple.dock workspaces-auto-swoosh bool false


###############################################################################
# Mission Control optimization
###############################################################################

apply com.apple.dock expose-group-by-app bool true


###############################################################################
# Disable dashboard
###############################################################################

apply com.apple.dashboard mcx-disabled bool true


###############################################################################
# Disable desktop notifications over wallpaper
###############################################################################

defaults write com.apple.notificationcenterui bannerTime -int 5 \
2>/dev/null || true


###############################################################################
# Restart affected services
###############################################################################

killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true


log "Desktop optimization completed."
}

run_module_command "${1:-apply}" "${2:-}"
