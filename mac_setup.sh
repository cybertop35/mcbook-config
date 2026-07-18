#!/usr/bin/env bash

###############################################################################
#
# Performance Optimization Module
#
# Optimizes:
# - UI responsiveness
# - Window animations
# - Dock responsiveness
# - Keyboard responsiveness
# - GPU usage
# - Memory usage
# - Developer experience
#
###############################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

CONFIG_FILE="$ROOT_DIR/config/defaults.env"

[[ -f "$CONFIG_FILE" ]] && source "$CONFIG_FILE"

################################################################################
# Helpers
################################################################################

log() {
    printf "[Performance] %s\n" "$1"
}

apply() {

    local domain="$1"
    local key="$2"
    local type="$3"
    local value="$4"

    log "Setting $domain::$key = $value"

    defaults write "$domain" "$key" "-$type" "$value" 2>/dev/null || true
}

################################################################################
# Global UI
################################################################################

log "Applying performance profile..."

################################################################################
# Reduce Motion
################################################################################

apply com.apple.universalaccess reduceMotion bool true

################################################################################
# Reduce Transparency
################################################################################

apply com.apple.universalaccess reduceTransparency bool true

################################################################################
# Disable automatic window animations
################################################################################

apply NSGlobalDomain NSAutomaticWindowAnimationsEnabled bool false

################################################################################
# Disable Quick Look animation
################################################################################

apply -g QLPanelAnimationDuration float 0

################################################################################
# Save panel animation
################################################################################

apply NSGlobalDomain NSNavPanelExpandedStateForSaveMode bool true
apply NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 bool true

################################################################################
# Print panel expanded
################################################################################

apply NSGlobalDomain PMPrintingExpandedStateForPrint bool true
apply NSGlobalDomain PMPrintingExpandedStateForPrint2 bool true

################################################################################
# Disable Resume
################################################################################

apply com.apple.systempreferences NSQuitAlwaysKeepsWindows bool false

################################################################################
# Disable opening applications warning
################################################################################

apply com.apple.LaunchServices LSQuarantine bool false

################################################################################
# Disable automatic termination
################################################################################

apply NSGlobalDomain NSDisableAutomaticTermination bool true

################################################################################
# Expand save dialogs
################################################################################

apply NSGlobalDomain NSNavPanelExpandedStateForSaveMode bool true

################################################################################
# Faster resize
################################################################################

apply NSGlobalDomain NSWindowResizeTime float 0.001

################################################################################
# Disable auto capitalization
################################################################################

apply NSGlobalDomain NSAutomaticCapitalizationEnabled bool false

################################################################################
# Disable smart quotes
################################################################################

apply NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled bool false

################################################################################
# Disable smart dashes
################################################################################

apply NSGlobalDomain NSAutomaticDashSubstitutionEnabled bool false

################################################################################
# Disable automatic spelling correction
################################################################################

apply NSGlobalDomain NSAutomaticSpellingCorrectionEnabled bool false

################################################################################
# Disable period substitution
################################################################################

apply NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled bool false

################################################################################
# Disable automatic text completion
################################################################################

apply NSGlobalDomain NSAutomaticTextCompletionEnabled bool false

################################################################################
# Disable press-and-hold
################################################################################

apply NSGlobalDomain ApplePressAndHoldEnabled bool false

################################################################################
# Scrollbars always visible
################################################################################

apply NSGlobalDomain AppleShowScrollBars string Always

################################################################################
# Disable crash reporter dialogs
################################################################################

apply com.apple.CrashReporter DialogType string none

################################################################################
# Mission Control animation speed
################################################################################

apply com.apple.dock expose-animation-duration float 0.1

################################################################################
# Disable Dashboard (older systems)
################################################################################

apply com.apple.dashboard mcx-disabled bool true

################################################################################
# Disable automatic rearrange spaces
################################################################################

apply com.apple.dock mru-spaces bool false

################################################################################
# Disable launch animation
################################################################################

apply com.apple.dock launchanim bool false

################################################################################
# Disable Dock bouncing
################################################################################

apply com.apple.dock no-bouncing bool true

################################################################################
# Remove Dock delay
################################################################################

apply com.apple.dock autohide-delay float 0

################################################################################
# Fast Dock animation
################################################################################

apply com.apple.dock autohide-time-modifier float 0.15

################################################################################
# Disable recent applications
################################################################################

apply com.apple.dock show-recents bool false

################################################################################
# Disable Finder animation
################################################################################

apply com.apple.finder DisableAllAnimations bool true

################################################################################
# Disable extension change warning
################################################################################

apply com.apple.finder FXEnableExtensionChangeWarning bool false

################################################################################
# Disable empty trash warning
################################################################################

apply com.apple.finder WarnOnEmptyTrash bool false

################################################################################
# Keep folders on top
################################################################################

apply com.apple.finder _FXSortFoldersFirst bool true

################################################################################
# Speed up Help Viewer
################################################################################

apply com.apple.helpviewer DevMode bool true

################################################################################
# Screenshot shadow
################################################################################

apply com.apple.screencapture disable-shadow bool true

################################################################################
# Disable Siri Suggestions
################################################################################

apply com.apple.Siri StatusMenuVisible bool false

################################################################################
# Disable personalized ads
################################################################################

apply com.apple.AdLib allowApplePersonalizedAdvertising bool false

################################################################################
# Disable Photos auto-open
################################################################################

defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true \
2>/dev/null || true

################################################################################
# Restart affected services
################################################################################

log "Restarting services..."

killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

################################################################################

log "Performance profile successfully applied."

echo
echo "Some changes require logout/reboot."