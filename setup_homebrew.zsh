#! /usr/bin/env zsh

echo "\n<<<Starting Homebrew Setup >>>\n"

if command -v brew >/dev/null 2>&1; then
  echo "brew is installed, skipping install \n"
else
  echo "brew doesn't exist, installing \n"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew bundle --verbose
