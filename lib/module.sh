#!/usr/bin/env bash

MODULE_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MCBOOK_ROOT="$(cd "$MODULE_LIB_DIR/.." && pwd)"

source "$MODULE_LIB_DIR/logger.sh"
source "$MODULE_LIB_DIR/utils.sh"
source "$MODULE_LIB_DIR/backup_lib.sh"

MODULE_NAME="${MODULE_NAME:-$(basename "${BASH_SOURCE[1]:-$0}" .sh)}"

backup() {
    create_backup "${1:-$MODULE_NAME}"
}

apply() {
    write_default "$@"
}

restore() {
    restore_backup "$1"
}

run_module_command() {
    local command="${1:-apply}"

    case "$command" in
        apply)
            apply_module_config
            ;;
        backup)
            backup "$MODULE_NAME"
            ;;
        restore)
            if [[ -z "${2:-}" ]]; then
                error "Backup path required"
                return 1
            fi
            restore "$2"
            ;;
        help|-h|--help)
            printf 'Usage: %s [apply|backup|restore <backup-path>]\n' "$(basename "${BASH_SOURCE[1]:-$0}")"
            ;;
        *)
            error "Unknown module command: $command"
            return 1
            ;;
    esac
}
