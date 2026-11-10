# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A topic-based dotfiles repo for macOS. Each subdirectory is a "topic" (e.g. `git/`, `node/`, `mise/`) that groups related config, PATH setup, aliases, and install scripts together. There are no build steps, tests, or linters.

## Setup scripts

- `script/bootstrap` — one-time setup: creates symlinks, configures git, installs Homebrew and runs `bin/dot`
- `script/install` — runs `brew bundle install` first (ensuring Brewfile packages are available), then finds and runs all `install.sh` scripts across every topic directory
- `bin/dot` — meant to be run periodically; runs `osx/set-defaults.sh`, installs/updates Homebrew, then runs `brew bundle install`

## How the shell loads files

`zsh/zshrc.symlink` (symlinked to `~/.zshrc`) loads all `*.zsh` files from topic directories in this order:

1. `path.zsh` files — loaded first, for `$PATH` setup
2. All other `*.zsh` files — aliases, config, etc.
3. `completion.zsh` files — loaded last, after `compinit`

Files named `_path.zsh` (e.g. `system/_path.zsh`) do NOT load in the path phase — they load in phase 2 with everything else.

`homebrew/path.zsh` loads first among path files (alphabetically) and evals `brew shellenv`, making Homebrew available before other tools that depend on it.

## File naming conventions

| File | Purpose |
|---|---|
| `topic/path.zsh` | `$PATH` modifications, loaded first |
| `topic/*.zsh` | Aliases, config, env vars |
| `topic/completion.zsh` | Tab completion, loaded last |
| `topic/*.symlink` | Symlinked into `$HOME` as `.<filename>` during bootstrap |
| `topic/install.sh` | Run by `script/install` to install tools |

## Key conventions

- **Symlinked files**: `git/gitconfig.symlink` → `~/.gitconfig`, `git/gitignore.symlink` → `~/.gitignore`, `zsh/zshrc.symlink` → `~/.zshrc`
- **Private/local config**: goes in `~/.localrc`, which is sourced automatically if it exists and is never committed
- **Work machine**: create `~/.splitwise` before running `script/install` to trigger `splitwise/install.sh`, which installs work-specific packages from `splitwise/Brewfile`. `splice/` follows the same pattern (`~/.splice`) for a previous employer and is kept as a template
- **Ruby version management**: `splitwise/rbenv.zsh` runs `rbenv init` when rbenv is installed (Splitwise onboarding installs it); Mise remains the preferred manager and is activated in `mise/path.zsh`. Never hardcode tool paths like `~/.local/bin/mise` in `zshrc.symlink` — topic files load after `homebrew/path.zsh`, so Homebrew-installed tools are already on `$PATH`
- **Runtime versions**: managed by Mise (`mise/path.zsh`); individual language version managers (nvm, pyenv, etc.) are not used
- **Homebrew packages**: add to `Brewfile` for personal tools, `splitwise/Brewfile` for work-only tools
- **`bin/` scripts**: automatically on `$PATH` via `system/_path.zsh`; includes git helper scripts (`git-wtf`, `git-nuke`, `git-undo`, etc.)

## Adding a new topic

Create a directory and add only the files needed — none are required:
- `mytopic/install.sh` — install the tool
- `mytopic/path.zsh` — PATH additions
- `mytopic/aliases.zsh` — shell aliases
- `mytopic/completion.zsh` — tab completion
