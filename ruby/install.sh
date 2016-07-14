#!/bin/sh

if test ! $(which rbenv)
then
  echo "  Installing rbenv for you."
  brew install rbenv > /tmp/rbenv-install.log
  
  # Install rbenv-aliases: https://github.com/tpope/rbenv-aliases
  # Auto detects ruby version from .ruby-version and Gemfile files

  mkdir -p "$(rbenv root)/plugins"
  git clone git://github.com/tpope/rbenv-aliases.git "$(rbenv root)/plugins/rbenv-aliases"
  rbenv alias --auto
fi

if test ! $(which ruby-build)
then
  echo "  Installing ruby-build for you."
  brew install ruby-build > /tmp/ruby-build-install.log
fi
