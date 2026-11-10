#!/bin/sh
#
# Install Splitwise (work) dependencies.
# To enable on a work machine: touch ~/.splitwise

if [ -f "$HOME/.splitwise" ]; then
  echo "~/.splitwise detected — installing Splitwise work dependencies..."
  brew bundle install --file="$(dirname "$0")/Brewfile"
else
  echo "Skipping Splitwise dependencies (no ~/.splitwise marker found)"
fi
