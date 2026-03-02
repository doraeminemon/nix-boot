#!/bin/bash
echo "$HOME/.nix-profile/bin/fish" | sudo tee -a /etc/shells
sudo chsh -s "$HOME/.nix-profile/bin/fish" $USER