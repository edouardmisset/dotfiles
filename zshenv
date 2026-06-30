# ~/.zshenv — sourced for every shell (login, interactive, scripts).
# Single source of truth for environment variables and PATH, so scripts and
# non-interactive shells get the same environment as interactive ones.

# Helper: returns success (exit 0) if a command exists on PATH.
function exists() {
  command -v "$1" >/dev/null 2>&1
}

# Homebrew (Apple Silicon) — sets PATH, MANPATH, etc.
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Tool homes
export BUN_INSTALL="$HOME/.bun"
export PNPM_HOME="$HOME/.local/share/pnpm"

# PATH (custom dirs first, system PATH in the middle, app bins last).
# `typeset -U path` keeps PATH de-duplicated and idempotent across re-sourcing.
path=(
  "$BUN_INSTALL/bin"
  "$PNPM_HOME"
  "$HOME/.local/bin"
  "$HOME/.local/share/jupyter/runtime"
  "$HOME/Projects/code/scripts/bin"
  $path
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  "$HOME/.lmstudio/bin"
)
typeset -U path

# Extra environments (sourced only when present)
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
[[ -f "$HOME/.vite-plus/env" ]] && source "$HOME/.vite-plus/env" # https://viteplus.dev
