{ config, ... }:

{
  # Claude Code のグローバル skills を dotfiles で管理する。
  # ~/.claude は history/projects/sessions などのランタイム状態を持つため
  # ディレクトリ全体ではなく skills だけを out-of-store symlink する。
  # これにより、どの作業ディレクトリからでも dotfiles/.claude/skills が
  # グローバル skill として参照される。
  home.file.".claude/skills".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.claude/skills";
}
