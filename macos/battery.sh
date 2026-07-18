#!/usr/bin/env bash

###############################################################################
# Battery Optimization
#
# Focus:
# - Battery longevity
# - Reduce unnecessary background wakeups
# - Preserve M5 Pro performance
###############################################################################

set -euo pipefail


log() {
    printf "[Battery] %s\n" "$1"
}


log "Configuring battery..."


###############################################################################
# Disable Power Nap on battery
###############################################################################

sudo pmset -b powernap 0 2>/dev/null || true


###############################################################################
# Disable wake for network on battery
###############################################################################

sudo pmset -b tcpkeepalive 0 2>/dev/null || true


###############################################################################
# Faster display sleep on battery
###############################################################################

sudo pmset -b displaysleep 5 2>/dev/null || true


###############################################################################
# System sleep after inactivity
###############################################################################

sudo pmset -b sleep 10 2>/dev/null || true


###############################################################################
# Enable standby
###############################################################################

sudo pmset -a standby 1 2>/dev/null || true


###############################################################################
# Safe hibernation mode
###############################################################################

sudo pmset -a hibernatemode 3 2>/dev/null || true


###############################################################################
# Keep full performance when plugged
###############################################################################

sudo pmset -c powernap 1 2>/dev/null || true


pmset -g custom


log "Battery configuration completed."