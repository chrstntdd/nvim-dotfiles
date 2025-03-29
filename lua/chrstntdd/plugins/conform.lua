return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    {
      "<leader>pp",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  },
  config = function()
    require('conform').setup({
      formatters_by_ft = {
        javascript = { "prettier", "prettierd" },
        typescript = { "prettier", "prettierd" },
        typescriptreact = { "prettier", "prettierd" },
        javascriptreact = { "prettier", "prettierd" },
        html = { "prettier", "prettierd" },
        css = { "prettier", "prettierd" },
        json = { "prettier", "prettierd" },
        yaml = { "prettier", "prettierd" },
        markdown = { "prettier", "prettierd" },
        lua = { "stylua" },
        bash = { "shfmt" },
      },
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true, txt = true }

        -- avoid formatting in node_modules
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match "/node_modules/" then
          return
        end

        return {
          async = false,
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
    })
  end,
}
