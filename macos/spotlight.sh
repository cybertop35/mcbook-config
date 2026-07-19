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
"$HOME/node_modules"
"$HOME/.venv"
"$HOME/venv"
"$HOME/.cache"
"$HOME/Library/Developer"
"$HOME/Library/Caches"
)


for DIR in "${EXCLUDES[@]}"
do
    if [ -d "$DIR" ]; then
        log "Excluding $DIR"
        sudo mdutil -i off "$DIR" 2>/dev/null || true
    fi
done


###############################################################################
# Developer folders
###############################################################################

sudo mdutil -E / 2>/dev/null || true


log "Spotlight optimization completed."
}

run_module_command "${1:-apply}" "${2:-}"
