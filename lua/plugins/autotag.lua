local M = {}

function M.setup()
  require('nvim-ts-autotag').setup({
    filetypes = {
      'html', 'xml', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx', 'rescript',
      'markdown',
    },
    skip_tags = {
      'area', 'base', 'br', 'col', 'command', 'embed', 'hr', 'img', 'slot',
      'input', 'keygen', 'link', 'meta', 'param', 'source', 'track', 'wbr', 'menuitem'
    }
  })
end

return M