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
		end
	},
	-- Mason для управления LSP, линтерами и форматтерами
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig"
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"ts_ls",
					"eslint",
					"jsonls",
					"html",
					"cssls"
				},
				automatic_installation = true,
				automatic_enable = false
			})
		end
	},
	-- Автодополнение
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets"
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			
			require("luasnip.loaders.from_vscode").lazy_load()
			
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expandable() then
							luasnip.expand()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
					{ name = "path" }
				})
			})
		end
	},
	-- Линтинг и форматирование
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.prettier.with({
						condition = function(utils)
							return utils.has_file({ ".prettierrc", ".prettierrc.js", ".prettierrc.json" })
						end,
					}),
					null_ls.builtins.diagnostics.eslint.with({
						condition = function(utils)
							return utils.has_file({ ".eslintrc", ".eslintrc.js", ".eslintrc.json" })
						end,
					}),
					null_ls.builtins.code_actions.eslint.with({
						condition = function(utils)
							return utils.has_file({ ".eslintrc", ".eslintrc.js", ".eslintrc.json" })
						end,
					}),
				}
			})
		end
	},
	-- Улучшенный UI для LSP
	{
		"glepnir/lspsaga.nvim",
		event = "LspAttach",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"nvim-treesitter/nvim-treesitter"
		},
		config = function()
			require("lspsaga").setup({
				ui = {
					border = "rounded",
				},
				symbol_in_winbar = {
					enable = true
				},
				lightbulb = {
					enable = true
				}
			})
		end
	},
	-- Автоматическое закрытие тегов для HTML/JSX/TSX
	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-ts-autotag").setup()
		end
	},
	-- Автоматические пары скобок
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup()
		end
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
		},
        {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  config = function()
    require("typescript-tools").setup({
      settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insert_leave",
        expose_as_code_action = "all",
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayVariableTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
        },
      },
    })
  end,
}
})
