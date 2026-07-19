# MacBook Optimization Guide

## Overview

This repository provides a modular MacBook configuration manager. The current implementation focuses on repeatable macOS settings, development environment setup, centralized logging, and reversible changes through backups.

The main entrypoint is [mcbook.sh](/Users/marco/project/repository/mcbook-config/mcbook.sh).

## Command Reference

### Apply Configuration

```bash
./mcbook.sh apply              # Apply all modules with an automatic full backup
./mcbook.sh apply dock         # Apply one module with an automatic module backup
./mcbook.sh apply cpu-memory   # Apply another single module
```

### Backup Management

```bash
./mcbook.sh backup             # Backup all supported configuration areas
./mcbook.sh backup dock        # Backup one module's related configuration
./mcbook.sh backups            # List available backups
./mcbook.sh clean              # Remove old backups, keeping the latest 10
```

### Restore Configuration

```bash
./mcbook.sh restore ~/.mcbook-backups/backup_20260718_154000_all
./mcbook.sh restore "$(ls -td ~/.mcbook-backups/backup_* | head -1)"
```

### Information

```bash
./mcbook.sh list               # List all 24 available modules
./mcbook.sh status             # Show current configuration and backup status
./mcbook.sh validate           # Validate module/script availability
./mcbook.sh help               # Show help with terminal colors when supported
```

## Available Modules

### macOS Optimization Modules

- accessibility
- battery
- cpu-memory
- desktop
- display
- dock
- finder
- keyboard
- login
- mouse
- network
- notifications
- power
- privacy
- security
- spotlight
- trackpad

### Development Setup Modules

- homebrew
- git
- shell
- terminal
- docker
- java
- python

Notes:

- The stale `performance` module entry was removed because no matching script exists.
- `pythone.sh` was renamed to `python.sh`.
- `macos/validate.sh` was removed because validation is handled by `./mcbook.sh validate`.

## Module Interface

Every module now uses the shared module helper in [lib/module.sh](/Users/marco/project/repository/mcbook-config/lib/module.sh) and supports the same commands:

```bash
bash macos/dock.sh apply
bash macos/dock.sh backup
bash macos/dock.sh restore ~/.mcbook-backups/backup_20260718_154000_dock
```

When run without arguments, modules default to `apply`.

## Logging

All scripts use the centralized logger in [lib/logger.sh](/Users/marco/project/repository/mcbook-config/lib/logger.sh).

- Logs are written to `logs/mac-bootstrap.log`.
- Terminal output uses color when stdout is interactive.
- Color is disabled when output is piped or `NO_COLOR=1` is set.
- Use `log`, `info`, `warn`, and `error` instead of defining script-local logging functions.

## Backup and Restore

Backups are managed by [lib/backup_lib.sh](/Users/marco/project/repository/mcbook-config/lib/backup_lib.sh).

Default backup location:

```text
~/.mcbook-backups/
```

Backup names include a timestamp and module name:

```text
backup_YYYYMMDD_HHMMSS_all/
backup_YYYYMMDD_HHMMSS_dock/
backup_YYYYMMDD_HHMMSS_python/
```

Backup structure:

```text
backup_YYYYMMDD_HHMMSS_module/
├── defaults/
│   └── exported macOS defaults plist files
├── apps/
│   └── Brewfile, when Homebrew is available and relevant
└── config/
    ├── zshrc
    ├── bashrc
    ├── gitconfig
    └── ssh_config
```

The main `apply` command creates backups automatically before applying changes.

## Optimization Changes

### Display Module

- Reduces motion and window animation overhead.
- Configures screenshot format/location behavior.
- Reduces screenshot shadow overhead.

### Dock Module

- Enables Dock autohide.
- Reduces Dock show/hide delay.
- Disables launch animation and bouncing.
- Disables recent apps.
- Uses a fast but still functional animation time.

### Accessibility Module

- Enables Reduce Motion.
- Keeps transparency/contrast settings conservative unless explicitly enabled in the script.

### Desktop Module

- Reduces workspace/desktop visual overhead.
- Disables Dashboard.
- Reduces notification animation timing.

### CPU and Memory Module

The CPU/memory module was corrected to avoid unsafe or ineffective settings.

Kept:

- Reduced visual effects.
- Reduced Finder/Dock/UI animation overhead.
- Handoff/AirDrop/Bonjour-related background reduction where configured.
- File descriptor limit tuning.
- Battery wake timer reduction.
- External-volume Spotlight exclusion preference.

Removed or avoided:

- Disabling Spotlight indexing on `/`.
- Forcing `pmset gpuswitch`.
- Writing `vm.swapusage`.

