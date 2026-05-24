{
  description = "kibeshouhei dotfiles (Nix-managed environment)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }:
    let
      system = "aarch64-darwin";
    in {
      darwinConfigurations."kibeshouheinoMacBook-Air-2" = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./darwin/default.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kibeshouhei = import ./home/default.nix;
          }
        ];
      };
    };
}
