#!/usr/bin/env bash

###############################################################################
# Homebrew setup
###############################################################################

set -euo pipefail


log() {
    printf "[Homebrew] %s\n" "$1"
}


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