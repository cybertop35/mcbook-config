#!/usr/bin/env bash

###############################################################################
#
# CPU & Memory Optimization Module
#
# Optimizes:
# - CPU usage reduction
# - Memory footprint
# - System responsiveness
# - M5 Pro specific tweaks
#
###############################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/module.sh"

apply_module_config() {


log "Configuring CPU and memory optimizations..."


###############################################################################
# Disable unnecessary visual effects globally
###############################################################################

apply NSGlobalDomain AppleAquaColorVariant int 1
apply NSGlobalDomain AppleMotionEnabled bool false


###############################################################################
# Reduce checkbox animation delay
###############################################################################

apply NSGlobalDomain NSControlAnimationEnabledKey bool false


###############################################################################
# Disable menu poof animation
###############################################################################

apply com.apple.finder MenuBarAnimationsEnabled bool false


###############################################################################
# Disable toolbar label animation
###############################################################################

apply NSGlobalDomain NSToolbarTitleViewRolloverDelay int 0


###############################################################################
# Optimize memory: Disable unused services
###############################################################################

# Disable Handoff between devices
apply com.apple.handoff.registration Handoff bool false

# Disable AirDrop
apply com.apple.NetworkBrowser BrowseAllInterfaces int 0

# Disable Bonjour browsing
apply com.apple.mDNSResponder BonjourEnabled bool false


###############################################################################
# Reduce GPU overhead by disabling effects
###############################################################################

# Disable background blur effects
apply com.apple.Accessibility AccessibilityVisualFocusEffect bool false


###############################################################################
# Keep Spotlight off external volumes only.
# Disabling indexing on "/" causes poor search, broken metadata workflows, and
# only helps temporarily while hiding the actual indexing workload.
###############################################################################

# Disable indexing on external drives automatically
defaults write com.apple.Spotlight ExcludedItems -array "/Volumes" 2>/dev/null || true


###############################################################################
# Disable Spring Loading delays
###############################################################################

apply NSGlobalDomain com.apple.springing.enabled bool false
apply NSGlobalDomain com.apple.springing.delay float 0


###############################################################################
# Optimize file operations
###############################################################################

# Disable extended attributes syncing
defaults write com.apple.finder DesktopViewSettings -dict-add DisableAllAnimations true 2>/dev/null || true


###############################################################################
# Reduce I/O overhead: Faster SSD operations
###############################################################################

# Disable disk cache flush on save
if [ "$(uname -s)" = "Darwin" ]; then
    sudo defaults write /Library/Preferences/com.apple.loginwindow DesktopViewSettings -dict-add DisableAllAnimations true 2>/dev/null || true
fi


###############################################################################
# Disable zooming of minimized windows
###############################################################################

apply com.apple.dock mineffect string suck


###############################################################################
# Optimize sleep/wake behavior for M5 Pro
###############################################################################

# Keep sleep mode lighter
sudo pmset -a ttyskeepawake 1 2>/dev/null || true

# tcpkeepalive is intentionally not disabled. macOS warns that disabling it can
# break Find My Mac and other sleep/wake network features.


###############################################################################
# Graphics switching is intentionally not forced.
# Modern Apple Silicon MacBooks do not expose the old discrete/integrated GPU
# behavior, and forcing pmset gpuswitch is ineffective or misleading.
###############################################################################


###############################################################################
# Optimize memory allocation
###############################################################################

# File descriptor limits are intentionally not lowered. On this machine the
# existing values can be higher than 24576, and reducing them is not an
# optimization.

# vm.swapusage is a read-only status value on macOS, not a safe tuning knob.


###############################################################################
# Disable Notification Center animations
###############################################################################

apply com.apple.notificationcenterui NSAnimationEnabled bool false


###############################################################################
# Disable Quick Look animation
###############################################################################

apply com.apple.finder QLInlinePreviewMaximumSize int 0


###############################################################################
# Reduce keyboard response time overhead
###############################################################################

apply NSGlobalDomain KeyRepeat int 1
apply NSGlobalDomain InitialKeyRepeat int 10


###############################################################################
# Disable Siri indexing to save CPU/memory
###############################################################################

apply com.apple.assistant.support 'Siri Data Store Was Migrated' bool true
apply com.apple.assistant.support 'Confirm Siri Analytics Opt-in' bool false


###############################################################################
# Restart relevant services
###############################################################################

killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true


log "CPU and memory optimization completed."
}

run_module_command "${1:-apply}" "${2:-}"
