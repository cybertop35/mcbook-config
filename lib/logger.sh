#!/usr/bin/env bash

LOG_DIR="$(dirname "${BASH_SOURCE[0]}")/../logs"

mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/mac-bootstrap.log"


log() {

    local LEVEL="$1"
    shift

    local MESSAGE="$*"

    echo "$(date '+%Y-%m-%d %H:%M:%S') [$LEVEL] $MESSAGE" \
        | tee -a "$LOG_FILE"

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