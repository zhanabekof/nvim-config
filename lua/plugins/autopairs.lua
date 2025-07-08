local M = {}

function M.setup()
  local npairs = require("nvim-autopairs")
  local Rule = require('nvim-autopairs.rule')
  local cond = require('nvim-autopairs.conds')

  npairs.setup({
    check_ts = true,
    ts_config = {
      lua = {'string'},
      javascript = {'template_string'},
      java = false,
    },
    disable_filetype = { "TelescopePrompt", "vim" },
    fast_wrap = {
      map = '<M-e>',
      chars = { '{', '[', '(', '"', "'" },
      pattern = [=[[%'%"%)%>%]%)%}%,]]=],
      end_key = '$',
      keys = 'qwertyuiopzxcvbnmasdfghjkl',
      check_comma = true,
      highlight = 'Search',
      highlight_grey='Comment'
    },
  })

  -- Add spaces between parentheses
  npairs.add_rules({
    Rule(' ', ' ')
      :with_pair(function (opts)
        local pair = opts.line:sub(opts.col - 1, opts.col)
        return vim.tbl_contains({ '()', '[]', '{}' }, pair)
      end),
    Rule('( ', ' )')
      :with_pair(function() return false end)
      :with_move(function(opts)
        return opts.prev_char:match('.%)') ~= nil
      end)
      :use_key(')'),
    Rule('{ ', ' }')
      :with_pair(function() return false end)
      :with_move(function(opts)
        return opts.prev_char:match('.%}') ~= nil
      end)
      :use_key('}'),
    Rule('[ ', ' ]')
      :with_pair(function() return false end)
      :with_move(function(opts)
        return opts.prev_char:match('.%]') ~= nil
      end)
      :use_key(']')
  })

  -- Auto pair for arrow function in TypeScript
  npairs.add_rules({
    Rule('%(.*%)%s*%=>$', ' {  }', { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' })
      :use_regex(true)
      :set_end_pair_length(2),
  })

  -- Integration with nvim-cmp
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  local cmp = require('cmp')
  cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
  )
end

return M