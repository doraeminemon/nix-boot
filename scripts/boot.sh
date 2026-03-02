#!/bin/bash
sudo apt update
sudo apt-get update && apt-get install -y \
    curl \
    xz-utils \
    git \
    && rm -rf /var/lib/apt/lists/*
# --- Configuration ---
NIX_DIR="$HOME/.nix"

# 1. Install Nix (Determinate Installer handles sudo for you)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 2. Source the new profile immediately
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# 3. Install Home Manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

echo "✅ Nix and Home Manager are ready."
echo "To enter your Nix environment, type: nix-env"