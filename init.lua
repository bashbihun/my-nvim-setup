-- ========================================
-- Neovim Init - Entry Point
-- File: ~/.config/nvim/init.lua
-- ========================================

-- Load core configurations
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Load plugin manager
require("plugins")

-- Load utilities
require("utils.java")
require("utils.kotlin")
require("utils.golang")
require("utils.projects")
require("utils.springboot")

print("✅ Neovim loaded successfully!")