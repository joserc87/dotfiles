return {
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		-- ft = "markdown",
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		-- event = {
		--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
		--   -- refer to `:h file-pattern` for more examples
		--   "BufReadPre path/to/my-vault/*.md",
		--   "BufNewFile path/to/my-vault/*.md",
		-- },
		init = function()
			vim.opt_local.conceallevel = 1
			vim.opt_local.concealcursor = ""
		end,

		---@module 'obsidian'
		---@type obsidian.config
		opts = {
			workspaces = {
				{
					name = "brain",
					path = "~/code/braindump/brain",
				},
			},
			daily_notes = {
				folder = "diary",
				template = "daily",
			},
			templates = {
				subdir = "templates",
				date_format = "%B %d, %Y - %A",
				time_format = "%H:%M",
				substitutions = {
					dateiso = function()
						return os.date("%Y-%m-%d")
					end,
					dateid = function()
						return os.date("%Y%m%d")
					end,
				},
			},

			-- completion = {
			--   nvim_cmp = false, -- if using nvim-cmp, otherwise set to false
			--   prepend_note_id = true,
			-- },
			--
			wiki_link_func = function(opts)
				if opts.id == nil then
					return string.format("[[%s]]", opts.label)
				elseif opts.label ~= opts.id then
					return string.format("[[%s|%s]]", opts.id, opts.label)
				else
					return string.format("[[%s]]", opts.id)
				end
			end,

			--- @param title string|?
			--- @return string
			note_id_func = function(title)
				-- Create note IDs with the date as prefix
				-- In this case a note with the title 'My new note' created in new years eve
				-- will be given an ID that looks like '20261231-my-new-note', and therefore the file name '20261231-my-new-note.md'. A note without title created at 10:20pm will be '20261231-2220'
				local suffix = ""
				local date_prefix = tostring(os.date("%Y%m%d"))
				if title ~= nil then
					-- If title is given, transform it into valid file name.
					suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
				else
					suffix = tostring(os.date("%H%M"))
				end
				return date_prefix .. "-" .. suffix
			end,

			--- @param img string
			follow_img_func = function(img)
				-- vim.fn.jobstart { "qlmanage", "-p", img }  -- Mac OS quick look preview
				-- vim.fn.jobstart({"xdg-open", url})  -- linux
				vim.fn.jobstart({ "sxiv", img }) -- linux
				-- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
			end,

			picker = {
				-- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
				name = "telescope.nvim",
				-- Optional, configure key mappings for the picker. These are the defaults.
				-- Not all pickers support all mappings.
				note_mappings = {
					-- Create a new note from your query.
					new = "<C-x>",
					-- Insert a link to the selected note.
					insert_link = "<C-l>",
				},
				tag_mappings = {
					-- Add tag(s) to current note.
					tag_note = "<C-x>",
					-- Insert a tag at the current location.
					insert_tag = "<C-l>",
				},
			},

			mappings = {
				-- Smart action depending on context, either follow link or toggle checkbox.
				["<cr>"] = {
					action = function()
						return require("obsidian").util.smart_action()
					end,
					opts = { buffer = true, expr = true },
				},
			},

			ui = {
				enable = false, -- set to false to disable all additional syntax features
				update_debounce = 200, -- update delay after a text change (in milliseconds)
				-- Define how various check-boxes are displayed
				checkboxes = {
					-- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
					[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
					["x"] = { char = "", hl_group = "ObsidianDone" },
					[">"] = { char = "", hl_group = "ObsidianRightArrow" },
					["~"] = { char = "", hl_group = "ObsidianTilde" },
					["/"] = { char = "󰿠", hl_group = "ObsidianInProgress" },
					-- Replace the above with this if you don't have a patched font:
					-- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
					-- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

					-- You can also add more custom ones...
				},
				external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
				-- Replace the above with this if you don't have a patched font:
				-- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
				reference_text = { hl_group = "ObsidianRefText" },
				highlight_text = { hl_group = "ObsidianHighlightText" },
				tags = { hl_group = "ObsidianTag" },
				hl_groups = {
					-- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
					ObsidianTodo = { bold = true, fg = "#f78c6c" },
					ObsidianDone = { bold = true, fg = "#89ddff" },
					ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
					ObsidianTilde = { bold = true, fg = "#ff5370" },
					ObsidianImportant = { bold = true, fg = "#d73128" },
					ObsidianBullet = { bold = true, fg = "#89ddff" },
					ObsidianRefText = { underline = true, fg = "#c792ea" },
					ObsidianExtLinkIcon = { fg = "#c792ea" },
					ObsidianTag = { italic = true, fg = "#89ddff" },
					ObsidianBlockID = { italic = true, fg = "#89ddff" },
					ObsidianHighlightText = { bg = "#75662e" },
				},
			},
			-- Specify how to handle attachments.
			attachments = {
				-- The default folder to place images in via `:ObsidianPasteImg`.
				-- If this is a relative path it will be interpreted as relative to the vault root.
				-- You can always override this per image by passing a full path to the command instead of just a filename.
				img_folder = "assets/imgs", -- This is the default

				-- Optional, customize the default name or prefix when pasting images via `:ObsidianPasteImg`.
				---@return string
				img_name_func = function()
					-- Prefix image names with timestamp.
					return string.format("%s-", os.time())
				end,

				-- A function that determines the text to insert in the note when pasting an image.
				-- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
				-- This is the default implementation.
				---@param client obsidian.Client
				---@param path obsidian.Path the absolute path to the image file
				---@return string
				img_text_func = function(client, path)
					path = client:vault_relative_path(path) or path
					return string.format("![%s](%s)", path.name, path)
				end,
			},
		},
	},
}
