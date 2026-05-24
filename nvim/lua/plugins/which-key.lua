return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>f", group = "検索" },
      { "<leader>c", group = "コード" },
      { "<leader>r", group = "リネーム" },
      { "<leader>g", group = "Git" },
    },
  },
}
