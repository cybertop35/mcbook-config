#!/usr/bin/env bash

###############################################################################
# Accessibility / UI Performance
###############################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/module.sh"

apply_module_config() {


log "Configuring accessibility..."


###############################################################################
# Reduce animations
###############################################################################

apply com.apple.universalaccess reduceMotion bool true


###############################################################################
# Reduce transparency
###############################################################################

# apply com.apple.universalaccess reduceTransparency bool true


###############################################################################
# Increase contrast slightly
###############################################################################

# apply com.apple.universalaccess increaseContrast bool false


log "Accessibility optimization completed."
}

run_module_command "${1:-apply}" "${2:-}"
