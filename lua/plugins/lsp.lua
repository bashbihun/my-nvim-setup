-- ========================================
-- LSP Configuration dengan Mason (Neovim 0.11+)
-- File: ~/.config/nvim/lua/plugins/lsp.lua
-- ========================================

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- ============================================
    -- Mason Setup
    -- ============================================
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        },
        border = "rounded",
      }
    })

    require("mason-lspconfig").setup({
      ensure_installed = { 
        "jdtls",                    -- Java LSP
        "kotlin_language_server",   -- Kotlin LSP
        "gopls",                    -- Go LSP
      },
      automatic_installation = true,
    })

    -- ============================================
    -- LSP Keybindings
    -- ============================================
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local opts = { buffer = args.buf, silent = true }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        
        print("✅ LSP attached: " .. vim.lsp.get_client_by_id(args.data.client_id).name)
      end
    })

    -- ============================================
    -- LSP Config (Neovim 0.11+)
    -- ============================================

    -- Kotlin LSP
    vim.lsp.config.kotlin_language_server = {
      cmd = { "kotlin-language-server" },
      filetypes = { "kotlin" },
      root_markers = { 
        "settings.gradle",
        "settings.gradle.kts",
        "build.gradle",
        "build.gradle.kts",
        ".git"
      },
      settings = {
        kotlin = {
          compiler = {
            jvm = {
              target = "11"
            }
          }
        }
      }
    }

    -- Java LSP (jdtls)
    vim.lsp.config.jdtls = {
      cmd = { "jdtls" },
      filetypes = { "java" },
      root_markers = { 
        ".git",
        "pom.xml",
        "build.gradle",
        "build.gradle.kts",
        "mvnw",
        "gradlew"
      },
      settings = {
        java = {
          signatureHelp = { enabled = true },
          contentProvider = { preferred = "fernflower" },
          completion = {
            favoriteStaticMembers = {
              "org.junit.Assert.*",
              "org.junit.Assume.*",
              "org.junit.jupiter.api.Assertions.*",
              "org.junit.jupiter.api.Assumptions.*",
              "org.junit.jupiter.api.DynamicTest.*",
            },
          },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
        }
      }
    }

    -- Auto-enable Kotlin LSP
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "kotlin",
      callback = function()
        vim.lsp.enable("kotlin_language_server")
      end
    })

    -- Auto-enable Java LSP
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        vim.lsp.enable("jdtls")
      end
    })

    print("✅ LSP configured with Mason!")
  end
}