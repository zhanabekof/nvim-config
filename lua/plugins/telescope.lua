require('telescope').setup{
  defaults = {
    prompt_prefix = "🔍 ",
    selection_caret = "➤ ",
    path_display = { "smart" },
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = "top",
    },
    file_ignore_patterns = { "node_modules", ".git/", "dist/" }
  },
  pickers = {
    find_files = {
      hidden = true,   -- Показывать скрытые файлы
    },
    live_grep = {
      theme = "dropdown",
    }
  },
  extensions = {
    fzf = {
      fuzzy = true,  -- Включить нечеткий поиск
    }
  }
}
