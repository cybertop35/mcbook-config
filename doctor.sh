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

section() {
    printf '\n'
    log "$1"
}

run_if_available() {
    local command_name="$1"
    shift

    if command -v "$command_name" >/dev/null 2>&1; then
        "$@" || true
    else
        warn "Command not available: $command_name"
    fi
}

print_command_path() {
    local command_name="$1"

    if command -v "$command_name" >/dev/null 2>&1; then
        printf '%-16s %s\n' "$command_name" "$(command -v "$command_name")"
    else
        printf '%-16s missing\n' "$command_name"
    fi
}

section "Mac Bootstrap Doctor"
run_checks

section "Installed developer tools"
for tool in git python3 java docker colima brew uv pipx; do
    print_command_path "$tool"
done

section "Memory pressure"
run_if_available memory_pressure memory_pressure

section "Virtual memory statistics"
run_if_available vm_stat vm_stat

section "Power settings"
run_if_available pmset pmset -g custom

section "Power assertions"
run_if_available pmset pmset -g assertions

section "Homebrew services"
run_if_available brew brew services list

section "Top CPU processes"
run_if_available top top -l 1 -o cpu -n 15

section "Launch agents summary"
if command -v launchctl >/dev/null 2>&1 && command -v id >/dev/null 2>&1; then
    launchctl print "gui/$(id -u)" 2>/dev/null | sed -n '1,120p' || true
else
    warn "launchctl or id not available"
fi
