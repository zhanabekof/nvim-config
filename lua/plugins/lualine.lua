require('lualine').setup({
  options = {
    theme = 'onedark',
    globalstatus = true,  -- Одна строка на все окна
    always_divide_middle = false,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename', { 'lsp_progress' }},
    lualine_x = {
      'encoding',
      { 'fileformat', symbols = { unix = '', dos = '', mac = '' }},
      'filetype'
    },
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  extensions = { 'fugitive', 'quickfix', 'nvim-tree' }  -- Поддержка плагинов
})

