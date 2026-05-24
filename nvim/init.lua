-- ===== Neovim設定 =====
-- モダンなVS Code風のNeovim設定
-- lazy.nvimを使用したプラグイン管理

-- 基本設定を読み込み
require("config.options")
require("config.keymaps")

-- lazy.nvimのセットアップ
require("config.lazy")
