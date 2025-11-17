-- ========================================
-- Git Integration (GitSigns)
-- File: ~/.config/nvim/lua/plugins/git.lua
-- ========================================

return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({
      signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        interval = 1000,
        follow_files = true
      },
      attach_to_untracked = true,
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 1000,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        -- Git keybindings
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map('n', '<leader>gb', function() gs.blame_line{full=true} end, { desc = "Git blame" })
        map('n', '<leader>gd', gs.diffthis, { desc = "Git diff" })
        map('n', '<leader>gp', gs.preview_hunk, { desc = "Preview hunk" })
        map('n', ']c', gs.next_hunk, { desc = "Next hunk" })
        map('n', '[c', gs.prev_hunk, { desc = "Prev hunk" })
        map('n', '<leader>gs', gs.stage_hunk, { desc = "Stage hunk" })
        map('n', '<leader>gu', gs.undo_stage_hunk, { desc = "Undo stage hunk" })
        map('n', '<leader>gr', gs.reset_hunk, { desc = "Reset hunk" })
      end
    })
  end
}