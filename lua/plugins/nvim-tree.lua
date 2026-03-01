-- ========================================
-- File Explorer (nvim-tree)
-- File: ~/.config/nvim/lua/plugins/nvim-tree.lua
-- ========================================

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local function my_on_attach(bufnr)
      local api = require("nvim-tree.api")
      local opts = function(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- Load semua default keymaps dulu
      api.config.mappings.default_on_attach(bufnr)

      -- Override 'a' agar create di lokasi cursor
      vim.keymap.set("n", "a", function()
        local node = api.tree.get_node_under_cursor()
        api.fs.create(node)
      end, opts("Create file or folder"))
    end

    require("nvim-tree").setup({
      on_attach = my_on_attach,
      sort_by = "case_sensitive",
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
        icons = {
          show = {
            git = true,
            folder = true,
            file = true,
          },
        },
      },
      filters = {
        dotfiles = false,
      },
      git = {
        enable = true,
        ignore = false,
      },
    })
  end
}
