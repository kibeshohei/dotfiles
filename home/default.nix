{ pkgs, config, ... }:

{
  home.username = "kibeshouhei";
  home.homeDirectory = "/Users/kibeshouhei";

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    gh
    ripgrep
    neovim
  ];

  # nvim 設定は dotfiles リポジトリ直下を直接参照（lazy.nvim が lazy-lock.json を更新できるよう書き込み可能にする）
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";

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
