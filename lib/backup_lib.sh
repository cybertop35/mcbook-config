#!/usr/bin/env bash

BACKUP_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$BACKUP_LIB_DIR/logger.sh"

BACKUP_BASE="${BACKUP_BASE:-$HOME/.mcbook-backups}"

backup_domains_for_module() {
    case "$1" in
        accessibility) printf '%s\n' com.apple.universalaccess ;;
        desktop|dock) printf '%s\n' com.apple.dock com.apple.dashboard com.apple.notificationcenterui ;;
        display) printf '%s\n' com.apple.screencapture ;;
        finder) printf '%s\n' com.apple.finder com.apple.desktopservices ;;
        keyboard) printf '%s\n' NSGlobalDomain ;;
        login) printf '%s\n' com.apple.loginwindow ;;
        mouse) printf '%s\n' NSGlobalDomain com.apple.mouse ;;
        network) printf '%s\n' com.apple.NetworkBrowser com.apple.airport.preferences ;;
        notifications) printf '%s\n' com.apple.ncprefs com.apple.Siri com.apple.tips ;;
        privacy) printf '%s\n' com.apple.AdLib com.apple.Siri com.apple.locationd ;;
        security) printf '%s\n' /Library/Preferences/com.apple.loginwindow ;;
        spotlight) printf '%s\n' com.apple.Spotlight ;;
        trackpad) printf '%s\n' com.apple.AppleMultitouchTrackpad com.apple.driver.AppleBluetoothMultitouch.trackpad NSGlobalDomain ;;
        cpu-memory) printf '%s\n' NSGlobalDomain com.apple.finder com.apple.dock com.apple.Spotlight com.apple.handoff.registration com.apple.NetworkBrowser com.apple.mDNSResponder com.apple.Accessibility com.apple.notificationcenterui com.apple.assistant.support ;;
        battery|power|all|*) printf '%s\n' NSGlobalDomain com.apple.finder com.apple.dock com.apple.universalaccess com.apple.screencapture com.apple.mouse ;;
    esac
}

safe_domain_filename() {
    printf '%s' "$1" | tr '/ ' '__'
}

create_backup() {
    local module="${1:-all}"
    local backup_path="${2:-$BACKUP_BASE/backup_$(date +%Y%m%d_%H%M%S)_$module}"

    mkdir -p "$backup_path/defaults" "$backup_path/config" "$backup_path/apps"
    info "Creating backup for '$module': $backup_path"

    while IFS= read -r domain; do
        [[ -n "$domain" ]] || continue
        defaults export "$domain" "$backup_path/defaults/$(safe_domain_filename "$domain").plist" 2>/dev/null || true
    done < <(backup_domains_for_module "$module")

    if [[ "$module" == "all" || "$module" == "homebrew" || "$module" == "docker" || "$module" == "java" || "$module" == "python" || "$module" == "terminal" ]]; then
        if command -v brew >/dev/null 2>&1; then
            brew bundle dump --file="$backup_path/apps/Brewfile" --force 2>/dev/null || true
        fi
    fi

    [[ -f "$HOME/.zshrc" ]] && cp "$HOME/.zshrc" "$backup_path/config/zshrc" || true
    [[ -f "$HOME/.bashrc" ]] && cp "$HOME/.bashrc" "$backup_path/config/bashrc" || true
    [[ -f "$HOME/.gitconfig" ]] && cp "$HOME/.gitconfig" "$backup_path/config/gitconfig" || true
    [[ -f "$HOME/.ssh/config" ]] && cp "$HOME/.ssh/config" "$backup_path/config/ssh_config" || true

    printf '%s\n' "$backup_path"
}

restore_backup() {
    local backup_path="$1"

    if [[ ! -d "$backup_path" ]]; then
        error "Backup directory not found: $backup_path"
        return 1
    fi

    info "Restoring backup: $backup_path"

    if [[ -d "$backup_path/defaults" ]]; then
        local plist domain
        for plist in "$backup_path/defaults"/*.plist; do
            [[ -e "$plist" ]] || continue
            domain="$(basename "$plist" .plist | tr '__' '/ ')"
            defaults import "$domain" "$plist" 2>/dev/null || true
        done
    fi

    if [[ -d "$backup_path/config" ]]; then
        [[ -f "$backup_path/config/zshrc" ]] && cp "$backup_path/config/zshrc" "$HOME/.zshrc" || true
        [[ -f "$backup_path/config/bashrc" ]] && cp "$backup_path/config/bashrc" "$HOME/.bashrc" || true
        [[ -f "$backup_path/config/gitconfig" ]] && cp "$backup_path/config/gitconfig" "$HOME/.gitconfig" || true
        if [[ -f "$backup_path/config/ssh_config" ]]; then
            mkdir -p "$HOME/.ssh"
            cp "$backup_path/config/ssh_config" "$HOME/.ssh/config"
        fi
    fi

    killall Finder 2>/dev/null || true
    killall Dock 2>/dev/null || true
    killall SystemUIServer 2>/dev/null || true

    info "Restore completed from: $backup_path"
}
