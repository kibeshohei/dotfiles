{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gh
    ripgrep
    zed-editor
  ];
}
