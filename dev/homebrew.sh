#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/module.sh"

apply_module_config() {
    log "Checking Homebrew"

    if ! command -v brew >/dev/null 2>&1; then
        log "Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    log "Updating Homebrew"
    brew update

    local packages=(
        git
        gh
        wget
        curl
    )

    local casks=(
        intellij-idea
        sublime-text
    )

    local package
    for package in "${packages[@]}"; do
        if ! brew list "$package" >/dev/null 2>&1; then
            log "Installing package: $package"
            brew install "$package"
        fi
    done

    local cask
    for cask in "${casks[@]}"; do
        if ! brew list --cask "$cask" >/dev/null 2>&1; then
            log "Installing cask: $cask"
            brew install --cask "$cask"
        fi
    done

    brew cleanup --prune=all -s
    brew autoremove

    log "Homebrew setup completed"
}

run_module_command "${1:-apply}" "${2:-}"
