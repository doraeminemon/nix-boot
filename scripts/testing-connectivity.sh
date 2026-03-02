#!/bin/bash

# Define the list of critical Nix and development endpoints
ENDPOINTS=(
  "https://cache.nixos.org"
  "https://nixos.org"
  "https://channels.nixos.org"
  "https://releases.nixos.org"
  "https://install.determinate.systems"
  "https://github.com"
  "https://raw.githubusercontent.com"
  "https://tarballs.nixos.org"
  "https://nodejs.org"
  "https://proxy.golang.org"
  "https://deno.land"
)

echo "🔍 Testing connectivity to Nix infrastructure..."
echo "------------------------------------------------"

for url in "${ENDPOINTS[@]}"; do
    # Try to connect with a 5-second timeout
    if curl -s --head --request GET "$url" --connect-timeout 5 > /dev/null; then
        echo "✅ OK: $url"
    else
        echo "❌ BLOCKED: $url"
    fi
done

echo "------------------------------------------------"
echo "If any are BLOCKED, please provide this list to your IT team."