#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/logger.sh"
source "$SCRIPT_DIR/lib/backup_lib.sh"

backup() {
    create_backup update
}

restore() {
    restore_backup "$1"
}

log "Updating system"

brew update
brew upgrade
brew cleanup --prune=all -s
brew autoremove

softwareupdate --list

log "Update completed"
