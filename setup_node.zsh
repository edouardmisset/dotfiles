#! /usr/bin/env zsh

echo "\n<<<Starting Node Setup >>>\n"

if exists node; then
  echo "Node $(node --version) & npm $(npm --version) already are installed"
else
  echo "Installing Node"
  n latest
  n lts
fi
