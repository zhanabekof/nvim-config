require("neo-tree").setup({
    filesystem = {
        hijack_netrw_behavior = "open_current", -- Убрать конфликт с netrw
        use_libuv_file_watcher = true,
        follow_current_file = true, -- Следить за текущим файлом
    },
    event_handlers = {
        {
            event = "file_opened",
            handler = function(file_path)
                vim.cmd("tabnew " .. file_path) -- Открывать в новой вкладке
            end,
        },
    },
    window = {
        mappings = {
            ["P"] = {
                "toggle_preview",
                config = {
                    use_float = true,
                    -- use_image_nvim = true,
                    -- title = 'Neo-tree Preview',
                },
            },
        }
    }
})
