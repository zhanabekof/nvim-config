vim.g.mapleader = " "

-- Neotree

vim.keymap.set('n','<leader>e',':Neotree float focus<CR>')
vim.keymap.set('n','<leader>o',':Neotree float git_status<CR>')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Поиск файлов" })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Поиск по содержимому" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Открытые буферы" })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Поиск по документации" })
