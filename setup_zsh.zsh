#! /usr/bin/env zsh

echo "\n<<<Starting ZSH Setup >>>\n"

# Resolve the Homebrew zsh path (works on both Apple Silicon and Intel).
if command -v brew >/dev/null 2>&1; then
  BREW_ZSH="$(brew --prefix)/bin/zsh"
elif [[ -x /opt/homebrew/bin/zsh ]]; then
  BREW_ZSH="/opt/homebrew/bin/zsh"
elif [[ -x /usr/local/bin/zsh ]]; then
  BREW_ZSH="/usr/local/bin/zsh"
else
  echo "Homebrew zsh not found. Install zsh first (e.g. brew install zsh)." >&2
  exit 1
fi

if [[ ! -x "$BREW_ZSH" ]]; then
  echo "Resolved zsh is not executable: $BREW_ZSH" >&2
  exit 1
fi

if grep -Fxq "$BREW_ZSH" '/etc/shells'; then
  echo "$BREW_ZSH already exists in /etc/shells"
else
  echo "Enter superuser (sudo) password to edit the acceptable shells in /etc/shells"
  echo "$BREW_ZSH" | sudo tee -a /etc/shells >/dev/null
fi

if [ "$SHELL" = "$BREW_ZSH" ]; then
  echo "\$SHELL is already $BREW_ZSH"
else
  echo "Enter user password to login change shell (from $SHELL to $BREW_ZSH)"
  chsh -s "$BREW_ZSH"
fi

if sh --version | grep -q zsh; then
  echo '/private/var/select/sh already linked to /bin/zsh'
else
  echo "Enter superuser (sudo) password to symlink sh to zsh as the default non-interactive shell"
  sudo ln -sfv /bin/zsh /private/var/select/sh
fi
