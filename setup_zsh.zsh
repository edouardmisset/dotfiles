#! /usr/bin/env zsh

echo "\n<<<Starting ZSH Setup >>>\n"

echo "Enter superuser (sudo) password to edit the acceptable shells in /etc/shells"
echo '/usr/local/bin/zsh' | sudo tee -a '/etc/shells'

echo "Enter user password to login change shell"
chsh -s '/usr/local/bin/zsh'
