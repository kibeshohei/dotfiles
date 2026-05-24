{ pkgs, ... }:

{
  home.username = "kibeshouhei";
  home.homeDirectory = "/Users/kibeshouhei";

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.name = "kibeshohei";
      user.email = "251728327+kibeshohei@users.noreply.github.com";
    };
  };

  programs.zsh = {
    enable = true;

    initContent = ''
      # >>> nvm initialize >>>
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
      # <<< nvm initialize <<<

      # >>> direnv initialize >>>
      eval "$(direnv hook zsh)"
      # <<< direnv initialize <<<
    '';
  };
}
