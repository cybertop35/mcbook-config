#!/usr/bin/env bash


set -e


echo "Updating system"


brew update

brew upgrade

brew cleanup
brew cleanup --prune=all -s
brew autoremove 


softwareupdate --list


echo "Update completed"