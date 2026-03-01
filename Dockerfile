# Use a slim Ubuntu base
FROM ubuntu:24.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for Nix and Home Manager
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    xz-utils \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user (Nix prefers this for Home Manager)
RUN useradd -ms /bin/bash developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER developer
ENV USER=developer
ENV HOME=/home/developer
WORKDIR /home/developer

# Install Nix in single-user mode
RUN curl -L https://nixos.org/nix/install | sh -s -- --no-daemon

# Source nix profile for the current shell session
ENV PATH="/home/developer/.nix-profile/bin:/home/developer/.nix-defexpr/channels/nixpkgs/bin:$PATH"
ENV NIX_PATH="nixpkgs=/home/developer/.nix-defexpr/channels/nixpkgs"

# Add Home Manager channel and install it
RUN nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager && \
    nix-channel --update && \
    nix-shell '<home-manager>' -A install

# Optional: Initialize a basic home.nix
# 1. Ensure the config directory exists
RUN mkdir -p /home/developer/.config/home-manager

# 2. Copy your local home.nix into the image
# (Assumes home.nix is in the same folder as your Dockerfile)
COPY --chown=developer:developer home.nix /home/developer/.config/home-manager/home.nix

# Run home-manager switch to apply the config
RUN home-manager switch

CMD ["/bin/bash"]