#! /usr/bin/env zsh

echo "\n<<<Starting Node Setup >>>\n"

if command -v node >/dev/null 2>&1; then
  echo "Node is installed: $(node --version) & npm $(npm --version) already are installed"
else
  echo "Installing Node"
  n latest
  n lts
fi

echo "Global NPM Packages Installed: "
npm list --global --depth=0