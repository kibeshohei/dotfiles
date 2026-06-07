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
- Determinate Nix との衝突を `nix.enable = false` で回避
- `system.primaryUser` を追加（nix-darwin 最新版で必須）

### 7. PR 作成・マージ・ブランチ削除（2026-05-25）

- ブランチ `feat/direnv-nix-direnv` で PR を作成し、main にマージ
- ローカル・リモートともにブランチを削除済み

### 8. nix-darwin 初回適用（2026-05-25 完了）

- ターミナルから `sudo nix run nix-darwin -- switch` を実行し、適用済み

### 9. Zed エディタの dotfiles 化（2026-06-07）

- `home/zed.nix` を追加し、`dotfiles/zed/` を `~/.config/zed` に `mkOutOfStoreSymlink`
- コミット `19feb41`

### 10. Anthropic 公式 skills の取り込み（2026-06-07）

- 公式の汎用 skill 17 個を `.claude/skills/` に追加（algorithmic-art, canvas-design, docx, pdf, pptx, xlsx ほか）
- `.claude/README.md` / `THIRD_PARTY_NOTICES.md` / `marketplace.json` も同梱
- コミット `209f2f2`

### 11. Claude skills のグローバル参照化（2026-06-08）

- 課題: `.claude/skills` は dotfiles リポジトリ内でしか効かず、`~/.claude/skills` には別物（個人 skill）が実体で存在していた
- 個人 skill 8 個（career-flow 等の転職活動系・各 SKILL.md 1 枚）を削除。削除前に `~/.claude/backups/personal-skills-20260607-233610.tar.gz` へバックアップ
- `home/claude.nix` を追加し、`dotfiles/.claude/skills` を `~/.claude/skills` へ `mkOutOfStoreSymlink`
- これで作業ディレクトリを問わず Anthropic skills がグローバル参照される（skill の編集は rebuild 不要・即反映、新規 skill 追加時のみ rebuild）
- `home/default.nix` の imports に `./claude.nix` を追加し `sudo darwin-rebuild switch` で適用・検証済み
- コミット `da0c83a`

---

## 次にやること

### 任意: shellAliases（B-2）

普段使っている alias をリストアップして `home/zsh.nix` に追加。

### 任意: zed/prompts/ を .gitignore

Zed の Prompt Library DB（LMDB バイナリ）が未追跡で残っている。差分管理に不向きなので
ルートの `.gitignore` に `zed/prompts/` を追加して git status を整える。

### 任意: 個人 skill の置き直し

転職活動系 skill を今後も使うなら、バックアップ tarball から `dotfiles/.claude/skills/`
配下へ復元すれば、項目 11 の仕組みでグローバル管理される。

---

## 適用コマンド早見表

```sh
darwin-rebuild switch --flake ~/dotfiles#kibeshouheinoMacBook-Air-2
```
