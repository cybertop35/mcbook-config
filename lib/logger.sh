#!/usr/bin/env bash

LOGGER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${LOG_DIR:-$LOGGER_DIR/../logs}"
LOG_FILE="${LOG_FILE:-$LOG_DIR/mac-bootstrap.log}"

mkdir -p "$LOG_DIR"

if [[ -t 1 && "${NO_COLOR:-}" != "1" ]]; then
    LOGGER_GREEN=$'\033[0;32m'
    LOGGER_YELLOW=$'\033[1;33m'
    LOGGER_RED=$'\033[0;31m'
    LOGGER_BLUE=$'\033[0;34m'
    LOGGER_RESET=$'\033[0m'
else
    LOGGER_GREEN=""
    LOGGER_YELLOW=""
    LOGGER_RED=""
    LOGGER_BLUE=""
    LOGGER_RESET=""
fi

log() {
    local level="INFO"

    case "${1:-}" in
        INFO|WARN|ERROR|DEBUG)
            level="$1"
            shift
            ;;
    esac

    local message="$*"
    local color="$LOGGER_BLUE"

    case "$level" in
        INFO) color="$LOGGER_GREEN" ;;
        WARN) color="$LOGGER_YELLOW" ;;
        ERROR) color="$LOGGER_RED" ;;
    esac

    local line
    line="$(date '+%Y-%m-%d %H:%M:%S') [$level] $message"

    printf '%b%s%b\n' "$color" "$line" "$LOGGER_RESET"
    printf '%s\n' "$line" >> "$LOG_FILE"
}

info() {
    log INFO "$@"
}

warn() {
    log WARN "$@"
}

error() {
    log ERROR "$@"
}
