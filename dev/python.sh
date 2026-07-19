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
    info "Installing Python tools"

    brew install python uv pipx 2>/dev/null || true
    uv python install 3.13
    pipx ensurepath

    local python_tools=(
        ruff
        poetry
    )

    local tool
    for tool in "${python_tools[@]}"; do
        pipx install "$tool" 2>/dev/null || true
    done

    ensure_line 'export PYTHONUNBUFFERED=1' "$HOME/.zshrc"

    python3 --version
    uv --version

    log "Python environment completed"
}

run_module_command "${1:-apply}" "${2:-}"
