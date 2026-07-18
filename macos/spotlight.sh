#!/usr/bin/env bash

###############################################################################
# Spotlight Optimization
###############################################################################

set -euo pipefail


log() {
    printf "[Spotlight] %s\n" "$1"
}


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