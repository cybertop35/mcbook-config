#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/lib/logger.sh"
source "$SCRIPT_DIR/lib/backup_lib.sh"

MACOS_MODULES=(
    accessibility
    battery
    cpu-memory
    desktop
    display
    dock
    finder
    keyboard
    login
    mouse
    network
    notifications
    power
    privacy
    security
    spotlight
    trackpad
)

DEV_MODULES=(
    homebrew
    git
    shell
    terminal
    docker
    java
    python
)

ALL_MODULES=("${MACOS_MODULES[@]}" "${DEV_MODULES[@]}")

if [[ -t 1 && "${NO_COLOR:-}" != "1" ]]; then
    GREEN=$'\033[0;32m'
    BLUE=$'\033[0;34m'
    YELLOW=$'\033[1;33m'
    RESET=$'\033[0m'
else
    GREEN=""
    BLUE=""
    YELLOW=""
    RESET=""
fi

module_script() {
    local module="$1"

    if [[ -f "$SCRIPT_DIR/macos/$module.sh" ]]; then
        printf '%s\n' "$SCRIPT_DIR/macos/$module.sh"
        return 0
    fi

    if [[ -f "$SCRIPT_DIR/dev/$module.sh" ]]; then
        printf '%s\n' "$SCRIPT_DIR/dev/$module.sh"
        return 0
    fi

    return 1
}

module_exists() {
    local module="$1"
    local candidate

    for candidate in "${ALL_MODULES[@]}"; do
        [[ "$candidate" == "$module" ]] && return 0
    done

    return 1
}

apply_one_module() {
    local module="$1"
    local script_path

    if ! module_exists "$module"; then
        error "Unknown module: $module"
        return 1
    fi

    if ! script_path="$(module_script "$module")"; then
        error "Module script missing: $module"
        return 1
    fi

    info "Applying module: $module"
    create_backup "$module" >/dev/null

    if ! bash "$script_path" apply; then
        error "Failed to apply module: $module"
        return 1
    fi
}

apply_modules() {
    local module="${1:-all}"
    local failed=0

    if [[ "$module" != "all" ]]; then
        apply_one_module "$module"
        return
    fi

    info "Applying all modules"
    create_backup all >/dev/null

    for module in "${ALL_MODULES[@]}"; do
        if ! apply_one_module_without_backup "$module"; then
            failed=1
        fi
    done

    if [[ "$failed" -ne 0 ]]; then
        error "One or more modules failed"
        return 1
    fi

    info "All modules applied"
}

apply_one_module_without_backup() {
    local module="$1"
    local script_path

    if ! script_path="$(module_script "$module")"; then
        warn "Skipping missing module script: $module"
        return 1
    fi

    info "Applying module: $module"

    if ! bash "$script_path" apply; then
        warn "Failed to apply module: $module"
        return 1
    fi
}

list_modules() {
    printf '\n%sAvailable macOS Modules:%s\n' "$BLUE" "$RESET"
    local module script_path
    for module in "${MACOS_MODULES[@]}"; do
        if script_path="$(module_script "$module")"; then
            printf '  ✓ %-18s %s\n' "$module" "${script_path#$SCRIPT_DIR/}"
        else
            printf '  ✗ %-18s missing\n' "$module"
        fi
    done

    printf '\n%sAvailable Development Modules:%s\n' "$BLUE" "$RESET"
    for module in "${DEV_MODULES[@]}"; do
        if script_path="$(module_script "$module")"; then
            printf '  ✓ %-18s %s\n' "$module" "${script_path#$SCRIPT_DIR/}"
        else
            printf '  ✗ %-18s missing\n' "$module"
        fi
    done
    printf '\n'
}

show_status() {
    info "System Configuration Status"

    if [[ -d "$BACKUP_BASE" ]]; then
        local backup_count
        backup_count="$(find "$BACKUP_BASE" -type d -name 'backup_*' | wc -l | tr -d ' ')"
        printf 'Backups available: %s\n' "$backup_count"
        find "$BACKUP_BASE" -maxdepth 1 -type d -name 'backup_*' -print | sort -r | head -5 | while IFS= read -r backup; do
            printf '  • %s\n' "$(basename "$backup")"
        done
    else
        warn "No backups found yet"
    fi

    printf '\nCurrent macOS defaults:\n'
    defaults read com.apple.universalaccess reduceMotion 2>/dev/null && printf '  ✓ Reduce Motion: enabled\n' || printf '  ✗ Reduce Motion: disabled\n'
    defaults read com.apple.universalaccess reduceTransparency 2>/dev/null && printf '  ✓ Reduce Transparency: enabled\n' || printf '  ✗ Reduce Transparency: disabled\n'
    defaults read com.apple.dock autohide 2>/dev/null && printf '  ✓ Dock Autohide: enabled\n' || printf '  ✗ Dock Autohide: disabled\n'
}

