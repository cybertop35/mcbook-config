#!/usr/bin/env bash

################################################################################
#
# MacBook Configuration Manager
#
# Master control script for MacBook optimization and configuration.
# Provides unified backup/restore/apply functionality for all modules.
#
# Usage:
#   ./mcbook.sh backup [module]         Create backup
#   ./mcbook.sh apply [module]          Apply configuration
#   ./mcbook.sh restore <backup-path>   Restore from backup
#   ./mcbook.sh list                    List available modules
#   ./mcbook.sh status                  Show backup status
#   ./mcbook.sh clean                   Clean old backups
#
################################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/lib/logger.sh"


BACKUP_BASE="$HOME/.mcbook-backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
CURRENT_BACKUP="$BACKUP_BASE/backup_$TIMESTAMP"

# Source centralized logging

# Color codes for enhanced output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

################################################################################
# Module Definitions
################################################################################

# macOS optimization modules
MACOS_MODULES=(
    "accessibility"
    "battery"
    "cpu-memory"
    "desktop"
    "display"
    "dock"
    "finder"
    "keyboard"
    "login"
    "mouse"
    "network"
    "notifications"
    "performance"
    "power"
    "privacy"
    "security"
    "spotlight"
    "trackpad"
)

# Development modules
DEV_MODULES=(
    "homebrew"
    "git"
    "shell"
    "terminal"
    "docker"
    "java"
    "pythone"
)

# All modules
ALL_MODULES=("${MACOS_MODULES[@]}" "${DEV_MODULES[@]}")

################################################################################
# Backup/Restore Functions
################################################################################

create_backup() {
    local module="$1"
    
    mkdir -p "$CURRENT_BACKUP"
    echo "Current backup folder $CURRENT_BACKUP"
    if [ "$module" = "all" ]; then
        log "Creating comprehensive backup for all modules..."
        _backup_system_defaults
        _backup_applications
        _backup_configs
    else
        log "Creating backup for module: $module"
        _backup_system_defaults "$module"
    fi
    
    echo "$CURRENT_BACKUP"
}

_backup_system_defaults() {
   # local module="$1"
    
    info "Backing up macOS defaults..."
    
    # Create defaults directory
    mkdir -p "$CURRENT_BACKUP/defaults"
    
    # Backup global settings
    defaults export NSGlobalDomain "$CURRENT_BACKUP/defaults/global.plist" 2>/dev/null || true
    
    # Backup application settings (common ones)
    for app in com.apple.finder com.apple.dock com.apple.universalaccess com.apple.screencapture com.apple.mouse; do
        defaults export "$app" "$CURRENT_BACKUP/defaults/${app##*.}.plist" 2>/dev/null || true
    done
    
    info "System defaults backed up to: $CURRENT_BACKUP/defaults/"
}

_backup_applications() {
    info "Backing up Homebrew packages..."
    mkdir -p "$CURRENT_BACKUP/apps"
    
    if command -v brew >/dev/null 2>&1; then
        brew bundle dump --file="$CURRENT_BACKUP/apps/Brewfile" --force 2>/dev/null || true
    fi
}

_backup_configs() {
    info "Backing up configuration files..."
    mkdir -p "$CURRENT_BACKUP/config"
    
    [ -f ~/.zshrc ] && cp ~/.zshrc "$CURRENT_BACKUP/config/zshrc" || true
    [ -f ~/.gitconfig ] && cp ~/.gitconfig "$CURRENT_BACKUP/config/gitconfig" || true
    [ -f ~/.bashrc ] && cp ~/.bashrc "$CURRENT_BACKUP/config/bashrc" || true
    [ -f ~/.ssh/config ] && cp ~/.ssh/config "$CURRENT_BACKUP/config/ssh_config" || true
}

