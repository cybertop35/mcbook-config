#!/usr/bin/env bash

###############################################################################
# Spotlight Optimization
###############################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/module.sh"

apply_module_config() {


log "Configuring Spotlight exclusions..."


EXCLUDES=(
"$HOME/.m2"
"$HOME/.gradle"
"$HOME/.npm"
"$HOME/.cache/pip"
"$HOME/.cache/uv"
"$HOME/node_modules"
"$HOME/.venv"
"$HOME/venv"
"$HOME/.pyenv"
"$HOME/.sdkman"
"$HOME/.cache"
"$HOME/Library/Developer"
"$HOME/Library/Caches"
)

existing_excludes=()

for DIR in "${EXCLUDES[@]}"
do
    if [ -d "$DIR" ]; then
        log "Adding Spotlight privacy exclusion: $DIR"
        existing_excludes+=("$DIR")
    fi
done


###############################################################################
# Spotlight policy
###############################################################################

if [ "${#existing_excludes[@]}" -gt 0 ]; then
    defaults write com.apple.Spotlight Exclusions -array "${existing_excludes[@]}" 2>/dev/null || {
        warn "Could not write Spotlight exclusions automatically."
        warn "Use System Settings > Siri & Spotlight > Spotlight Privacy for folder exclusions."
    }
else
    warn "No configured developer/cache folders exist yet, so no Spotlight exclusions were added."
fi


log "Spotlight optimization completed."
}

run_module_command "${1:-apply}" "${2:-}"
