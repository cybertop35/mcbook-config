#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/module.sh"

ensure_line() {
    local line="$1"
    local file="$2"

    touch "$file"
    grep -Fqx "$line" "$file" || printf '%s\n' "$line" >> "$file"
}

apply_module_config() {
    log "Installing terminal tools"

    brew install fzf bat eza fd ripgrep zoxide tree htop jq 2>/dev/null || true

    "$(brew --prefix)"/opt/fzf/install --all --no-bash --no-fish --no-update-rc 2>/dev/null || true

    ensure_line 'alias ll="eza -lah"' "$HOME/.zshrc"
    ensure_line 'alias la="eza -la"' "$HOME/.zshrc"
    ensure_line 'alias cat="bat"' "$HOME/.zshrc"
    ensure_line 'alias grep="rg"' "$HOME/.zshrc"
    ensure_line 'eval "$(zoxide init zsh)"' "$HOME/.zshrc"

    log "Terminal configuration completed"
}

run_module_command "${1:-apply}" "${2:-}"
