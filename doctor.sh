#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$ROOT/lib/logger.sh"
source "$ROOT/lib/backup_lib.sh"
source "$ROOT/lib/validation.sh"

backup() {
    create_backup doctor
}

restore() {
    restore_backup "$1"
}

log "Mac Bootstrap Doctor"
run_checks

log "Installed developer tools"
command -v git
command -v python3
command -v java
command -v docker
