#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/logger.sh"


log "Checking Homebrew"


if ! command -v brew >/dev/null
then

    log "Installing Homebrew"

    /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

fi


log "Updating Homebrew"

brew update


###############################################################################
# CLI developer tools
###############################################################################

PACKAGES=(

git
gh
wget
curl
jq

ripgrep
fzf
bat
eza
fd
zoxide

python
uv

openjdk
maven
gradle

kubectl
helm
intellij-idea
sublime-text

)

for package in "${PACKAGES[@]}"
do

    if ! brew list "$package" >/dev/null 2>&1
    then
        log "Installing $package"
        brew install "$package"
    fi

done


brew cleanup
brew cleanup --prune=all -s
brew autoremove 


log "Homebrew setup completed"