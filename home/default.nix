{ ... }:

{
  imports = [
    ./packages.nix
    ./neovim.nix
    ./wezterm.nix
    ./git.nix
    ./zsh.nix
    ./zed.nix
  ];

  home.username = "kibeshouhei";
  home.homeDirectory = "/Users/kibeshouhei";

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
