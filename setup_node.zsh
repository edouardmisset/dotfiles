#! /usr/bin/env zsh

echo "\n<<<Starting Node Setup >>>\n"

if exists node; then
  echo "Node $(node --version) & npm $(npm --version) already are installed"
else
  echo "Installing Node"
  n latest
  n lts
fi

# Install Global NPM PAckages
npm install --global yarn
npm install --global typescript

echo "Global NPM Packages Installed: "
npm list --global --depth=0