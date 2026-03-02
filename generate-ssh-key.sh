#!/bin/bash

# Define key file path and an optional comment (e.g., email)
KEY_PATH="$HOME/.ssh/id_rsa"
KEY_COMMENT="your_email@example.com"

# 1. Ensure the .ssh directory exists
mkdir -p ~/.ssh/

# 2. Generate an RSA SSH key non-interactively if it doesn't exist
if [[ ! -f "$KEY_PATH" ]]; then
    echo "Generating new RSA SSH key..."
    # -t rsa: specify key type RSA
    # -b 4096: specify key size of 4096 bits (recommended)
    # -f $KEY_PATH: specify output file path
    # -q: silence ssh-keygen prompts
    # -N "": set an empty passphrase
    # -C "$KEY_COMMENT": add a comment
    ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -q -N "" -C "$KEY_COMMENT"
    chmod 600 "$KEY_PATH" # Set secure permissions for the private key
    echo "SSH key generated successfully at $KEY_PATH"
else
    echo "SSH key already exists at $KEY_PATH. Skipping generation."
fi

# 3. Start the ssh-agent if not already running
# The 'eval $(ssh-agent -s)' command sets necessary environment variables in the current shell
if ! ps -ef | grep "[s]sh-agent" &>/dev/null; then
    echo "Starting SSH Agent..."
    eval "$(ssh-agent -s)"
fi

# 4. Add the key to the ssh-agent
if ! ssh-add -l &>/dev/null || ! ssh-add -l | grep -q "$(ssh-keygen -lf "$KEY_PATH.pub" | awk '{print $2}')"; then
    echo "Adding SSH key to the agent..."
    # ssh-add without arguments adds default keys from ~/.ssh
    ssh-add "$KEY_PATH"
    echo "Key added to ssh-agent."
else
    echo "Key already added to ssh-agent."
fi

# Verification
echo "Current keys in ssh-agent:"
ssh-add -l
