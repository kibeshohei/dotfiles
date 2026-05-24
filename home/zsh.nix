{ ... }:

{
  programs.zsh = {
    enable = true;

    initContent = ''
      # >>> nvm initialize >>>
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
      # <<< nvm initialize <<<

    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
