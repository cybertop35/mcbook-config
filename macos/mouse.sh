#!/usr/bin/env bash

###############################################################################
#
# Mouse Optimization Module
#
###############################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/module.sh"

apply_module_config() {


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
}

run_module_command "${1:-apply}" "${2:-}"
