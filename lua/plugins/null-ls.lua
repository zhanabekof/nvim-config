local M = {}

function M.setup()
  local null_ls = require("null-ls")
  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  local code_actions = null_ls.builtins.code_actions

  -- Check if prettier config exists in the project
  local function prettier_config_exists()
    local prettier_files = {
      ".prettierrc",
      ".prettierrc.json",
      ".prettierrc.yml",
      ".prettierrc.yaml",
      ".prettierrc.json5",
      ".prettierrc.js",
      ".prettierrc.cjs",
      "prettier.config.js",
      "prettier.config.cjs",
    }

    for _, file in ipairs(prettier_files) do
      if vim.fn.filereadable(vim.fn.getcwd() .. "/" .. file) == 1 then
        return true
      end
    end
    return false
  end

  -- Check if eslint config exists in the project
  local function eslint_config_exists()
    local eslint_files = {
      ".eslintrc",
      ".eslintrc.js",
      ".eslintrc.cjs",
      ".eslintrc.yaml",
      ".eslintrc.yml",
      ".eslintrc.json",
      "eslint.config.js",
      "eslint.config.mjs",
    }

    for _, file in ipairs(eslint_files) do
      if vim.fn.filereadable(vim.fn.getcwd() .. "/" .. file) == 1 then
        return true
      end
    end
    return false
  end

  null_ls.setup({
    debug = false,
    sources = {
      -- Formatting
      prettier_config_exists() and formatting.prettier.with({
        prefer_local = "node_modules/.bin",
        condition = function(utils)
          return utils.root_has_file({
            ".prettierrc",
            ".prettierrc.json",
            ".prettierrc.yml",
            ".prettierrc.yaml",
            ".prettierrc.json5",
            ".prettierrc.js",
            ".prettierrc.cjs",
            "prettier.config.js",
            "prettier.config.cjs",
          })
        end,
      }) or nil,

      -- Diagnostics
      eslint_config_exists() and diagnostics.eslint_d.with({
        prefer_local = "node_modules/.bin",
        condition = function(utils)
          return utils.root_has_file({
            ".eslintrc",
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.yaml",
            ".eslintrc.yml",
            ".eslintrc.json",
            "eslint.config.js",
            "eslint.config.mjs",
          })
        end,
      }) or nil,

      -- Code Actions
      eslint_config_exists() and code_actions.eslint_d.with({
        prefer_local = "node_modules/.bin",
        condition = function(utils)
          return utils.root_has_file({
            ".eslintrc",
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.yaml",
            ".eslintrc.yml",
            ".eslintrc.json",
            "eslint.config.js",
            "eslint.config.mjs",
          })
        end,
      }) or nil,
    },
    -- Format on save
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
  })
end

return M