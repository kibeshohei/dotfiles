# dotfiles

Mac 環境を Nix（home-manager standalone）で宣言的に管理するための dotfiles。

## 前提

- macOS（Apple Silicon）
- [Determinate Nix](https://docs.determinate.systems/) インストール済み

## 適用方法

```sh
git clone https://github.com/kibeshohei/dotfiles ~/dotfiles
cd ~/dotfiles
nix run home-manager/master -- switch --flake .#kibeshouhei -b backup
```

`-b backup` で既存ファイルは `.backup` 拡張子付きで退避されます。

## 構成

- `flake.nix` — エントリーポイント
- `flake.lock` — nixpkgs / home-manager のバージョン固定
- `home/default.nix` — home-manager 設定（zsh, etc.）
