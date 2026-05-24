  # dotfiles 次の改善候補

  現状の dotfiles（home-manager 経由で管理されているもの）:
  - zsh（nvm + direnv hook）
  - git identity
  - gh / ripgrep / neovim
  - nvim 設定（~/dotfiles/nvim/）

  以下は「これを次にやると価値が高い」候補を、効果と労力で並べたもの。

  ---

  ## A. 今すぐやる価値あり

  ### A-1. WezTerm 設定を dotfiles 化（推奨: 最初にやる）

  - **対象**: `~/.config/wezterm/wezterm.lua` と `~/.config/wezterm/keybinds.lua`
  - **やること**: nvim と同じ `mkOutOfStoreSymlink` パターンで dotfiles 配下に移動 → `xdg.configFile."wezterm".source` で参照
  - **理由**:
    - 現在のターミナル設定（LEADER キー = Ctrl+q、ペイン操作など）が再現不可能になっている
    - 新マシンで `wezterm@nightly` を brew cask で入れても、設定が無いと素のキーバインドに戻ってしまう
    - nvim 移行のパターンが流用できるので作業 15 分程度
  - **想定変更**: `home/default.nix` に 1 行追加 + ファイルコピー
  - **リスク**: 低（mkOutOfStoreSymlink は実証済み）

  ### A-2. direnv を home.packages へ移行

  - **対象**: 現在 brew leaves に残っている `direnv`
  - **やること**:
    1. `home.packages` に `direnv` 追加
    2. `home-manager switch`
    3. `brew uninstall direnv`
  - **理由**:
    - brew leaves が 3 → 2 件（nvm / postgresql のみ）になる
    - PATH 優先度を考えると Nix 経由が筋
  - **作業時間**: 5 分
  - **リスク**: 低（gh/ripgrep の前例あり）

  ### A-3. nix-direnv の導入

  - **やること**: `programs.direnv.enable = true` + `nix-direnv.enable = true` を home-manager で宣言
  - **理由**:
    - `cd` 時に毎回走っている `nix print-dev-env` がキャッシュされる
    - my-blog 等 flake プロジェクトの `cd` が体感で速くなる（数百ms → 即時）
    - PLAN.md の Step 3-A 残課題に明記済み
  - **作業時間**: 15 分
  - **リスク**: 低（home-manager に組み込まれている標準機能）
  - **A-2 とセットでやると効率的**（direnv の brew uninstall も同時に）

  ---

  ## B. 余裕があれば（中期）

  ### B-1. home/default.nix の分割

  - **やること**: ファイルが 40 行を超えてきたので、責務ごとに分割
    home/
    ├── default.nix    # エントリ（import で集約）
    ├── zsh.nix
    ├── git.nix
    ├── neovim.nix
    ├── wezterm.nix
    └── packages.nix
  - **理由**:
  - PLAN.md D-005 で想定した構成に近づく
  - Step 4（nix-darwin）以降で複雑化する前に整理しておくと楽
  - **作業時間**: 20 分
  - **リスク**: 中（Nix の import 構文ミスで詰まる可能性、要動作確認）

  ### B-2. shellAliases を宣言的に

  - **やること**: `programs.zsh.shellAliases = { gs = "git status"; ll = "ls -la"; ... };`
  - **理由**: 普段ターミナルで叩いてる alias を Nix 管理に
  - **前提**: 「どの alias を入れるか」のリストアップが必要（→ ユーザーに聞く必要あり）
  - **作業時間**: 5 分（リストが揃っていれば）

  ### B-3. README の充実

  - **やること**: 現在は前提・clone・switch のみ。以下を追記:
  - 構成図（どのファイルが何をしているか）
  - ロールバック手順（home-manager generations の使い方）
  - 新ツールを追加する時のフロー
  - **理由**: 他人だけでなく **未来の自分** が忘れた時の救済
  - **作業時間**: 30 分

  ---

  ## C. Step 4 の準備として

  ### C-1. flake.nix を nix-darwin 対応構造へ

  - **やること**: 現在 `homeConfigurations.kibeshouhei` 1 つだけ → `darwinConfigurations.<host>` も追加する余地を作る
  ```nix
  outputs = { ... }: {
    homeConfigurations."kibeshouhei" = ...;
    darwinConfigurations."<hostname>" = ...;  # Step 4 で追加
  };
  - 理由: Step 4 着手時に flake 構造を一気に変えるとリスクが上がるため、骨組みだけ先に作る
  - 作業時間: Step 4 と一体化できるので単独では不要

  ---
  D. 雑務（小さいけど忘れがち）

  D-1. ~/.config/nvim.backup を削除

  - Step 3-D で退避させた旧 nvim 設定。問題なく動作確認できているので不要
  - rm -rf ~/.config/nvim.backup 1 行

  D-2. ~/.zshrc.backup の扱い

  - Step 3-A で生成された退避ファイル。home-manager 化が安定したので削除可能
  - rm ~/.zshrc.backup

  ---
  おすすめ実行順

  1. A-2 + A-3 をまとめて（direnv + nix-direnv、20 分、brew leaves 削減 + 体感速度向上）
  2. A-1 WezTerm 移行（15 分、設定の再現性が完成）
  3. D-1, D-2 バックアップ削除（1 分）
  4. B-1 ファイル分割（20 分、見通し改善）
  5. ここまでで dotfiles の「ユーザー領域 100%」が達成、Step 4 へ進む準備が整う

  ---
  ## 完了済み

  ### A-2 + A-3: direnv + nix-direnv（2026-05-24 完了）

  - `programs.direnv = { enable = true; nix-direnv.enable = true; }` を追加
  - 手動の `eval "$(direnv hook zsh)"` を削除（home-manager が自動注入）
  - `brew uninstall direnv` で brew 版を削除可能に
  - 結果: brew leaves が nvm + postgresql の 2 つに減少、flake プロジェクトへの cd が 2 回目以降キャッシュヒットで高速化

  ---
  ## brew に残すもの（移行しない判断）

  - **nvm**: Nix と相性が悪い（動的 PATH 書き換え）。flake devShell 化が進めば自然に不要になる。Nix 化の対象外
  - **postgresql**: データを持つサービス。brew services の launchd 連携が便利。nix-darwin（Step 4）まで触らない

  ---
  「やらない方がいいもの」（参考）

  - VSCode 設定の Nix 化: settings.json は Nix で書くと辛い。VSCode の Settings Sync を使うのが筋
  - GitHub Actions で dotfiles をビルド検証: 個人 dotfiles では過剰、本人が home-manager switch で気づく
  - gpg / ssh 設定の Nix 化: 秘密情報を扱うので慎重に。今は brew/system のまま
