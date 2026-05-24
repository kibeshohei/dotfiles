return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
        "typescript", "tsx", "javascript", "python", "lua",
        "json", "html", "css", "markdown", "bash", "vim", "vimdoc",
      },
    })
  end,
}
