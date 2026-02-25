#!/bin/sh
#
# Install Splice (work) dependencies.
# To enable on a work machine: touch ~/.splice

if [ -f "$HOME/.splice" ]; then
  echo "~/.splice detected — installing Splice work dependencies..."
  brew bundle install --file="$(dirname "$0")/Brewfile"
else
  echo "Skipping Splice dependencies (no ~/.splice marker found)"
fi
