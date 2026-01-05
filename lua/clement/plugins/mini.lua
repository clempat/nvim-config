return {
	"mini.nvim",
	on_cat = "general.extra",
	after = function()
		-- Better Around/Inside textobjects
		--
		-- Examples:
		--  - va)  - [V]isually select [A]round [)]paren
		--  - yinq - [Y]ank [I]nside [N]ext [']quote
		--  - ci'  - [C]hange [I]nside [']quote
		--  - vaF  - [V]isually select [A]round [F]unction (treesitter)
		--  - vic  - [V]isually select [I]nside [c]lass (treesitter)
		local spec_treesitter = require('mini.ai').gen_spec.treesitter
		require("mini.ai").setup({
			n_lines = 500,
			custom_textobjects = {
				-- Function definition (treesitter-aware) - use 'F' for function definition
				F = spec_treesitter({ a = '@function.outer', i = '@function.inner' }),
				-- Class (treesitter-aware)
				c = spec_treesitter({ a = '@class.outer', i = '@class.inner' }),
				-- Keep default 'f' for function calls, 'a' for arguments
				-- Add conditional/loop textobjects
				o = spec_treesitter({
					a = { '@conditional.outer', '@loop.outer' },
					i = { '@conditional.inner', '@loop.inner' },
				}),
			},
			-- Enhanced mappings for movement
			mappings = {
				-- Main textobject prefixes
				around = 'a',
				inside = 'i',
				-- Next/last variants for easy navigation
				around_next = 'an',
				inside_next = 'in',
				around_last = 'al',
				inside_last = 'il',
				-- Move cursor to corresponding edge of textobject
				goto_left = 'g[',
				goto_right = 'g]',
			},
		})

		-- Add movement keymaps to replicate nvim-treesitter-textobjects functionality
		-- These use mini.ai's next/previous functionality
		vim.keymap.set('n', ']m', 'anF', { remap = true, desc = 'Next function start' })
		vim.keymap.set('n', '[m', 'alF', { remap = true, desc = 'Previous function start' })
		vim.keymap.set('n', ']]', 'anc', { remap = true, desc = 'Next class start' })
		vim.keymap.set('n', '[[', 'alc', { remap = true, desc = 'Previous class start' })
		
		-- For end movements, we can use goto_right after selecting
		vim.keymap.set('n', ']M', function()
			vim.cmd('normal anF')
			vim.cmd('normal g]')
		end, { desc = 'Next function end' })
		vim.keymap.set('n', '[M', function()
			vim.cmd('normal alF')
			vim.cmd('normal g]')
		end, { desc = 'Previous function end' })
		vim.keymap.set('n', '][', function()
			vim.cmd('normal anc')
			vim.cmd('normal g]')
		end, { desc = 'Next class end' })
		vim.keymap.set('n', '[]', function()
			vim.cmd('normal alc')
			vim.cmd('normal g]')
		end, { desc = 'Previous class end' })
		require("mini.diff").setup({})

		-- Add/delete/replace surroundings (brackets, quotes, etc.)
		--
		-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
		-- - sd'   - [S]urround [D]elete [']quotes
		-- - sr)'  - [S]urround [R]eplace [)] [']
		-- require("mini.surround").setup()
		-- using nvim-surround instead

		-- Simple and easy statusline.
		--  You could remove this setup call if you don't like it,
		--  and try some other statusline plugin
		local statusline = require("mini.statusline")
		-- set use_icons to true if you have a Nerd Font
		statusline.setup({ use_icons = vim.g.have_nerd_font })

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
}
