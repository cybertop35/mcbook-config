#!/usr/bin/env bash

VALIDATION_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$VALIDATION_DIR/logger.sh"

check_macos_version() {
    local version
    version="$(sw_vers -productVersion)"
    log "macOS version: $version"
}

check_architecture() {
    local architecture
    architecture="$(uname -m)"
    log "Architecture: $architecture"
}

check_disk() {
    local free
    free="$(df -h / | awk 'NR==2 {print $4}')"
    log "Free disk: $free"
}

check_memory() {
    memory_pressure
}

check_homebrew() {
    if command -v brew >/dev/null 2>&1; then
        log "Homebrew OK"
    else
        warn "Homebrew missing"
    fi
}

run_checks() {
    check_macos_version
    check_architecture
    check_disk
    check_memory
    check_homebrew
}
