-- local contextualize = require('contextualize')
-- local ac = require('contextualize.fenv').around_cursor

-- contextualize.keymap({ 'i', 's' }, ':',
--   '<BS><BS><Del><C-o>:lua require("mia.zotero").cite()<Cr>',
--   -- function() require("mia.zotero").cite() end,
--   function() return ac(-2, 0) == '[c]' end,
--   { buffer = true, name = 'Previous word == "cite"' })

-- contextualize.keymap({ 'i', 's' }, ':',
--   '<BS><BS><Del><C-o>:',
--   -- function() require("mia.zotero").cite() end,
--   function() return ac(-2, 0) == '[c]' end,
--   { buffer = true, name = 'Previous word == "cite"' })



local q = vim.treesitter.query.parse('org',
  [[(directive name: (_) @name (#match? @name "^keymap\\[.?(nore)?(map|abbrev)\\]"))]])

local root = vim.treesitter.get_parser():parse()[1]:root()
local node, lnum, line, cmd, args, group, regex
for _, match, _ in q:iter_matches(root, 0, 0, -1) do
  _, node = next(match)
  lnum = node:start()
  line = vim.api.nvim_buf_get_lines(0, lnum, lnum + 1, false)[1]
  cmd, args = line:gmatch '#%+keymap%[(%a+)%]: (.+)'()
  vim.cmd(('%s <buffer> %s'):format(cmd, args))
end

q = vim.treesitter.query.parse('org', [[(directive name: (_) @name (#lua-match? @name "^hlmatch%[(@?[.%a]+)%]"))]])

for _, match, _ in q:iter_matches(root, 0, 0, -1) do
  _, node = next(match)
  lnum = node:start()
  line = vim.api.nvim_buf_get_lines(0, lnum, lnum + 1, false)[1]
  group, regex = line:gmatch '#%+hlmatch%[(@?[.%a]+)%]: (.+)'()
  vim.fn.matchadd(group, regex)
  -- vim.cmd(('%s <buffer> %s'):format(cmd, args))
end

-- (item . (_) @todo (#eq? @todo "TODO"))
-- (item . (_) @preproc (#eq? @preproc "DONE"))



-- org.directive_action(directive_pattern or function (applied to everything) or query, action (function(Directive)))
-- org.directive_action[^keymap]

vim.b.allow_zero_length_folds = true

vim.keymap.set('n', 'K', require 'mia.zotero'.zotero_open, { buffer = true })
vim.keymap.set('n', '\\K', require 'mia.zotero'.zotero_select, { buffer = true })
