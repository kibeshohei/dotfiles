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

2回目以降（設定変更後）:

```sh
home-manager switch --flake .#kibeshouhei
```

## 構成

```
dotfiles/
├── flake.nix              # エントリーポイント（nixpkgs + home-manager の入力定義）
├── flake.lock             # nixpkgs / home-manager のバージョン固定
├── home/
│   ├── default.nix        # home-manager 設定の集約（imports）
│   ├── packages.nix       # CLI ツール（gh, ripgrep）
│   ├── neovim.nix         # Neovim 本体 + 設定 symlink
│   ├── wezterm.nix        # WezTerm 設定 symlink
│   ├── git.nix            # Git identity
│   └── zsh.nix            # Zsh + direnv / nix-direnv
├── nvim/                  # Neovim 設定（Lua）— mkOutOfStoreSymlink で ~/.config/nvim にリンク
└── wezterm/               # WezTerm 設定（Lua）— mkOutOfStoreSymlink で ~/.config/wezterm にリンク
```

## Nix 管理外のもの（brew に残留）

| ツール     | 理由 |
|-----------|------|
| nvm       | Nix と相性が悪い（動的 PATH 書き換え）。flake devShell 化で段階的に不要になる |
| postgresql | データを持つサービス。brew services の launchd 連携が便利 |

## ロールバック

直前の世代に戻す:

```sh
home-manager generations        # 世代一覧を確認
# 出力例: 2024-05-24 ... id 5 -> /nix/store/...-home-manager-generation
/nix/store/...-home-manager-generation/activate   # 戻したい世代の activate を実行
```

## 新しいツールを追加する方法

1. **CLI ツール**: `home/packages.nix` の `home.packages` にパッケージ名を追加
2. **programs.* で設定可能なツール**: 専用の `home/<name>.nix` を作成し、`home/default.nix` の `imports` に追加
3. **設定ファイルを dotfiles 管理したいツール**: `dotfiles/<name>/` にファイルを置き、`mkOutOfStoreSymlink` で `xdg.configFile` にリンク（nvim / wezterm と同じパターン）

いずれも `home-manager switch --flake .#kibeshouhei` で適用。
