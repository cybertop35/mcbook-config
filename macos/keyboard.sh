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


log() {
    printf "[Keyboard] %s\n" "$1"
}


apply() {
    defaults write "$1" "$2" "-$3" "$4" 2>/dev/null || true
}


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
# Disable automatic correction
###############################################################################

apply NSGlobalDomain NSAutomaticSpellingCorrectionEnabled bool false


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

defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true


###############################################################################
# Disable press and hold accent menu
###############################################################################

apply NSGlobalDomain ApplePressAndHoldEnabled bool false


log "Keyboard optimization completed."