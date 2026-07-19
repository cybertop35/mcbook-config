#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/module.sh"

apply_module_config() {
    log "Configuring Git"

    git config --global init.defaultBranch main
    git config --global pull.rebase true
    git config --global fetch.prune true
    git config --global core.autocrlf input
    git config --global core.editor "code --wait" 2>/dev/null || true

    git config --global alias.st status
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.cm commit
    git config --global alias.lg "log --oneline --graph --decorate --all"

    git config --global color.ui auto
    git config --global credential.helper osxkeychain

    log "Git configuration completed"
}

run_module_command "${1:-apply}" "${2:-}"
