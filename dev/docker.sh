#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/module.sh"

ensure_brew_formula() {
    local formula="$1"

    if ! brew list "$formula" >/dev/null 2>&1; then
        log "Installing formula: $formula"
        brew install "$formula"
    fi
}

ensure_brew_cask() {
    local cask="$1"

    if ! brew list --cask "$cask" >/dev/null 2>&1; then
        log "Installing cask: $cask"
        brew install --cask "$cask"
    fi
}

ensure_line() {
    local line="$1"
    local file="$2"

    touch "$file"
    grep -Fqx "$line" "$file" || printf '%s\n' "$line" >> "$file"
}

link_docker_cli_plugin() {
    local formula="$1"
    local binary="$2"
    local plugin_name="$3"
    local source_path
    local plugin_dir="$HOME/.docker/cli-plugins"

    source_path="$(brew --prefix "$formula")/bin/$binary"

    if [[ -x "$source_path" ]]; then
        mkdir -p "$plugin_dir"
        ln -sf "$source_path" "$plugin_dir/$plugin_name"
    fi
}

apply_module_config() {
    info "Installing container tools"

    local docker_runtime="${DOCKER_RUNTIME:-colima}"
    local docker_ui="${DOCKER_UI:-none}"

    ensure_brew_formula docker
    ensure_brew_formula docker-buildx
    ensure_brew_formula docker-compose
    link_docker_cli_plugin docker-buildx docker-buildx docker-buildx
    link_docker_cli_plugin docker-compose docker-compose docker-compose

    case "$docker_runtime" in
        colima)
            ensure_brew_formula colima
            ensure_brew_formula qemu
            ensure_line 'alias docker-start="colima start"' "$HOME/.zshrc"
            ensure_line 'alias docker-stop="colima stop"' "$HOME/.zshrc"
            ;;
        orbstack)
            ensure_brew_cask orbstack
            ;;
        none)
            warn "Docker runtime installation skipped because DOCKER_RUNTIME=none"
            ;;
        *)
            error "Unsupported DOCKER_RUNTIME: $docker_runtime"
            return 1
            ;;
    esac

    case "$docker_ui" in
        none)
            log "Docker UI not installed. Set DOCKER_UI=orbstack or DOCKER_UI=docker-desktop if needed."
            ;;
        orbstack)
            ensure_brew_cask orbstack
            ;;
        docker-desktop)
            ensure_brew_cask docker-desktop
            warn "Docker Desktop may add background/login behavior. Disable 'Start Docker Desktop when you sign in' in its settings if installed."
            ;;
        *)
            error "Unsupported DOCKER_UI: $docker_ui"
            return 1
            ;;
    esac

    ensure_brew_formula kubectl
    ensure_brew_formula helm
    ensure_brew_formula k9s

    docker --version 2>/dev/null || true
    docker compose version 2>/dev/null || true
    kubectl version --client 2>/dev/null || true

    log "Docker daemon was not started automatically."
    log "Start Docker only when needed with: docker-start"
    log "Stop Docker when finished with: docker-stop"
    log "Docker environment completed"
}

run_module_command "${1:-apply}" "${2:-}"
