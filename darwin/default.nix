{ pkgs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  system.primaryUser = "kibeshouhei";

  users.users.kibeshouhei = {
    name = "kibeshouhei";
    home = "/Users/kibeshouhei";
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.stateVersion = 6;

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    casks = [
      "raycast"
      "visual-studio-code"
      "wezterm@nightly"
    ];
    brews = [
      "nvm"
      "postgresql@17"
    ];
  };
}
