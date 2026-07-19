#!/usr/bin/env bash

###############################################################################
#
# Keyboard Optimization Module
#
# Optimizes:
# - Typing speed
# - Developer workflow
# - Removes unwanted text transformations
#
###############################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/module.sh"

apply_module_config() {


log "Configuring keyboard..."


###############################################################################
# Faster key repeat
###############################################################################

apply NSGlobalDomain KeyRepeat int 2


###############################################################################
# Short delay before repeat
###############################################################################

apply NSGlobalDomain InitialKeyRepeat int 15


###############################################################################
# Disable auto capitalization
###############################################################################

apply NSGlobalDomain NSAutomaticCapitalizationEnabled bool false


###############################################################################
# Enable automatic correction
###############################################################################

apply NSGlobalDomain NSAutomaticSpellingCorrectionEnabled bool true


###############################################################################
# Disable smart quotes
###############################################################################

apply NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled bool false


###############################################################################
# Disable smart dashes
###############################################################################

apply NSGlobalDomain NSAutomaticDashSubstitutionEnabled bool false


###############################################################################
# Disable automatic period after double space
###############################################################################

apply NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled bool false


###############################################################################
# Disable text completion
###############################################################################

apply NSGlobalDomain NSAutomaticTextCompletionEnabled bool false


###############################################################################
# Enable full keyboard access
###############################################################################

defaults write NSGlobalDomain AppleKeyboardUIMode -int 3


###############################################################################
# Use F1-F12 as standard keys
# (comment if you prefer media keys)
###############################################################################

# defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true


###############################################################################
# Disable press and hold accent menu
###############################################################################

apply NSGlobalDomain ApplePressAndHoldEnabled bool false


log "Keyboard optimization completed."
}

run_module_command "${1:-apply}" "${2:-}"
