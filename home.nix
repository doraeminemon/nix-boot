{ config, pkgs, ... }:

{
  home.username = "developer";
  home.homeDirectory = "/home/developer";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    # GUI Tools (Nix versions of your requested IDs)
    chromium
    vscodium
    bruno
    bleachbit
    kitty

    # Modern CLI Replacements
    fastfetch
    eza        # Modern 'ls'
    fzf        # Fuzzy finder
    zoxide     # Modern 'cd'
    bat        # Modern 'cat' with syntax highlighting
    bottom     # Modern 'top' (btm)

    # Development & Utilities
    git
    lazygit
    hw-probe
    mise       # Runtime manager (Node, Go, Deno)
    starship   # Prompt
  ];

  # 1. Kitty Terminal Config
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    settings = {
      shell = "fish";
      font_size = 11;
      copy_on_select = "yes";
      sys-update = "sudo apt update && sudo apt upgrade -y";
    };
  };

  # 2. Fish Shell & Aliases
  programs.fish = {
    enable = true;

    # Modern Aliases for a better workflow
    shellAliases = {
      ls = "eza --icons --group-directories-first";
      ll = "eza -l --icons --git";
      lt = "eza --tree --level=2";
      cd = "z";
      cat = "bat";
      top = "btm";
      lg = "lazygit";

      edit-nix = "vscodium ~/.config/home-manager/home.nix";
      reload-nix = "home-manager switch";
    };

    interactiveShellInit = ''
      # 1. Initialize Modern Tools
      starship init fish | source
      zoxide init fish | source

      # 2. Initialize Mise (handles Node, Go, Pnpm, Deno)
      mise activate fish | source

      # 3. Auto-install Fisher if missing
      if not functions -q fisher
          echo "Installing Fisher plugin manager..."
          curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
      end
    '';
  };

  # 3. Enable standard helper programs
  programs.starship.enable = true;
  programs.zoxide.enable = true;
  programs.eza.enable = true;
  programs.bat.enable = true;
}