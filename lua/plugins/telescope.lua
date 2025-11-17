-- ========================================
-- Fuzzy Finder (Telescope)
-- File: ~/.config/nvim/lua/plugins/telescope.lua
-- ========================================

return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup({
      defaults = {
        prompt_prefix = "🔍 ",
        selection_caret = "➜ ",
        path_display = { "truncate" },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<C-q>"] = "close",
          },
        },
      },
      pickers = {
        find_files = {
          theme = "dropdown",
          previewer = false,
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
        },
      },
    })
  end
}