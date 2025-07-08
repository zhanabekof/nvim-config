local M = {}

function M.setup()
  require('lspsaga').setup({
    -- UI customization
    ui = {
      border = 'rounded',
      colors = {
        normal_bg = '#1E1E2E'
      }
    },
    -- Symbol in winbar
    symbol_in_winbar = {
      enable = true,
      separator = ' > ',
      hide_keyword = true,
      show_file = true,
      folder_level = 2,
      respect_root = false,
      color_mode = true,
    },
    -- Lightbulb
    lightbulb = {
      enable = true,
      enable_in_insert = true,
      sign = true,
      sign_priority = 40,
      virtual_text = true,
    },
    -- Code action
    code_action = {
      num_shortcut = true,
      keys = {
        quit = 'q',
        exec = '<CR>',
      },
    },
    -- Diagnostics
    diagnostic = {
      show_code_action = true,
      show_source = true,
      jump_num_shortcut = true,
      keys = {
        exec_action = 'o',
        quit = 'q',
        go_action = 'g'
      },
    },
    -- Hover
    hover = {
      max_width = 0.6,
      open_link = 'gx',
      open_browser = '!chrome',
    },
    -- Finder
    finder = {
      max_height = 0.5,
      min_width = 30,
      force_max_height = false,
      keys = {
        jump_to = 'p',
        expand_or_jump = 'o',
        vsplit = 's',
        split = 'i',
        tabe = 't',
        quit = {'q', '<ESC>'},
      },
    },
    -- Definition
    definition = {
      edit = '<C-c>o',
      vsplit = '<C-c>v',
      split = '<C-c>i',
      tabe = '<C-c>t',
      quit = 'q',
    },
    -- Rename
    rename = {
      quit = '<C-c>',
      exec = '<CR>',
      mark = 'x',
      confirm = '<CR>',
      in_select = true,
    },
    -- Outline
    outline = {
      win_position = 'right',
      win_with = '',
      win_width = 30,
      show_detail = true,
      auto_preview = true,
      auto_refresh = true,
      auto_close = true,
      custom_sort = nil,
      keys = {
        jump = 'o',
        expand_collapse = 'u',
        quit = 'q',
      },
    },
  })
end

return M