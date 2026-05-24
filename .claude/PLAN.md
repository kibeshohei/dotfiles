# dotfiles 改善プラン

## 現在の状態（2026-05-24 時点）

### Nix で管理されているもの

| カテゴリ | 設定ファイル | 内容 |
|---------|-------------|------|
| zsh | `home/zsh.nix` | シェル + nvm 初期化 |
| direnv + nix-direnv | `home/zsh.nix` | `programs.direnv` で宣言。フック自動注入、flake キャッシュ有効 |
| git | `home/git.nix` | user.name + noreply email |
| CLI ツール | `home/packages.nix` | gh, ripgrep |
| neovim | `home/neovim.nix` | 本体 + `dotfiles/nvim/` を symlink |
| wezterm | `home/wezterm.nix` | `dotfiles/wezterm/` を symlink |
| nix-darwin | `darwin/default.nix` | brew cask/formula 管理、Touch ID sudo（**初回適用待ち**） |

### brew に残すもの（移行しない判断）

- **nvm**: Nix と相性が悪い（動的 PATH 書き換え）。flake devShell 化で段階的に不要になる
- **postgresql@17**: データを持つサービス。brew services の launchd 連携が便利

### やらないもの

- VSCode 設定の Nix 化 → Settings Sync を使う
- GitHub Actions で dotfiles をビルド検証 → 個人 dotfiles では過剰
- gpg / ssh 設定の Nix 化 → 秘密情報を扱うので当面触らない

---

## 完了済み（2026-05-24）

### 1. direnv + nix-direnv 導入（A-2 + A-3）

- `programs.direnv = { enable = true; nix-direnv.enable = true; }` を追加
- 手動の `eval "$(direnv hook zsh)"` を削除
- 効果: flake プロジェクトへの `cd` が 2 回目以降キャッシュヒットで高速化

### 2. WezTerm 設定の dotfiles 化（A-1）

- `wezterm.lua` + `keybinds.lua` を `dotfiles/wezterm/` にコピー
- `mkOutOfStoreSymlink` で `~/.config/wezterm` にリンク
- 効果: ターミナル設定（LEADER=Ctrl+q、ペイン操作等）が新マシンで再現可能に

### 3. バックアップ削除（D-1, D-2）

- `~/.config/nvim.backup`、`~/.zshrc.backup`、`~/.config/wezterm.backup` を削除

### 4. home/default.nix の分割（B-1）

- 1 ファイルだった設定を責務ごとに分割:
  - `default.nix`（imports のみ）
  - `packages.nix` / `neovim.nix` / `wezterm.nix` / `git.nix` / `zsh.nix`
- `home-manager switch` で動作確認済み

### 5. README 充実（B-3）

- 構成図、ロールバック手順、ツール追加フローを追記

### 6. nix-darwin 構造作成（C-1）

- `flake.nix` に `nix-darwin` 入力を追加、`darwinConfigurations` を定義
- `darwin/default.nix` に brew cask/formula + Touch ID sudo を宣言
- home-manager を nix-darwin モジュールとして統合（`darwin-rebuild switch` 一発で全適用）

---

## 次にやること

### 必須: nix-darwin の初回適用

WezTerm などのターミナルを開いて、以下を **上から順に 1 行ずつ** 実行する。

#### Step 1: nix コマンドを使えるようにする

```sh
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

`nix --version` と打って、バージョンが表示されれば OK。
`command not found` のままなら Nix 自体の再インストールが必要。

#### Step 2: nix-darwin を初回適用する

```sh
cd ~/dotfiles
sudo nix run nix-darwin -- switch --flake ".#kibeshouheinoMacBook-Air-2"
```

パスワードを聞かれたら Mac のログインパスワードを入力。

途中で質問されたら:
- `/etc/nix/nix.conf` を nix-darwin に任せるか → **Yes**
- `/etc/shells` の上書き → **Yes**

エラーなく完了すれば成功。

#### Step 3: 後片付け

```sh
brew uninstall direnv
```

direnv は Nix 管理に移行済みなので brew 版を消す。

#### Step 4: 確認

新しいターミナルを開いて以下を実行:

```sh
darwin-rebuild switch --flake ~/dotfiles#kibeshouheinoMacBook-Air-2
```

エラーなく完了すれば、今後はこのコマンド 1 つで全設定が適用される。

### 任意: shellAliases（B-2）

普段使っている alias をリストアップして `home/zsh.nix` に追加。

---

## 適用コマンド早見表

| 状態 | コマンド |
|------|---------|
| nix-darwin 適用前（現在） | `home-manager switch --flake ~/dotfiles#kibeshouhei` |
| nix-darwin 適用後 | `darwin-rebuild switch --flake ~/dotfiles#kibeshouheinoMacBook-Air-2` |
