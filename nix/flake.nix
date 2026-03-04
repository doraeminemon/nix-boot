{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:youwen5/zen-browser-flake";
  };

  outputs = { nixpkgs, home-manager, zen-browser, ... }@inputs: {
    homeConfigurations."developer" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux; # Adjust for your arch
      extraSpecialArgs = { inherit inputs; }; # This line is crucial
      modules = [ ./home.nix ];
    };
  };
}