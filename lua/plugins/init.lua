-- ========================================
-- Plugin Manager Setup
-- File: ~/.config/nvim/lua/plugins/init.lua
-- ========================================

-- Install lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load all plugins
require("lazy").setup({
  -- Load individual plugin configs
  require("plugins.nvim-tree"),
  require("plugins.lsp"),
  require("plugins.cmp"),
  require("plugins.treesitter"),
  require("plugins.telescope"),
  require("plugins.git"),
  require("plugins.ui"),
  require("plugins.neotest"),
})

