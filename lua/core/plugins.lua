-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	{
		"glepnir/dashboard-nvim",
		event = "VimEnter",
		config = function()
			local db = require("dashboard")

			db.setup({
				theme = "hyper",
				config = {
					header = {
						"  █████╗ ██╗ ███████╗██╗  ██╗ █████╗  ",
						" ██╔══██╗██║ ██╔════╝██║  ██║██╔══██╗ ",
						" ███████║██║ ███████╗███████║███████║ ",
						" ██╔══██║██║ ╚════██║██╔══██║██╔══██║ ",
						" ██║  ██║██║ ███████║██║  ██║██║  ██║ ",
						" ╚═╝  ╚═╝╚═╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ",
					},
					week_header = { enable = false },
					shortcut = {
						{ desc = "🔍 Find File", group = "@string", action = "Telescope find_files", key = "f" },
						{ desc = "📂 Recent Files", group = "@string", action = "Telescope oldfiles", key = "r" },
						{ desc = "🛠 Config", group = "DiagnosticHint", action = "edit $MYVIMRC", key = "c" },
					},
				},
			})
		end,
	},
	{
		'jackMort/ChatGPT.nvim',
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"folke/trouble.nvim", -- optional
			"nvim-telescope/telescope.nvim"
		},
		config = function()
			require("chatgpt").setup({
				extra_curl_params = {
					"-H",
					"Origin: https://example.com"
				}-- Or configure as needed
			})
		end
	},
	{'phaazon/hop.nvim'},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
		},
	},
	{'nvim-treesitter/nvim-treesitter'},
	{
		'neovim/nvim-lspconfig'
	},
	install = {
		colorscheme = {"onedark"}
	},
	{
		'navarasu/onedark.nvim',
		config = function()
			require('onedark').setup {
				style = 'dark' -- Доступные стили: 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'
			}
			require('onedark').load()
		end
	},
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
		}},
		{
			"nvim-telescope/telescope.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },  -- Важная зависимость
			config = function()
				require('telescope').setup{
					defaults = {
						file_ignore_patterns = { "node_modules", ".git/" },
						mappings = {
							i = { ["<esc>"] = require("telescope.actions").close }
						}
					}
				}
			end
		},
		{
			'nvim-lualine/lualine.nvim',
			dependencies = { 'nvim-tree/nvim-web-devicons' },  -- Иконки для файлов
			config = function()
				require('lualine').setup({
					sections = {
						lualine_a = {'mode'},
						lualine_b = {'branch'},
						lualine_c = {'filename'},
						lualine_x = {'encoding', 'fileformat', 'filetype'},
						lualine_y = {'progress'},
						lualine_z = {'location'}
					},
					tabline = {
						lualine_a = {'buffers'},
						lualine_b = {'tabs'},
					}
				})
			end
		}

	})
