#!/usr/bin/env bash

###############################################################################
# Power Management
###############################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/module.sh"

apply_module_config() {


log "Configuring power profiles..."


###############################################################################
# AC power
###############################################################################

sudo pmset -c sleep 30 2>/dev/null || true
sudo pmset -c displaysleep 15 2>/dev/null || true


###############################################################################
# Battery
###############################################################################

sudo pmset -b sleep 10 2>/dev/null || true
sudo pmset -b displaysleep 5 2>/dev/null || true


###############################################################################
# Disable wake timers on battery
###############################################################################

sudo pmset -b womp 0 2>/dev/null || true


###############################################################################
# Enable safe standby
###############################################################################

sudo pmset -a standby 1 2>/dev/null || true


###############################################################################
# Preserve sleep/wake network features
###############################################################################

# Keep TCP keepalive enabled. Disabling it can break Find My Mac and other
# expected macOS sleep/wake behavior.
if ! sudo pmset -a tcpkeepalive 1 2>/dev/null; then
    warn "Could not enable tcpkeepalive. Re-run from an interactive terminal with sudo if Find My Mac/sleep-wake network behavior is required."
fi


pmset -g 2>/dev/null || true


log "Power configuration completed."
}

run_module_command "${1:-apply}" "${2:-}"
