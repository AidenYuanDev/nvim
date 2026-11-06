return {
	"hrsh7th/nvim-cmp",
	opts = function(_, opts)
		local compare = require("cmp.config.compare")
		local kinds = require("cmp.types").lsp.CompletionItemKind
		local symbol_kinds = {
			[kinds.Variable] = true,
			[kinds.Field] = true,
			[kinds.Property] = true,
			[kinds.Constant] = true,
		}

		-- Pascal is case-insensitive, and Result is implicit in every function
		local cache = { buf = nil, tick = nil, words = nil }
		local function buffer_words()
			local buf = vim.api.nvim_get_current_buf()
			local tick = vim.api.nvim_buf_get_changedtick(buf)
			if cache.buf ~= buf or cache.tick ~= tick then
				local words = { result = true }
				for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
					for word in line:gmatch("[%a_][%w_]*") do
						words[word:lower()] = true
					end
				end
				cache = { buf = buf, tick = tick, words = words }
			end
			return cache.words
		end

		-- pascal: symbols used in this file > snippets > everything else
		local function rank(entry)
			if symbol_kinds[entry:get_kind()] and buffer_words()[entry:get_word():lower()] then
				return 1
			end
			return entry.source.name == "luasnip" and 2 or 3
		end

		local function pascal_snippet_first(a, b)
			if vim.bo.filetype ~= "pascal" then
				return nil
			end
			local ra, rb = rank(a), rank(b)
			if ra ~= rb then
				return ra < rb
			end
		end

		opts.sorting = {
			priority_weight = 2,
			comparators = {
				compare.offset,
				compare.exact,
				pascal_snippet_first,
				compare.score,
				compare.recently_used,
				compare.locality,
				compare.kind,
				compare.sort_text,
				compare.length,
				compare.order,
			},
		}
		return opts
	end,
}
