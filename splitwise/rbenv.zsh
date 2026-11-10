# Splitwise onboarding installs rbenv for Ruby version management. Mise is the
# preferred tool (see mise/), but rbenv is kept active so projects pinned via
# rbenv keep working. No-op on machines without rbenv installed.
if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init - zsh)"
fi
