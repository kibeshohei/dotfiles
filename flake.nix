{
  description = "kibeshouhei dotfiles (Nix-managed environment)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."kibeshouhei" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home/default.nix ];
      };
    };
}
