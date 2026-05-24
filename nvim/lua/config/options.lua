-- ===== 基本設定 =====
-- 行番号
vim.opt.number = true
vim.opt.relativenumber = true

-- インデント
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- 表示
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true

-- 検索
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- その他
vim.opt.clipboard = "unnamedplus" -- システムクリップボード連携
vim.opt.mouse = "a"               -- マウス有効化
vim.opt.undofile = true           -- アンドゥ履歴を保存
vim.opt.updatetime = 250          -- 反応速度向上
vim.opt.timeoutlen = 300
