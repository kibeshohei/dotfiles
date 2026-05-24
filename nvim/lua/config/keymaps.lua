-- ===== リーダーキー =====
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ===== 基本的なキーマップ =====
-- 保存
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "保存" })

-- 終了
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "終了" })
vim.keymap.set("n", "<leader>Q", ":q!<CR>", { desc = "強制終了" })

-- ノーマルモードへ
vim.keymap.set("i", "jk", "<Esc>", { desc = "ノーマルモードへ" })

-- ウィンドウ移動 (VS Code風)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "左のウィンドウへ" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "下のウィンドウへ" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "上のウィンドウへ" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "右のウィンドウへ" })

-- バッファ移動
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "次のバッファ" })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "前のバッファ" })

-- インデント調整（ビジュアルモードで選択を維持）
vim.keymap.set("v", "<", "<gv", { desc = "インデント減" })
vim.keymap.set("v", ">", ">gv", { desc = "インデント増" })

-- 行移動（ビジュアルモード）
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "選択行を下へ" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "選択行を上へ" })

-- クリア検索ハイライト
vim.keymap.set("n", "<Esc>", ":noh<CR>", { desc = "検索ハイライトをクリア" })

-- ===== ファイラー =====
vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Oil ファイラーを開く" })

-- ===== Telescope =====
vim.keymap.set("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "ファイル検索" })
vim.keymap.set("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, { desc = "Grep検索" })
vim.keymap.set("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { desc = "バッファ一覧" })
vim.keymap.set("n", "<leader>fr", function() require("telescope.builtin").oldfiles() end, { desc = "最近のファイル" })
vim.keymap.set("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, { desc = "ヘルプ検索" })
