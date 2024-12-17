-- The Neovim configuration used by @starlitnova
-- Based off some config I found online
-- Some changes were done:
--    Tab - confirms autocomplete
--    Tab width - 4
--    Tabs expanded - true
--    <Leader>R - reveal in file explorer (windows)
--    Alt-Up - move line up
--    Alt-Down - move line down
-- space is objectively the best leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.cmd([[language en_US.UTF-8]])

vim.g.have_nerd_font = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true

vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = {
	tab = "» ",
	trail = "·",
	nbsp = "␣",
}

vim.opt.inccommand = "split"

vim.opt.cursorline = true
vim.opt.scrolloff = 10

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, {
	desc = "Open diagnostic [Q]uickfix list",
})

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", {
	desc = "Exit terminal mode",
})

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", {
	desc = "Move focus to the left window",
})
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", {
	desc = "Move focus to the right window",
})
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", {
	desc = "Move focus to the lower window",
})
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", {
	desc = "Move focus to the upper window",
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", {
		clear = true,
	}),
	callback = function()
		vim.highlight.on_yank()
	end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = {
					text = "+",
				},
				change = {
					text = "~",
				},
				delete = {
					text = "_",
				},
				topdelete = {
					text = "‾",
				},
				changedelete = {
					text = "|",
				},
			},
		},
	},
	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		opts = {
			icons = {
				mappings = vim.g.have_nerd_font,
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},

			spec = {
				{
					"<leader>c",
					group = "[C]ode",
					mode = { "n", "x" },
				},
				{
					"<leader>d",
					group = "[D]ocument",
				},
				{
					"<leader>r",
					group = "[R]ename",
				},
				{
					"<leader>s",
					group = "[S]earch",
				},
				{
					"<leader>w",
					group = "[W]orkspace",
				},
				{
					"<leader>t",
					group = "[T]oggle",
				},
				{
					"<leader>h",
					group = "Git [H]unk",
					mode = { "n", "v" },
				},
			},
		},
	},
	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{
				"nvim-tree/nvim-web-devicons",
				enabled = vim.g.have_nerd_font,
			},
		},
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = { require("telescope.themes").get_dropdown() },
				},
			})

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, {
				desc = "[S]earch [H]elp",
			})
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, {
				desc = "[S]earch [K]eymaps",
			})
			vim.keymap.set("n", "<leader>sf", builtin.find_files, {
				desc = "[S]earch [F]iles",
			})
			vim.keymap.set("n", "<leader>ss", builtin.builtin, {
				desc = "[S]earch [S]elect Telescope",
			})
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, {
				desc = "[S]earch current [W]ord",
			})
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, {
				desc = "[S]earch by [G]rep",
			})
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, {
				desc = "[S]earch [D]iagnostics",
			})
			vim.keymap.set("n", "<leader>sr", builtin.resume, {
				desc = "[S]earch [R]esume",
			})
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, {
				desc = '[S]earch Recent Files ("." for repeat)',
			})
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, {
				desc = "[ ] Find existing buffers",
			})

			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, {
				desc = "[/] Fuzzily search in current buffer",
			})

			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, {
				desc = "[S]earch [/] in Open Files",
			})

			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({
					cwd = vim.fn.stdpath("config"),
				})
			end, {
				desc = "[S]earch [N]eovim files",
			})
		end,
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		requires = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({})
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			"3rd/image.nvim",
		},
	}, -- LSP Plugins
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = { -- Load luvit types when the `vim.uv` word is found
				{
					path = "luvit-meta/library",
					words = { "vim%.uv" },
				},
			},
		},
	},
	{
		"Bilal2453/luvit-meta",
		lazy = true,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", {
					clear = true,
				}),
				callback = function(event)
					local fn = vim.fn
					local api = vim.api
					local keymap = vim.keymap
					local lsp = vim.lsp
					local diagnostic = vim.diagnostic
					local lspconfig = require("lspconfig")

					local utils = require("utils")

					-- set quickfix list from diagnostics in a certain buffer, not the whole workspace
					local set_qflist = function(buf_num, severity)
						local diagnostics = nil
						diagnostics = diagnostic.get(buf_num, {
							severity = severity,
						})

						local qf_items = diagnostic.toqflist(diagnostics)
						vim.fn.setqflist({}, " ", {
							title = "Diagnostics",
							items = qf_items,
						})

						-- open quickfix by default
						vim.cmd([[copen]])
					end

					local custom_attach = function(client, bufnr)
						-- Mappings.
						local map = function(mode, l, r, opts)
							opts = opts or {}
							opts.silent = true
							opts.buffer = bufnr
							keymap.set(mode, l, r, opts)
						end

						map("n", "gd", vim.lsp.buf.definition, {
							desc = "go to definition",
						})
						map("n", "<C-]>", vim.lsp.buf.definition)
						map("n", "K", vim.lsp.buf.hover)
						map("n", "<C-k>", vim.lsp.buf.signature_help)
						map("n", "<space>rn", vim.lsp.buf.rename, {
							desc = "varialbe rename",
						})
						map("n", "gr", vim.lsp.buf.references, {
							desc = "show references",
						})
						map("n", "[d", diagnostic.goto_prev, {
							desc = "previous diagnostic",
						})
						map("n", "]d", diagnostic.goto_next, {
							desc = "next diagnostic",
						})
						-- this puts diagnostics from opened files to quickfix
						map("n", "<space>qw", diagnostic.setqflist, {
							desc = "put window diagnostics to qf",
						})
						-- this puts diagnostics from current buffer to quickfix
						map("n", "<space>qb", function()
							set_qflist(bufnr)
						end, {
							desc = "put buffer diagnostics to qf",
						})
						map("n", "<space>ca", vim.lsp.buf.code_action, {
							desc = "LSP code action",
						})
						map("n", "<space>wa", vim.lsp.buf.add_workspace_folder, {
							desc = "add workspace folder",
						})
						map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, {
							desc = "remove workspace folder",
						})
						map("n", "<space>wl", function()
							vim.print(vim.lsp.buf.list_workspace_folders())
						end, {
							desc = "list workspace folder",
						})

						-- Set some key bindings conditional on server capabilities
						if client.server_capabilities.documentFormattingProvider then
							map({ "n", "x" }, "<space>f", vim.lsp.buf.format, {
								desc = "format code",
							})
						end

						-- Uncomment code below to enable inlay hint from language server, some LSP server supports inlay hint,
						-- but disable this feature by default, so you may need to enable inlay hint in the LSP server config.
						-- vim.lsp.inlay_hint.enable(true, {buffer=bufnr})

						api.nvim_create_autocmd("CursorHold", {
							buffer = bufnr,
							callback = function()
								local float_opts = {
									focusable = false,
									close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
									border = "rounded",
									source = "always", -- show source in diagnostic popup window
									prefix = " ",
								}

								if not vim.b.diagnostics_pos then
									vim.b.diagnostics_pos = { nil, nil }
								end

								local cursor_pos = api.nvim_win_get_cursor(0)
								if
									(
										cursor_pos[1] ~= vim.b.diagnostics_pos[1]
										or cursor_pos[2] ~= vim.b.diagnostics_pos[2]
									) and #diagnostic.get() > 0
								then
									diagnostic.open_float(nil, float_opts)
								end

								vim.b.diagnostics_pos = cursor_pos
							end,
						})

						-- The blow command will highlight the current variable and its usages in the buffer.
						if client.server_capabilities.documentHighlightProvider then
							vim.cmd([[
						  hi! link LspReferenceRead Visual
						  hi! link LspReferenceText Visual
						  hi! link LspReferenceWrite Visual
						]])

							local gid = api.nvim_create_augroup("lsp_document_highlight", {
								clear = true,
							})
							api.nvim_create_autocmd("CursorHold", {
								group = gid,
								buffer = bufnr,
								callback = function()
									lsp.buf.document_highlight()
								end,
							})

							api.nvim_create_autocmd("CursorMoved", {
								group = gid,
								buffer = bufnr,
								callback = function()
									lsp.buf.clear_references()
								end,
							})
						end

						if vim.g.logging_level == "debug" then
							local msg = string.format("Language server %s started!", client.name)
							vim.notify(msg, vim.log.levels.DEBUG, {
								title = "Nvim-config",
							})
						end
					end

					local capabilities = require("cmp_nvim_lsp").default_capabilities()

					-- required by nvim-ufo
					capabilities.textDocument.foldingRange = {
						dynamicRegistration = false,
						lineFoldingOnly = true,
					}

					-- For what diagnostic is enabled in which type checking mode, check doc:
					-- https://github.com/microsoft/pyright/blob/main/docs/configuration.md#diagnostic-settings-defaults
					-- Currently, the pyright also has some issues displaying hover documentation:
					-- https://www.reddit.com/r/neovim/comments/1gdv1rc/what_is_causeing_the_lsp_hover_docs_to_looks_like/

					if utils.executable("pyright") then
						local new_capability = {
							-- this will remove some of the diagnostics that duplicates those from ruff, idea taken and adapted from
							-- here: https://github.com/astral-sh/ruff-lsp/issues/384#issuecomment-1989619482
							textDocument = {
								publishDiagnostics = {
									tagSupport = {
										valueSet = { 2 },
									},
								},
								hover = {
									contentFormat = { "plaintext" },
									dynamicRegistration = true,
								},
							},
						}
						local merged_capability = vim.tbl_deep_extend("force", capabilities, new_capability)

						lspconfig.pyright.setup({
							cmd = { "delance-langserver", "--stdio" },
							on_attach = custom_attach,
							capabilities = merged_capability,
							settings = {
								pyright = {
									-- disable import sorting and use Ruff for this
									disableOrganizeImports = true,
									disableTaggedHints = false,
								},
								python = {
									analysis = {
										autoSearchPaths = true,
										diagnosticMode = "workspace",
										typeCheckingMode = "standard",
										useLibraryCodeForTypes = true,
										-- we can this setting below to redefine some diagnostics
										diagnosticSeverityOverrides = {
											deprecateTypingAliases = false,
										},
 -- Highlight todo, notes, etc in comments
										-- inlay hint settings are provided by pylance?
										inlayHints = {
											callArgumentNames = "partial",
											functionReturnTypes = true,
											pytestParameters = true,
											variableTypes = true,
										},
									},
								},
							},
						})
					else
						vim.notify("pyright not found!", vim.log.levels.WARN, {
							title = "Nvim-config",
						})
					end

					if utils.executable("ruff") then
						require("lspconfig").ruff.setup({
							on_attach = custom_attach,
							capabilities = capabilities,
							init_options = {
								-- the settings can be found here: https://docs.astral.sh/ruff/editors/settings/
								settings = {
									organizeImports = true,
								},
							},
						})
					end

					-- Disable ruff hover feature in favor of Pyright
					vim.api.nvim_create_autocmd("LspAttach", {
						group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", {
							clear = true,
						}),
						callback = function(args)
							local client = vim.lsp.get_client_by_id(args.data.client_id)
							-- vim.print(client.name, client.server_capabilities)

							if client == nil then
								return
							end
							if client.name == "ruff" then
								client.server_capabilities.hoverProvider = false
							end
						end,
						desc = "LSP: Disable hover capability from Ruff",
					})

					if utils.executable("ltex-ls") then
						lspconfig.ltex.setup({
							on_attach = custom_attach,
							cmd = { "ltex-ls" },
							filetypes = { "text", "plaintex", "tex", "markdown" },
							settings = {
								ltex = {
									language = "en",
								},
							},
							flags = {
								debounce_text_changes = 300,
							},
						})
					end

					if utils.executable("clangd") then
						lspconfig.clangd.setup({
							on_attach = custom_attach,
							capabilities = capabilities,
							filetypes = { "c", "cpp", "cc" },
							flags = {
								debounce_text_changes = 500,
							},
						})
					end

					-- set up vim-language-server
					if utils.executable("vim-language-server") then
						lspconfig.vimls.setup({
							on_attach = custom_attach,
							flags = {
								debounce_text_changes = 500,
							},
							capabilities = capabilities,
						})
					else
						vim.notify("vim-language-server not found!", vim.log.levels.WARN, {
							title = "Nvim-config",
						})
					end

					-- set up bash-language-server
					if utils.executable("bash-language-server") then
						lspconfig.bashls.setup({
							on_attach = custom_attach,
							capabilities = capabilities,
						})
					end

					-- settings for lua-language-server can be found on https://luals.github.io/wiki/settings/
					if utils.executable("lua-language-server") then
						lspconfig.lua_ls.setup({
							on_attach = custom_attach,
							settings = {
								Lua = {
									runtime = {
										-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
										version = "LuaJIT",
									},
									hint = {
										enable = true,
									},
								},
							},
							capabilities = capabilities,
						})
					end

					-- Change diagnostic signs.
					fn.sign_define("DiagnosticSignError", {
						text = "🆇",
						texthl = "DiagnosticSignError",
					})
					fn.sign_define("DiagnosticSignWarn", {
						text = "⚠️",
						texthl = "DiagnosticSignWarn",
					})
					fn.sign_define("DiagnosticSignInfo", {
						text = "ℹ️",
						texthl = "DiagnosticSignInfo",
					})
					fn.sign_define("DiagnosticSignHint", {
						text = "",
						texthl = "DiagnosticSignHint",
					})

					-- global config for diagnostic
					diagnostic.config({
						underline = false,
						virtual_text = false,
						signs = true,
						severity_sort = true,
					})

					-- lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
					--   underline = false,
					--   virtual_text = false,
					--   signs = true,
					--   update_in_insert = false,
					-- })

					-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
					lsp.handlers["textDocument/hover"] = lsp.with(vim.lsp.handlers.hover, {
						border = "rounded",
					})
				end,
			})
		end,
	},
	{
		"p00f/clangd_extensions.nvim",
		lazy = true,
		config = function() end,
		opts = {
			inlay_hints = {
				inline = false,
			},
			ast = {
				-- These require codicons (https://github.com/microsoft/vscode-codicons)
				role_icons = {
					type = "",
					declaration = "",
					expression = "",
					specifier = "",
					statement = "",
					["template argument"] = "",
				},
				kind_icons = {
					Compound = "",
					Recovery = "",
					TranslationUnit = "",
					PackExpansion = "",
					TemplateTypeParm = "",
					TemplateTemplateParm = "",
					TemplateParamObject = "",
				},
			},
		},
	},
	{
		"gelguy/wilder.nvim",
		build = ":UpdateRemotePlugins",
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		config = function()
			require("copilot").setup({})
		end,
	},
	{
		"jdhao/whitespace.nvim",
		event = "VeryLazy",
	},
	{
		"sbdchd/neoformat",
		cmd = { "Neoformat" },
	},
	{
		"SirVer/ultisnips",
		dependencies = { "honza/vim-snippets" },
		event = "InsertEnter",
	},
	{
		"luukvbaal/statuscol.nvim",
		opts = {},
		config = function()
			local builtin = require("statuscol.builtin")
			local ffi = require("statuscol.ffidef")
			local C = ffi.C

			-- only show fold level up to this level
			local fold_level_limit = 3
			local function foldfunc(args)
				local foldinfo = C.fold_info(args.wp, args.lnum)
				if foldinfo.level > fold_level_limit then
					return " "
				end

				return builtin.foldfunc(args)
			end

			require("statuscol").setup({
				relculright = false,
				segments = {
					{
						text = { "%s" },
						click = "v:lua.ScSa",
					},
					{
						text = { builtin.lnumfunc, " " },
						click = "v:lua.ScLa",
					},
					{
						text = { foldfunc, " " },
						condition = { true, builtin.not_empty },
						click = "v:lua.ScFa",
					},
				},
			})
		end,
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = "VeryLazy",
		opts = {},
		init = function()
			vim.o.foldcolumn = "1"
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
		end,
		config = function()
			local handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local foldedLines = endLnum - lnum
				local suffix = (" 󰁂  %d"):format(foldedLines)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0

				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end

				local rAlignAppndx = math.max(math.min(vim.opt.textwidth["_value"], width - 1) - curWidth - sufWidth, 0)
				suffix = (" "):rep(rAlignAppndx) .. suffix
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end

			require("ufo").setup({
				fold_virt_text_handler = handler,
			})

			vim.keymap.set("n", "zR", require("ufo").openAllFolds)
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
			vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
			vim.keymap.set("n", "<leader>K", function()
				local _ = require("ufo").peekFoldedLinesUnderCursor()
			end, {
				desc = "Preview folded maps",
			})
		end,
	},
	{
		"chrisbra/unicode.vim",
		event = "VeryLazy",
	}, -- Additional powerful text object for vim, this plugin should be studied
	-- carefully to use its full power
	{
		"wellle/targets.vim",
		event = "VeryLazy",
	}, -- Plugin to manipulate character pairs quickly
	{
		"machakann/vim-sandwich",
		event = "VeryLazy",
	}, -- Add indent object for vim (useful for languages like Python)
	{
		"michaeljsmith/vim-indent-object",
		event = "VeryLazy",
	},
	{ -- Autocompletion
		"iguanacucumber/magazine.nvim",
		-- event = "InsertEnter",
		event = "VeryLazy",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"onsails/lspkind-nvim",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-omni",
			"quangnguyen30192/cmp-nvim-ultisnips",
		},
		config = function()
			-- See `:help cmp`
			local cmp = require("cmp")
			local lspkind = require("lspkind")

			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["ultiSnips#Anon"](args.body)
					end,
				},
				completion = {
					keyword_length = 1,
					completeopt = "menu,noselect",
				},
				view = {
					entries = "custom",
				},
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({
						select = true,
					}),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<Esc>"] = cmp.mapping.close(),
				}),
				sources = {
					{
						name = "nvim_lsp",
					},
					{
						name = "ultisnips",
					},
					{
						name = "luasnip",
					},
					{
						name = "path",
					},
					{
						name = "buffer",
						keyword_length = 2,
					},
				},
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						menu = {
							nvim_lsp = "[LSP]",
							ultisnips = "[US]",
							path = "[Path]",
							buffer = "[Buffer]",
							emoji = "[Emoji]",
							omni = "[Omni]",
						},
						show_labelDetails = true,
						maxwidth = 40,
						ellipsis_char = "...",
					}),
				},
			})

			cmp.setup.filetype("tex", {
				sources = {
					{
						name = "omni",
					},
					{
						name = "ultisnips",
					},
					{
						name = "buffer",
						keyword_length = 2,
					},
					{
						name = "path",
					},
				},
			})
		end,
	},
	{ "folke/tokyonight.nvim", priority = 1000 },
	{ "EdenEast/nightfox.nvim", priority = 1000 },
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = false,
		},
	},
	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({
				n_lines = 500,
			})

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()

			-- Simple and easy statusline.
			--  You could remove this setup call if you don't like it,
			--  and try some other statusline plugin
			local statusline = require("mini.statusline")
			-- set use_icons to true if you have a Nerd Font
			statusline.setup({
				use_icons = vim.g.have_nerd_font,
			})

			-- You can configure sections in the statusline by overriding their
			-- default behavior. For example, here we set the section for
			-- cursor location to LINE:COLUMN
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end

			-- ... and there is more!
			--  Check out: https://github.com/echasnovski/mini.nvim
		end,
	},
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs", -- Sets main module to use for opts
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
			},
			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = {
				enable = true,
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				--  If you are experiencing weird indenting issues, add the language to
				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = {
				enable = true,
				disable = { "ruby" },
			},
		},
		-- There are additional nvim-treesitter modules that you can use to interact
		-- with nvim-treesitter. You should go explore a few and see what interests you:
		--
		--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
		--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
		--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	}, -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
	-- init.lua. If you want these files, they are in the repository, so you can just download them and
	-- place them in the correct locations.
	-- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
	--
	--  Here are some example plugins that I've included in the Kickstart repository.
	--  Uncomment any of the lines below to enable them (you will need to restart nvim).
	--
	-- require 'kickstart.plugins.debug',
	-- require 'kickstart.plugins.indent_line',
	-- require 'kickstart.plugins.lint',
	-- require 'kickstart.plugins.autopairs',
	-- require 'kickstart.plugins.neo-tree',
	-- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps
	-- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
	--    This is the easiest way to modularize your config.
	--
	--  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
	--    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
	-- { import = 'custom.plugins' },
}, {
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
		border = "rounded",
		title = "Plugin Manager",
		title_pos = "center",
	},
	rocks = {
		enabled = false,
	},
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

-- begin my actual insertions to this configuration

local function reveal_in_explorer()
	local path = vim.fn.expand("%:p")
	vim.fn.system('start explorer.exe /select,"' .. path .. '"')
end

_G.reveal_in_explorer = reveal_in_explorer

vim.api.nvim_set_keymap("n", "<Leader>R", "<cmd>lua reveal_in_explorer()<CR>", {
	noremap = true,
	silent = true,
})

vim.api.nvim_set_keymap("n", "<A-Up>", ":move -2<CR>==", {
	noremap = true,
	silent = true,
})
vim.api.nvim_set_keymap("n", "<A-Down>", ":move +1<CR>==", {
	noremap = true,
	silent = true,
})

vim.treesitter.language.register("html", "ejs")
vim.treesitter.language.register("javascript", "ejs")

vim.opt.termguicolors = true
vim.cmd("colorscheme tokyonight-night")
