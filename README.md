# dotfiles

Mac 環境を Nix（nix-darwin + home-manager）で宣言的に管理するための dotfiles。

## これは何ができるの？

`darwin-rebuild switch` を 1 回実行するだけで、以下がすべて自動でセットアップされる。

| カテゴリ | 内容 |
|---------|------|
| CLI ツール | gh, ripgrep, neovim, direnv |
| シェル | zsh の設定 + nvm 初期化 |
| direnv | nix-direnv によるキャッシュ付き。flake プロジェクトへの `cd` が一瞬 |
| Git | user.name + noreply email の設定 |
| Neovim 設定 | `dotfiles/nvim/` を `~/.config/nvim` にリンク |
| WezTerm 設定 | `dotfiles/wezterm/` を `~/.config/wezterm` にリンク（LEADER=Ctrl+q 等） |
| GUI アプリ（brew cask） | Raycast, Visual Studio Code, WezTerm Nightly |
| brew formula | nvm, postgresql@17 |
| macOS 設定 | Touch ID で sudo |

## 前提

- macOS（Apple Silicon）
- [Determinate Nix](https://docs.determinate.systems/) インストール済み

## セットアップ（新しい Mac）

```sh
# 1. クローン
git clone https://github.com/kibeshohei/dotfiles ~/dotfiles
cd ~/dotfiles

# 2. nix コマンドが見つからない場合
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# 3. nix-darwin を初回適用（パスワード入力あり）
sudo nix run nix-darwin -- switch --flake ".#kibeshouheinoMacBook-Air-2"
```

途中で質問されたら:
- `/etc/nix/nix.conf` を nix-darwin に任せるか → **Yes**
- `/etc/shells` の上書き → **Yes**

## 設定変更後の適用

```sh
darwin-rebuild switch --flake ~/dotfiles#kibeshouheinoMacBook-Air-2
```

## 構成

```
dotfiles/
├── flake.nix              # エントリーポイント（nixpkgs + home-manager + nix-darwin）
├── flake.lock             # バージョン固定
├── darwin/
│   └── default.nix        # nix-darwin 設定（brew 管理, Touch ID sudo 等）
├── home/
│   ├── default.nix        # home-manager 設定の集約（imports）
│   ├── packages.nix       # CLI ツール（gh, ripgrep）
│   ├── neovim.nix         # Neovim 本体 + 設定 symlink
│   ├── wezterm.nix        # WezTerm 設定 symlink
│   ├── git.nix            # Git identity
│   └── zsh.nix            # Zsh + direnv / nix-direnv
├── nvim/                  # Neovim 設定（Lua）→ ~/.config/nvim にリンク
└── wezterm/               # WezTerm 設定（Lua）→ ~/.config/wezterm にリンク
```

## 新しいツールを追加する方法

| やりたいこと | 手順 |
|------------|------|
| CLI ツールを追加 | `home/packages.nix` の `home.packages` にパッケージ名を追加 |
| 設定付きツールを追加 | `home/<name>.nix` を作成し、`home/default.nix` の `imports` に追加 |
| 設定ファイルを管理 | `dotfiles/<name>/` にファイルを置き、`mkOutOfStoreSymlink` でリンク |
| GUI アプリを追加 | `darwin/default.nix` の `homebrew.casks` に追加 |
| brew formula を追加 | `darwin/default.nix` の `homebrew.brews` に追加 |

いずれも `darwin-rebuild switch` で適用。

## ロールバック

```sh
# darwin 世代の一覧
darwin-rebuild --list-generations

# home-manager 世代の一覧
home-manager generations

# 戻したい世代の activate を実行
/nix/store/...-home-manager-generation/activate
```