Reasoning:

- Disabling Spotlight on the root volume usually creates more workflow damage than performance benefit.
- `gpuswitch` is an old Intel/discrete GPU-era setting and is ineffective or misleading on modern Apple Silicon machines.
- `vm.swapusage` is a status value, not a safe macOS tuning knob.

### Development Modules

Package ownership was made less duplicated:

- `homebrew.sh`: Homebrew plus baseline tools/apps.
- `terminal.sh`: terminal CLI tools and shell aliases.
- `python.sh`: Python, `uv`, `pipx`, `ruff`, `poetry`.
- `java.sh`: OpenJDK 21, Maven, Gradle.
- `docker.sh`: Docker CLI, Compose, Buildx, lazy Docker runtime, and Kubernetes tools.

Docker defaults:

- Installs Docker CLI tooling explicitly.
- Uses Colima as the default runtime because it only runs when started.
- Does not start Docker during installation.
- Adds `docker-start` and `docker-stop` aliases for manual runtime control.
- Does not install a Docker UI by default.

Optional Docker UI/runtime choices:

```bash
DOCKER_RUNTIME=colima DOCKER_UI=none ./mcbook.sh apply docker             # default lazy runtime
DOCKER_RUNTIME=orbstack DOCKER_UI=orbstack ./mcbook.sh apply docker       # OrbStack runtime/UI
DOCKER_UI=docker-desktop ./mcbook.sh apply docker                         # Docker Desktop UI
DOCKER_RUNTIME=none ./mcbook.sh apply docker                              # CLI/tools only
```

Docker Desktop can add background/login behavior. If you install it, disable “Start Docker Desktop when you sign in” in Docker Desktop settings.

Repeated shell configuration writes were made idempotent where practical.

## Installation and Usage

From the repository root:

```bash
cd /Users/marco/project/repository/mcbook-config
./mcbook.sh validate
./mcbook.sh list
./mcbook.sh apply
```

Apply one module:

```bash
./mcbook.sh apply dock
```

Create a backup only:

```bash
./mcbook.sh backup
./mcbook.sh backup python
```

Restore:

```bash
./mcbook.sh backups
./mcbook.sh restore ~/.mcbook-backups/backup_YYYYMMDD_HHMMSS_all
```

## Evaluation of Optimizations

Good defaults:

- Reducing Dock and window animation delays.
- Enabling Reduce Motion.
- Reducing unnecessary shell config duplication.
- Keeping Homebrew/package ownership clear by module.
- Creating backups automatically before changes.

Use with caution:

- Disabling Handoff, AirDrop, Bonjour, Siri, or location-related features can reduce background activity, but may break expected Apple ecosystem workflows.
- Aggressive `pmset` changes affect wake/sleep behavior and should be validated on the actual machine.
- `sudo sysctl` file descriptor tuning may not persist across reboots unless handled by a supported launch mechanism.

Avoid as general defaults:

- `sudo mdutil -i off /`
- `sudo pmset -a gpuswitch ...` on Apple Silicon
- `sudo sysctl -w vm.swapusage=0`
- Disabling Time Machine for performance unless it is a temporary, deliberate troubleshooting step.

## Troubleshooting

### Settings Not Applied

Restart affected services:

```bash
killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true
```

Or reboot if the setting is only read at login.

### Verify Current Settings

```bash
defaults read com.apple.universalaccess reduceMotion
defaults read com.apple.dock
defaults read NSGlobalDomain
pmset -g
```

### Validate Scripts

```bash
./mcbook.sh validate
```

Expected current result:

```text
Modules: 24/24 found
```

## Monitoring

Check CPU usage:

```bash
top -l 1 -n 5
```

Check memory:

```bash
vm_stat
```

Check power state:

```bash
pmset -g batt
pmset -g custom
```

## Validation Checklist

- `./mcbook.sh help` prints readable help and uses color in an interactive terminal.
- `./mcbook.sh list` shows 24 modules and no missing scripts.
- `./mcbook.sh validate` reports `Modules: 24/24 found`.
- Each module supports `apply`, `backup`, and `restore`.
- No script-local `log()` functions remain outside `lib/logger.sh`.
- `performance`, `pythone`, and `macos/validate.sh` are no longer referenced.
- Unsafe optimization commands are not used as defaults.

## Compatibility

- Compatibility target: macOS 12+
- Best fit: Apple Silicon MacBooks
- Status: production-ready script cleanup, with machine-specific optimizations still worth validating on the target hardware

## Notes

- All main changes are reversible through backups.
- Some macOS defaults are undocumented and can change across macOS versions.
- Prefer module-level application and validation before applying all modules on a new machine.
