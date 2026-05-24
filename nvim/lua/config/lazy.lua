-- lazy.nvimのブートストラップ
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- プラグインのセットアップ
require("lazy").setup({
  -- ここにプラグインを追加していきます
  -- 例: { "plugin-name" }
  -- または lua/plugins/ 内のファイルを自動読み込み
  { import = "plugins" },
}, {
  -- lazy.nvimの設定
  checker = { enabled = true },  -- 更新チェック
  change_detection = {
    notify = false,              -- 変更検知の通知を無効化
  },
})
