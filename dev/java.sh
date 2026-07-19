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
    info "Installing Java tools"

    brew install openjdk@21 maven gradle 2>/dev/null || true

    if /usr/libexec/java_home -v 21 >/dev/null 2>&1; then
        ensure_line 'export JAVA_HOME=$(/usr/libexec/java_home -v 21)' "$HOME/.zshrc"
        ensure_line 'export PATH=$JAVA_HOME/bin:$PATH' "$HOME/.zshrc"
    fi

    java -version || true
    mvn -version || true
    gradle -version || true

    log "Java environment completed"
}

run_module_command "${1:-apply}" "${2:-}"