restore_backup() {
    local backup_path="$1"
    
    if [ ! -d "$backup_path" ]; then
        error "Backup directory not found: $backup_path"
        return 1
    fi
    
    log "Restoring from backup: $backup_path"
    
    # Restore defaults
    if [ -d "$backup_path/defaults" ]; then
        info "Restoring system defaults..."
        defaults import NSGlobalDomain "$backup_path/defaults/global.plist" 2>/dev/null || true
        
        for plist in "$backup_path/defaults"/*.plist; do
            [ "$plist" != "$backup_path/defaults/global.plist" ] || continue
            local domain=$(basename "$plist" .plist)
            defaults import "com.apple.$domain" "$plist" 2>/dev/null || true
        done
    fi
    
    # Restart affected services
    info "Restarting system services..."
    killall Finder 2>/dev/null || true
    killall Dock 2>/dev/null || true
    killall SystemUIServer 2>/dev/null || true
    
    log "Restore completed from: $backup_path"
}

################################################################################
# Module Application Functions
################################################################################

apply_module() {
    local module="$1"
    
    if [ "$module" = "all" ]; then
        apply_all_modules
        return
    fi
    
    # Find the module script
    local script_path=""
    for dir in "$SCRIPT_DIR/macos" "$SCRIPT_DIR/dev"; do
        if [ -f "$dir/${module}.sh" ]; then
            script_path="$dir/${module}.sh"
            break
        fi
    done
    
    if [ -z "$script_path" ]; then
        error "Module not found: $module"
        return 1
    fi
    
    log "Applying module: $module"
    
    # First backup
    create_backup "$module"
    
    # Then apply
    bash "$script_path" 2>&1 || error "Failed to apply module: $module"
    log "Module applied: $module"
}

apply_all_modules() {
    log "Applying all modules..."
    
    # Create full backup first
    create_backup "all"
    
    # Apply macOS modules first
    for module in "${MACOS_MODULES[@]}"; do
        local script="$SCRIPT_DIR/macos/${module}.sh"
        if [ -f "$script" ]; then
            info "Applying: $module"
            bash "$script" 2>&1 || warn "Failed to apply module: $module"
        fi
    done
    
    # Then development modules
    for module in "${DEV_MODULES[@]}"; do
        local script="$SCRIPT_DIR/dev/${module}.sh"
        if [ -f "$script" ]; then
            info "Applying: $module"
            bash "$script" 2>&1 || warn "Failed to apply module: $module"
        fi
    done
    
    log "All modules applied successfully"
}

################################################################################
# List and Status Functions
################################################################################

list_modules() {
    echo ""
    echo "Available macOS Optimization Modules:"
    echo "────────────────────────────────────"
    for module in "${MACOS_MODULES[@]}"; do
        local script="$SCRIPT_DIR/macos/${module}.sh"
        local status="✓"
        [ -f "$script" ] || status="✗"
        printf "  ${status} %-20s (%s)\n" "$module" "$([ -f "$script" ] && echo 'ready' || echo 'missing')"
    done
    
    echo ""
    echo "Available Development Modules:"
    echo "──────────────────────────────"
    for module in "${DEV_MODULES[@]}"; do
        local script="$SCRIPT_DIR/dev/${module}.sh"
        local status="✓"
        [ -f "$script" ] || status="✗"
        printf "  ${status} %-20s (%s)\n" "$module" "$([ -f "$script" ] && echo 'ready' || echo 'missing')"
    done
    echo ""
}

show_status() {
    echo ""
    info "System Configuration Status"
    echo ""
    
    # Show backup status
    if [ -d "$BACKUP_BASE" ]; then
        local backup_count=$(find "$BACKUP_BASE" -type d -name "backup_*" | wc -l)
        echo "Backups available: $backup_count"
        echo ""
        echo "Recent backups:"
        find "$BACKUP_BASE" -type d -name "backup_*" -printf '%T@ %p\n' | sort -rn | head -5 | while read -r _ path; do
            local name=$(basename "$path")
            echo "  • $name"
        done
    else
        warn "No backups found yet"
    fi
    
    echo ""
    echo "Current macOS defaults:"
    defaults read com.apple.universalaccess reduceMotion 2>/dev/null && echo "  ✓ Reduce Motion: enabled" || echo "  ✗ Reduce Motion: disabled"
    defaults read com.apple.universalaccess reduceTransparency 2>/dev/null && echo "  ✓ Reduce Transparency: enabled" || echo "  ✗ Reduce Transparency: disabled"
    defaults read com.apple.dock autohide 2>/dev/null && echo "  ✓ Dock Autohide: enabled" || echo "  ✗ Dock Autohide: disabled"
    
    echo ""
}

show_backups() {
    echo ""
    info "Available Backups"
    echo ""
    
    if [ ! -d "$BACKUP_BASE" ]; then
        warn "No backups exist yet"
        return
    fi
    
    find "$BACKUP_BASE" -maxdepth 1 -type d -name "backup_*" | sort -r | while read -r backup; do
        local name=$(basename "$backup")
        local size=$(du -sh "$backup" | cut -f1)
        local date="${name:7:8}"
        local time="${name:16:6}"
        echo "  • $name (${size})"
    done
    
    echo ""
}

clean_backups() {
    info "Cleaning old backups..."
    
    if [ ! -d "$BACKUP_BASE" ]; then
        warn "No backups to clean"
        return
    fi
    
    # Keep only last 10 backups
    find "$BACKUP_BASE" -maxdepth 1 -type d -name "backup_*" | sort -r | tail -n +11 | while read -r backup; do
        warn "Removing old backup: $(basename "$backup")"
        rm -rf "$backup"
    done
    
    log "Cleanup completed"
}

################################################################################
# Validation Functions
################################################################################

validate_setup() {
    echo ""
    info "Validating setup..."
    echo ""
    
    # Check key modules exist
    local total_modules=0
    local found_modules=0
    
    for module in "${MACOS_MODULES[@]}" "${DEV_MODULES[@]}"; do
        ((total_modules++))
        if [ -f "$SCRIPT_DIR/macos/${module}.sh" ] || [ -f "$SCRIPT_DIR/dev/${module}.sh" ]; then
            ((found_modules++))
        fi
    done
    
    echo "Modules: $found_modules/$total_modules found"
    
    # Check backup directory
    [ -d "$BACKUP_BASE" ] && echo "Backup directory: ✓ $BACKUP_BASE" || echo "Backup directory: ✗ Not found (will be created)"
    
    # Check required commands
    local commands=("defaults" "killall" "date")
    for cmd in "${commands[@]}"; do
        if command -v "$cmd" >/dev/null 2>&1; then
            echo "Command '$cmd': ✓"
        else
            echo "Command '$cmd': ✗"
        fi
    done
    
    echo ""
}

################################################################################
# Help Function
################################################################################

show_help() {
    cat << EOF

${GREEN}MacBook Configuration Manager${NC}

A unified control center for MacBook optimization and configuration.

${BLUE}USAGE:${NC}
    mcbook.sh [COMMAND] [OPTIONS]

${BLUE}COMMANDS:${NC}
    apply [module]           Apply configuration for a module or all modules
                            Default: all modules
                            
                            Examples:
                              mcbook.sh apply dock
                              mcbook.sh apply all
                              mcbook.sh apply                # applies all

    backup [module]         Create a backup before applying changes
                            Default: backup all settings
                            
                            Examples:
                              mcbook.sh backup
                              mcbook.sh backup dock

    restore <path>         Restore system to previous state
                           
                           Examples:
                             mcbook.sh restore ~/.mcbook-backups/backup_20260718_153000
                             mcbook.sh restore \$(ls -td ~/.mcbook-backups/backup_* | head -1)

    list                   List all available modules

    status                 Show current configuration status

    backups                Show available backups

    clean                  Remove old backups (keeps latest 10)

    validate               Validate system setup

    help                   Show this help message

${BLUE}EXAMPLES:${NC}
    
    # Apply all optimizations with automatic backup
    mcbook.sh apply
    
    # Apply just dock optimization
    mcbook.sh apply dock
    
    # Backup current state
    mcbook.sh backup
    
    # Restore from specific backup
    mcbook.sh restore ~/.mcbook-backups/backup_20260718_153000
    
    # View available backups
    mcbook.sh backups
    
    # Check system status
    mcbook.sh status
    
    # List all available modules
    mcbook.sh list

${BLUE}MODULES:${NC}

macOS Optimization:
    ${MACOS_MODULES[*]}

Development Setup:
    ${DEV_MODULES[*]}

${BLUE}BACKUP LOCATION:${NC}
    ~/.mcbook-backups/

${BLUE}NOTES:${NC}
    • Backups are created automatically when applying changes
    • All changes are reversible through restore
    • Latest 10 backups are kept by default
    • Use 'mcbook.sh clean' to remove old backups

EOF
}

################################################################################
# Main Script Logic
################################################################################

main() {
    local command="${1:-help}"
    
    case "$command" in
        apply)
            local module="${2:-all}"
            apply_module "$module"
            ;;
            
        backup)
            local module="${2:-all}"
            create_backup "$module"
            ;;
            
        restore)
            if [ -z "${2:-}" ]; then
                error "Backup path required"
                echo "Usage: mcbook.sh restore <backup-path>"
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
            echo ""
            echo "Use 'mcbook.sh help' for usage information"
            return 1
            ;;
    esac
}

# Run main function
main "$@"
