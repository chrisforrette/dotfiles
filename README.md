# Chris Forrette's dotfiles

A topic-based, portable development environment for macOS. Clone it, run two scripts, and a new machine is ready to work.

---

## Getting started on a fresh machine

### Prerequisites

On a brand new Mac, Xcode Command Line Tools must be installed before anything else — git won't work without them:

```sh
xcode-select --install
```

### 1. Clone the repo

```sh
git clone https://github.com/chrisforrette/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Bootstrap

Bootstrap handles the one-time setup: configuring git, symlinking dotfiles into `$HOME`, installing Homebrew, and installing everything in the Brewfile.

```sh
script/bootstrap
```

You'll be prompted for your git author name and email if `git/gitconfig.symlink` doesn't exist yet.

### 3. Install

Install runs all `install.sh` scripts across every topic directory — language runtimes, tools, and other per-topic setup.

```sh
script/install
```

### 4. Work machine setup (optional)

If this is a Splice work machine, create the marker file before running `script/install`:

```sh
touch ~/.splice
```

This causes `splice/install.sh` to install work-specific dependencies (kubectl, saml2aws, ansible, packer, Tailscale, etc.) from `splice/Brewfile`. Without the marker, that step is silently skipped.

### 5. Restart your shell

```sh
exec zsh
```

---

## How-to guides

### Add a new technology or tool

Create a directory for the topic and add any combination of the following files:

```sh
mkdir ~/.dotfiles/mytool
```

- `mytool/install.sh` — installs the tool (run by `script/install`)
- `mytool/path.zsh` — adds to `$PATH`, loaded first on shell startup
- `mytool/aliases.zsh` — shell aliases, loaded on shell startup
- `mytool/completion.zsh` — tab completion, loaded last on shell startup
- `mytool/config.zsh` — any other shell configuration

Only create the files you need — none are required.

To install a Homebrew package, add it to `Brewfile` instead and run `brew bundle install`.

### Remove a technology or tool

1. Delete the topic directory: `rm -rf ~/.dotfiles/mytool`
2. If it has a Brewfile entry, remove it and run `brew bundle install`
3. If it had a `.symlink` file, remove the symlink from `$HOME`: `rm ~/.<filename>`

### Add a runtime version (Node, Python, Go, etc.)

Runtimes are managed by [Mise](https://mise.jdx.dev). To install a runtime globally:

```sh
mise use -g node@22
mise use -g python@3.12
mise use -g go@1.22
```

To pin a version for a specific project, run the same command from inside the project directory (without `-g`). Mise will create a `.mise.toml` file in the project root.

### Add machine-local configuration

Anything that shouldn't be committed to the repo — API keys, private aliases, machine-specific paths — goes in `~/.localrc`. This file is sourced automatically if it exists and is not tracked by git.

```sh
# ~/.localrc
export SECRET_API_KEY="..."
alias work="cd ~/Code/work-project"
```

### Keep dotfiles in sync

Pull the latest changes and re-run install:

```sh
cd ~/.dotfiles
git pull
script/install
```

For Homebrew packages specifically:

```sh
brew bundle install
```

### Add a new employer's machine profile

The `splice/` directory is a template for employer-specific tooling. To add a new employer:

1. Create a new directory: `mkdir ~/.dotfiles/<employer>`
2. Add a `<employer>/Brewfile` with employer-specific packages
3. Add a `<employer>/install.sh` that checks for a marker file:

```sh
#!/bin/sh
if [ -f "$HOME/.<employer>" ]; then
  echo ".<employer> detected — installing dependencies..."
  brew bundle install --file="$(dirname "$0")/Brewfile"
else
  echo "Skipping <employer> dependencies (no ~/.<employer> marker found)"
fi
```

4. On employer machines, `touch ~/.<employer>` before running `script/install`

---

## Reference

### Directory structure

```
~/.dotfiles/
├── bin/                    # Scripts added to $PATH automatically
├── claude/                 # Claude CLI setup
├── functions/              # Zsh functions (autoloaded)
├── git/                    # Git config, aliases, and completion
├── go/                     # Go environment (GOPATH)
├── homebrew/               # Homebrew install and PATH setup
├── mise/                   # Mise runtime manager
├── node/                   # Node local bin PATH
├── osx/                    # macOS system defaults
├── splice/                 # Splice (work) machine dependencies
├── system/                 # Core aliases, environment, and PATH
├── terraform/              # Terraform/OpenTofu version switcher
├── zsh/                    # Zsh config, prompt, and aliases
├── Brewfile                # Homebrew packages for all machines
├── script/bootstrap        # One-time machine setup
└── script/install          # Runs all install.sh scripts
```

### File naming conventions

| Filename | When it's loaded | Purpose |
|---|---|---|
| `path.zsh` | First, on every shell startup | `$PATH` modifications |
| `*.zsh` | Second, on every shell startup | Aliases, config, functions |
| `completion.zsh` | Last, on every shell startup | Tab completion setup |
| `*.symlink` | Once, during `script/bootstrap` | Symlinked into `$HOME` as `.<filename>` |
| `install.sh` | Once, during `script/install` | Tool installation |

### Symlinked files

| Source | Symlinked to |
|---|---|
| `git/gitconfig.symlink` | `~/.gitconfig` |
| `git/gitignore.symlink` | `~/.gitignore` |
| `zsh/zshrc.symlink` | `~/.zshrc` |

### bin/ scripts

Scripts in `bin/` are added to `$PATH` and available everywhere:

| Script | Description |
|---|---|
| `dot` | Re-runs macOS defaults and Homebrew setup; run occasionally to stay current |
| `e` | Open a file or directory in `$EDITOR` |
| `git-wtf` | Shows the state of all branches relative to their upstreams |
| `git-promote` | Push the current branch and set up remote tracking |
| `git-nuke` | Delete a branch locally and remotely |
| `git-undo` | Soft reset the last commit |
| `git-unpushed` | Show a diff of all unpushed commits |
| `git-delete-local-merged` | Delete all local branches already merged into main |
| `headers` | Print HTTP response headers for a URL |
| `todo` | Create an empty todo file on the Desktop |

### Machine profiles

| Marker file | Profile | Installs |
|---|---|---|
| *(none)* | Personal | Everything in `Brewfile` |
| `~/.splice` | Splice (work) | + `splice/Brewfile` |

---

## How it works

### Shell startup

On every new shell, `~/.zshrc` (symlinked from `zsh/zshrc.symlink`) does the following in order:

1. Sources `~/.localrc` if it exists (private, machine-local config)
2. Loads all `path.zsh` files across every topic directory
3. Loads all other `.zsh` files across every topic directory
4. Initializes zsh autocompletion
5. Loads all `completion.zsh` files across every topic directory

Path files load first to ensure `$PATH` is fully configured before any other shell code runs. Within path files, `homebrew/path.zsh` initializes Homebrew (and its `$PATH` entries) before other tools that depend on it.

### Bootstrap vs install

`script/bootstrap` is a **one-time setup** script. It creates `~/.gitconfig`, symlinks all `.symlink` files into `$HOME`, and kicks off Homebrew installation.

`script/install` is meant to be **re-run any time**. It runs every `install.sh` across all topic directories. Running it again is safe — most installers are idempotent.

### Runtime management

Language runtimes (Node, Python, Go, etc.) are managed by [Mise](https://mise.jdx.dev), a single tool that replaces nvm, pyenv, rbenv, and similar per-language version managers. Mise is installed via Homebrew and activated in every shell via `mise/path.zsh`.
