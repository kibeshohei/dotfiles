return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local map = function(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end
      map("n", "]h", gs.next_hunk, "次のhunk")
      map("n", "[h", gs.prev_hunk, "前のhunk")
      map("n", "<leader>gp", gs.preview_hunk, "Hunkプレビュー")
      map("n", "<leader>gb", gs.blame_line, "Git blame")
    end,
  },
}
