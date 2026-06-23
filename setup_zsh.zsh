#! /usr/bin/env zsh

echo "\n<<<Starting ZSH Setup >>>\n"

# Resolve the Homebrew zsh path (works on both Apple Silicon and Intel).
if exists brew; then
  BREW_ZSH="$(brew --prefix)/bin/zsh"
else
  BREW_ZSH="/usr/local/bin/zsh"
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
