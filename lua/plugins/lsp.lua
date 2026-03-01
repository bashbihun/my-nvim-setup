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
        "ts_ls",                    -- TypeScript/JavaScript LSP
        "vue_ls",                    -- Vue LSP
        "svelte",                   -- Svelte LSP
        "eslint",                   -- ESLint LSP
      },
      automatic_installation = true,
    })


-- Capabilities dengan auto-import support
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Apply capabilities ke gopls
vim.lsp.config.gopls = {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
  capabilities = capabilities,
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = { unusedparams = true, shadow = true },
      staticcheck = true,
      gofumpt = true,
    },
  },
}


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
  capabilities = capabilities,  -- tambah ini
  settings = {
    kotlin = {
      compiler = { jvm = { target = "11" } },
      completion = {
        snippets = { enabled = true },
      },
    }
  },
  init_options = {
    storagePath = vim.fn.stdpath("data") .. "/kotlin-ls",
  },
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
  capabilities = capabilities,  -- tambah ini
  settings = {
    java = {
      signatureHelp = { enabled = true },
      completion = {
        enabled = true,
        importOrder = { "java", "javax", "org", "com" },
        filteredTypes = {
          "com.sun.*", "io.micrometer.shaded.*",
          "java.awt.*", "jdk.*", "sun.*",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      autobuild = { enabled = true },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
        },
        useBlocks = true,
      },
    }
  }
}


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

        -- Auto-import on completion
        vim.keymap.set('n', '<leader>ai', vim.lsp.buf.code_action, opts)

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
      },
      -- Enable auto-import
      init_options = {
        storagePath = vim.fn.stdpath("data") .. "/kotlin-ls",
      },
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
            filteredTypes = {
              "com.sun.*",
              "io.micrometer.shaded.*",
              "java.awt.*",
              "jdk.*",
              "sun.*",
            },
            importOrder = {
              "java",
              "javax",
              "org",
              "com",
            },
          },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
            },
            useBlocks = true,
          },
          -- Enable auto-import
          autobuild = { enabled = true },
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

    -- Go LSP (gopls)
    vim.lsp.config.gopls = {
      cmd = { "gopls" },
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      root_markers = { "go.work", "go.mod", ".git" },
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
            shadow = true,
          },
          staticcheck = true,
          gofumpt = true,
          -- Enable auto-import
          completeUnimported = true,
          usePlaceholders = true,
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
    }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "go",
      callback = function()
        vim.lsp.enable("gopls")
      end
    })

    -- TypeScript/JavaScript LSP (ts_ls)
    vim.lsp.config.ts_ls = {
      cmd = { "typescript-language-server", "--stdio" },
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
            capabilities = capabilities,
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      },
    }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      callback = function()
        vim.lsp.enable("ts_ls")
      end
    })

    -- Vue LSP (Volar)
    vim.lsp.config.vue_ls = {
      cmd = { "vue-language-server", "--stdio" },
      filetypes = { "vue" },
      root_markers = { "package.json", ".git" },
            capabilities = capabilities,
    }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "vue",
      callback = function()
        vim.lsp.enable("vue_ls")
      end
    })

    -- Svelte LSP
    vim.lsp.config.svelte = {
      cmd = { "svelteserver", "--stdio" },
      filetypes = { "svelte" },
      root_markers = { "package.json", "svelte.config.js", ".git" },
            capabilities = capabilities,
    }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "svelte",
      callback = function()
        vim.lsp.enable("svelte")
      end
    })

    -- ESLint LSP
    vim.lsp.config.eslint = {
      cmd = { "vscode-eslint-language-server", "--stdio" },
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
      root_markers = { ".eslintrc", ".eslintrc.js", ".eslintrc.json", "package.json" },
            capabilities = capabilities,
      settings = {
        validate = "on",
        packageManager = "npm",
        useESLintClass = false,
        codeActionOnSave = {
          enable = false,
          mode = "all"
        },
      },
    }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
      callback = function()
        vim.lsp.enable("eslint")
      end
    })

    print("✅ LSP configured with Mason!")
  end
}
