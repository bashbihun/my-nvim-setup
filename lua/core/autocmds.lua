-- ========================================
-- Auto Commands
-- File: ~/.config/nvim/lua/core/autocmds.lua
-- ========================================

-- Auto-show project menu saat buka Neovim di folder kosong
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local files = vim.fn.glob("*", false, true)
    if #files == 0 then
      vim.defer_fn(function()
        vim.ui.select(
          { "Create Java Project", "Create Kotlin Project", "Skip" },
          { prompt = "📁 Empty directory detected. Create new project?" },
          function(choice)
            if choice == "Create Java Project" then
              CreateJavaProject()
            elseif choice == "Create Kotlin Project" then
              CreateKotlinProject()
            end
          end
        )
      end, 100)
    end
  end
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end
})

-- Auto close NvimTree if it's the last window
vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and
       vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
      vim.cmd("quit")
    end
  end
})