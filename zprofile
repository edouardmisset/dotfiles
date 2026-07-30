# Runs after macOS /etc/zprofile has rebuilt PATH.
eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -f "$HOME/.vite-plus/env" ]] && source "$HOME/.vite-plus/env"