show_backups() {
    if [[ ! -d "$BACKUP_BASE" ]]; then
        warn "No backups exist yet"
        return
    fi

    info "Available backups"
    find "$BACKUP_BASE" -maxdepth 1 -type d -name 'backup_*' -print | sort -r | while IFS= read -r backup; do
        printf '  • %s (%s)\n' "$(basename "$backup")" "$(du -sh "$backup" | awk '{print $1}')"
    done
}

clean_backups() {
    if [[ ! -d "$BACKUP_BASE" ]]; then
        warn "No backups to clean"
        return
    fi

    find "$BACKUP_BASE" -maxdepth 1 -type d -name 'backup_*' -print | sort -r | tail -n +11 | while IFS= read -r backup; do
        warn "Removing old backup: $(basename "$backup")"
        rm -rf "$backup"
    done

    info "Cleanup completed"
}

validate_setup() {
    local total=0
    local found=0
    local module

    for module in "${ALL_MODULES[@]}"; do
        total=$((total + 1))
        module_script "$module" >/dev/null && found=$((found + 1))
    done

    printf 'Modules: %s/%s found\n' "$found" "$total"
    [[ -d "$BACKUP_BASE" ]] && printf 'Backup directory: ✓ %s\n' "$BACKUP_BASE" || printf 'Backup directory: will be created at %s\n' "$BACKUP_BASE"

    for command in defaults killall date; do
        if command -v "$command" >/dev/null 2>&1; then
            printf "Command '%s': ✓\n" "$command"
        else
            printf "Command '%s': ✗\n" "$command"
        fi
    done
}

show_help() {
    printf '%b\n' "\
${GREEN}MacBook Configuration Manager${RESET}

A unified control center for MacBook optimization and configuration.

${BLUE}USAGE:${RESET}
    ./mcbook.sh <command> [module]

${BLUE}COMMANDS:${RESET}
    apply [module]       Apply all modules or a single module. Default: all.
    backup [module]      Create a backup for all modules or one module. Default: all.
    restore <path>       Restore a backup.
    list                 List available modules.
    status               Show configuration and backup status.
    doctor               Run read-only system/performance diagnostics.
    backups              Show available backups.
    clean                Remove old backups, keeping the latest 10.
    validate             Validate script/module availability.
    help                 Show this help.

${BLUE}EXAMPLES:${RESET}
    ./mcbook.sh apply
    ./mcbook.sh apply dock
    ./mcbook.sh backup
    ./mcbook.sh backup python
    ./mcbook.sh restore ~/.mcbook-backups/backup_20260718_153000_all

${BLUE}MODULES:${RESET}
    macOS: ${MACOS_MODULES[*]}
    dev:   ${DEV_MODULES[*]}

${YELLOW}Backup location:${RESET} $BACKUP_BASE
"
}

main() {
    local command="${1:-help}"
    local module="${2:-all}"

    case "$command" in
        apply)
            apply_modules "$module"
            ;;
        backup)
            if [[ "$module" != "all" ]] && ! module_exists "$module"; then
                error "Unknown module: $module"
                return 1
            fi
            create_backup "$module"
            ;;
        restore)
            if [[ -z "${2:-}" ]]; then
                error "Backup path required"
                printf 'Usage: ./mcbook.sh restore <backup-path>\n'
                return 1
            fi
            restore_backup "$2"
            ;;
        list)
            list_modules
            ;;
        status)
            show_status
            ;;
        doctor)
            bash "$SCRIPT_DIR/doctor.sh"
            ;;
        backups)
            show_backups
            ;;
        clean)
            clean_backups
            ;;
        validate)
            validate_setup
            ;;
        help|-h|--help)
            show_help
            ;;
        *)
            error "Unknown command: $command"
            printf "Use './mcbook.sh help' for usage information.\n"
            return 1
            ;;
    esac
}

main "$@"
