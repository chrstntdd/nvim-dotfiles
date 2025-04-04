return {
  "neovim/nvim-lspconfig",
  version = "*",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    {
      "j-hui/fidget.nvim",
      tag = "v1.2.0",
      opts = {},
    },
  },
  opts = {
    servers = {
      eslint = {
        settings = {
          useFlatConfig = false,
          experimental = {
            useFlatConfig = nil,
          },
        },
      },
    },
    setup = {
      eslint = function()
        require("lazyvim.util").lsp.on_attach(function(client)
          if client.name == "eslint" then
            client.server_capabilities.documentFormattingProvider = true
          elseif client.name == "tsserver" then
            client.server_capabilities.documentFormattingProvider = false
          end
        end)
      end,
    },
  },
  config = function()
    require("mason").setup({})
    local lspconfig = require("lspconfig")
    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }

    -- Perf
    -- https://www.reddit.com/r/neovim/comments/161tv8l/comment/jzfen6b/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
    local capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      require("cmp_nvim_lsp").default_capabilities()
    )
    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

    local on_attach = function(client, bufnr)
      opts.buffer = bufnr

      opts.desc = "Show LSP references"
      keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

      opts.desc = "Go to declaration"
      keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

      opts.desc = "Show LSP definitions"
      keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

      opts.desc = "Show LSP implementations"
      keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

      opts.desc = "Show LSP type definitions"
      keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

      opts.desc = "See available code actions"
      keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

      opts.desc = "Smart rename"
      keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

      opts.desc = "Show buffer diagnostics"
      keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

      opts.desc = "Show line diagnostics"
      keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

      opts.desc = "Show documentation for what is under cursor"
      keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

      opts.desc = "Restart LSP"
      keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

      opts.desc = "Show function signature"
      keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
    end

    require("mason-lspconfig").setup({
      automatic_installation = { exclude = { "ocamllsp" } },
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,
      },
    })

    local config = {
      virtual_text = true,
      update_in_insert = true,
      underline = true,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    }

    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "rounded",
    })

    -- Change the Diagnostic symbols in the sign column (gutter)
    local signs = { Error = "E ", Warn = "W ", Hint = "H ", Info = "I " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    lspconfig["jsonls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        json = {
          schemas = {
            {
              fileMatch = { "package.json" },
              url = "https://json.schemastore.org/package.json",
            },
          },
        },
      },
    })

    lspconfig["html"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["typos_lsp"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["ts_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        maxTsServerMemory = 12288,
        completions = {
          completeFunctionCalls = true,
        },
      },
      root_dir = lspconfig.util.root_pattern("package.json"),
    })

    lspconfig["denols"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        completions = {
          completeFunctionCalls = true,
        },
      },
      root_dir = lspconfig.util.root_pattern("deno.json"),
    })

    lspconfig["cssls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["tailwindcss"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        tailwindCSS = {
          experimental = {
            classRegex = {
              { "cva\\(([^)]*)\\)",                 "[\"'`]([^\"'`]*).*?[\"'`]" },
              { "cx\\(([^)]*)\\)",                  "(?:'|\"|`)([^']*)(?:'|\"|`)" },
              { "tv\\((([^()]*|\\([^()]*\\))*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
            },
          },
        },
      },
    })

    lspconfig["emmet_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "svelte", "typescript", "javascript" },
    })

    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = { -- custom settings for lua
        Lua = {
          -- make the language server recognize "vim" global
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            -- make language server aware of runtime files
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })

    lspconfig["ocamllsp"].setup({
      cmd = { "ocamllsp" },
      filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
      root_dir = lspconfig.util.root_pattern("*.opam", "package.json", ".git", "dune-project", "dune-workspace"),
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        codelens = { enabled = true },
      },
    })

    lspconfig["gleam"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["astro"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- lspconfig["eslint"].setup({
    --   capabilities = capabilities,
    --   on_attach = on_attach,
    -- })
  end,
}
