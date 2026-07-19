#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/module.sh"

ensure_line() {
    local line="$1"
    local file="$2"

    if ! touch "$file" 2>/dev/null; then
        warn "Cannot update $file; add manually if needed: $line"
        return 0
    fi

    grep -Fqx "$line" "$file" || printf '%s\n' "$line" >> "$file"
}

apply_module_config() {
    info "Configuring Python tools"

    local python_available=0
    local pipx_log_dir="${PIPX_LOG_DIR:-$LOG_DIR/pipx}"

    mkdir -p "$pipx_log_dir"
    export PIPX_LOG_DIR="$pipx_log_dir"

    if ! command -v python3 >/dev/null 2>&1; then
        python_available=1
        log "Installing Python because python3 is not available"
        brew install python
    else
        log "Python already available: $(python3 --version 2>&1)"
    fi

    if ! command -v uv >/dev/null 2>&1; then
        log "Installing uv because it is not available"
        brew install uv
    else
        log "uv already available: $(uv --version 2>&1)"
    fi

    if ! command -v pipx >/dev/null 2>&1; then
        log "Installing pipx because it is not available"
        brew install pipx
    else
        log "pipx already available: $(pipx --version 2>&1)"
    fi

    if [ "$python_available" -ne 0 ]; then
        uv python install 3.13 2>/dev/null || true
    fi

    pipx ensurepath 2>/dev/null || warn "pipx ensurepath failed; continuing without changing shell PATH"

    local python_tools=(
        ruff
        poetry
    )

    local tool
    for tool in "${python_tools[@]}"; do
        if ! pipx list --short 2>/dev/null | awk '{print $1}' | grep -Fxq "$tool"; then
            log "Installing Python tool: $tool"
            pipx install "$tool" 2>/dev/null || true
        else
            log "Python tool already installed: $tool"
        fi
    done

    ensure_line 'export PYTHONUNBUFFERED=1' "$HOME/.zshrc"

    python3 --version
    uv --version

    log "Python environment completed"
}

run_module_command "${1:-apply}" "${2:-}"
