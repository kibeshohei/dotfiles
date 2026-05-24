-- カラースキーム設定
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,    -- 起動時にすぐ読み込む
    priority = 1000, -- 他のプラグインより先に読み込む
    config = function()
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },
}
