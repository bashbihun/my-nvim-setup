-- ========================================
-- Syntax Highlighting (Treesitter)
-- File: ~/.config/nvim/lua/plugins/treesitter.lua
-- ========================================

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
        "java",
        "kotlin",
        "go",
        "gomod",
        "gowork",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "html",
        "css",
        "vue",
        "svelte",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
        "python",
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
    })
  end
}
