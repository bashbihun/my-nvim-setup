-- ========================================
-- Global Keymaps
-- File: ~/.config/nvim/lua/core/keymaps.lua
-- ========================================

local keymap = vim.keymap.set

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General
keymap("n", "<leader>w", ":w<CR>", { desc = "Save file" })
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", ":qa!<CR>", { desc = "Quit all" })

-- File & Folder Management
keymap("n", "<leader>a", ":lua CreateNewFile()<CR>", { desc = "Create new file" })
keymap("n", "<leader>A", ":lua CreateNewFolder()<CR>", { desc = "Create new folder" })

-- File Explorer
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Terminal
keymap("n", "<leader>t", ":lua OpenTerminal()<CR>", { desc = "Open terminal" })
keymap("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Project Creation
keymap("n", "<leader>np", ":lua ShowProjectMenu()<CR>", { desc = "New project" })

-- Fuzzy Finder (Telescope)
keymap("n", "<C-p>", ":Telescope find_files<CR>", { desc = "Find files" })
keymap("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
keymap("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers" })
keymap("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Help tags" })
keymap("n", "<leader>fr", ":Telescope oldfiles<CR>", { desc = "Recent files" })

-- Buffer/Tab Navigation
keymap("n", "<Tab>", ":BufferLineCycleNext<CR>", { desc = "Next buffer" })
keymap("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>bd", ":bdelete<CR>", { desc = "Close buffer" })
keymap("n", "<leader>1", ":BufferLineGoToBuffer 1<CR>", { desc = "Go to buffer 1" })
keymap("n", "<leader>2", ":BufferLineGoToBuffer 2<CR>", { desc = "Go to buffer 2" })
keymap("n", "<leader>3", ":BufferLineGoToBuffer 3<CR>", { desc = "Go to buffer 3" })
keymap("n", "<leader>4", ":BufferLineGoToBuffer 4<CR>", { desc = "Go to buffer 4" })
keymap("n", "<leader>5", ":BufferLineGoToBuffer 5<CR>", { desc = "Go to buffer 5" })

-- Git
keymap("n", "<leader>gg", ":Telescope git_status<CR>", { desc = "Git status" })
keymap("n", "<leader>gc", ":Telescope git_commits<CR>", { desc = "Git commits" })
keymap("n", "<leader>gB", ":Telescope git_branches<CR>", { desc = "Git branches" })

-- Java (aktif di file .java)
-- <leader>jr - Java Run
-- <leader>jb - Java Build
-- <leader>jt - Java Test

-- Kotlin (aktif di file .kt)
-- <leader>kr - Kotlin Run
-- <leader>kb - Kotlin Build
-- <leader>kt - Kotlin Test

-- Spring Boot (aktif di Spring Boot project)
-- <leader>sr - Spring Boot Run
-- <leader>sb - Spring Boot Build
-- <leader>st - Spring Boot Test
-- <leader>sd - Spring Boot Dev Mode

-- LSP (will be overridden by LSP config)
keymap("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
keymap("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
keymap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
keymap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
keymap("n", "gr", vim.lsp.buf.references, { desc = "References" })

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize windows
keymap("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Clear search highlight
keymap("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlight" })

-- Neotest
keymap("n", "<leader>tt", ":lua require('neotest').run.run()<CR>",                                { desc = "Run nearest test (method)" })
keymap("n", "<leader>tf", ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>",              { desc = "Run current file tests" })
keymap("n", "<leader>ta", ":lua require('neotest').run.run(vim.fn.getcwd())<CR>",                 { desc = "Run all tests" })
keymap("n", "<leader>ts", ":lua require('neotest').summary.toggle()<CR>",                         { desc = "Toggle test summary" })
keymap("n", "<leader>to", ":lua require('neotest').output.open({ enter = true })<CR>",            { desc = "Open test output" })
keymap("n", "<leader>tS", ":lua require('neotest').run.stop()<CR>",                               { desc = "Stop test" })
keymap("n", "<leader>tl", ":lua require('neotest').run.run_last()<CR>",                           { desc = "Run last test" })

-- Test picker (pilih mau test apa)
keymap("n", "<leader>tp", ":lua TestPicker()<CR>", { desc = "Test picker menu" })
