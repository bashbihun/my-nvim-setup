return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    -- Adapters
    "nvim-neotest/neotest-go",
    "nvim-neotest/neotest-jest",
    "rcasia/neotest-java",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-go")({
          experimental = {
            test_table = true,
          },
          args = { "-count=1", "-timeout=60s", "-race", "-v" }
        }),
        require("neotest-jest")({
          jestCommand = "npx jest",
          jestConfigFile = "jest.config.js",
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        }),
        require("neotest-java")({
          ignore_wrapper = false,
        }),
      },
      output = {
        enabled = true,
        open_on_run = true,
      },
      summary = {
        enabled = true,
        animated = true,
        follow = true,
        expand_errors = true,
      },
      status = {
        enabled = true,
        signs = true,
        virtual_text = true,
      },
      icons = {
        passed = "✅",
        failed = "❌",
        running = "🔄",
        skipped = "⏭",
        unknown = "❓",
      },
    })
  end
}
