#!/usr/bin/env bash

###############################################################################
# Security Hardening
###############################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/module.sh"

apply_module_config() {


log "Applying security checks..."


###############################################################################
# Firewall
###############################################################################

sudo /usr/libexec/ApplicationFirewall/socketfilterfw \
-setglobalstate on \
2>/dev/null || true


###############################################################################
# Enable stealth mode
###############################################################################

sudo /usr/libexec/ApplicationFirewall/socketfilterfw \
-setstealthmode on \
2>/dev/null || true


###############################################################################
# Disable guest account
###############################################################################

sudo defaults write /Library/Preferences/com.apple.loginwindow \
GuestEnabled -bool false


###############################################################################
# Automatic security updates
###############################################################################

sudo softwareupdate --schedule on \
2>/dev/null || true


###############################################################################
# Check FileVault status
###############################################################################

fdesetup status 2>/dev/null || true


log "Security configuration completed."
}

run_module_command "${1:-apply}" "${2:-}"
