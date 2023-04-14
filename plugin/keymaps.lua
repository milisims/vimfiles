-- STANDARD KEYMAPS
local cmap = function(...) vim.keymap.set('c', ...) end
local xmap = function(...) vim.keymap.set('x', ...) end
local nmap = function(...) vim.keymap.set('n', ...) end
local tmap = function(...) vim.keymap.set('t', ...) end
local omap = function(...) vim.keymap.set('o', ...) end
local imap = function(...) vim.keymap.set({ 'i', 's' }, ...) end
local map = function(...) vim.keymap.set({ 'n', 'x', 'o' }, ...) end

local remap = { remap = true }
local silent = { silent = true }
-- local cmd = function(a) end
local cmd = function(c) return ('<Cmd>%s<Cr>'):format(c) end

local dotrepeat = function(func, keymap)
  return function()
    vim.fn['repeat#set'](keymap)
    return func()
  end
end

nmap('<F5>', cmd('update|mkview|edit|TSBufEnable highlight'))
nmap('<F8>', cmd('w|so%'))
xmap('s', ':s//g<Left><Left>')
cmap('!', '<C-]>!')

tmap("<Plug>(termLeave)", "<C-\\><C-n>:let b:last_mode = 'n'<Cr>", silent)
tmap("<Plug>(term2nmode)", "<C-\\><C-n>:let b:last_mode = 't'<Cr>", silent)

tmap('<C-h>', '<Plug>(term2nmode)<C-w>h', remap)
tmap('<C-j>', '<Plug>(term2nmode)<C-w>j', remap)
tmap('<C-k>', '<Plug>(term2nmode)<C-w>k', remap)
tmap('<C-l>', '<Plug>(term2nmode)<C-w>l', remap)
tmap('<C-^>', '<Plug>(term2nmode)<C-^>', remap)
tmap('<C-\\>', '<Plug>(term2nmode)<C-w>p', remap)
tmap('<Esc>', '<Plug>(termLeave)', remap)
tmap('<M-n>', '<Plug>(termLeave)', remap)

tmap("<C-Space>", "<Space>")
tmap("<S-Space>", "<Space>")

nmap('<F3>', cmd('messages clear'))
nmap('<F4>', cmd('messages'))

local function open_float_after(func)
  return function()
    if func then func() end
    vim.diagnostic.open_float { focusable = false }
  end
end

nmap('\\d', open_float_after(nil))
nmap('[d', open_float_after(vim.diagnostic.goto_prev))
nmap(']d', open_float_after(vim.diagnostic.goto_next))

imap('<C-h>', function() vim.lsp.buf.signature_help { focusable = false } end)


-- lua/mia/repl.lua
nmap('gx', require('mia.repl').send_motion, { expr = true })
xmap('gx', require('mia.repl').send_visual)
nmap('gxl', dotrepeat(require('mia.repl').send_line, 'gxl'))

-- Delete surrounding function, retains arg the cursor is on.
nmap("dsf", function()
  local query = vim.treesitter.query.get(vim.o.filetype, 'textobjects')
  -- local cursor_node = vim.treesitter.get_node()
  local root = vim.treesitter.get_parser():parse()[1]:root()
  local _, lnum, col = unpack(vim.fn.getcurpos())
  lnum, col = lnum - 1, col - 1

  -- Get all the calls and smallest param here
  local calls, param = {}, {}
  for id, node, _ in query:iter_captures(root, 0, lnum, lnum + 1) do
    if query.captures[id]:match('param') and vim.treesitter.is_in_node_range(node, lnum, col) then
      param = node
    elseif query.captures[id]:match('call.outer') and vim.treesitter.is_in_node_range(node, lnum, col) then
      calls[#calls+1] = node
    end
  end

  -- Get the first call that isn't the parameter.  This can't necessarily be
  -- done in the query loop, because we might match calls first.
  local call
  for i = #calls, 1, -1 do
    if calls[i] ~= param then
      call = calls[i]
      break
    end
  end

  if param and call then
    require('nvim-treesitter.ts_utils').update_selection(0, param)
    vim.api.nvim_feedkeys('y', 'nx', true)
    require('nvim-treesitter.ts_utils').update_selection(0, call)
    vim.api.nvim_feedkeys('p', 'nx', true)
  else
    vim.api.nvim_echo({ { 'param or call not found', 'WarningMsg' } }, true, {})
  end
end)

-- <Tab> is mapped in nvim-treesitter config, so to maintain original behavior
-- for <C-i> (using terminals that support it), this is required
--
-- omap('<Tab>', function() require'nvim-treesitter.incremental_selection'.init_selection() end)
nmap('<C-i>', '<C-i>')

nmap('<F9>', function()
  if #vim.treesitter.get_captures_at_cursor() > 0 then
    P(vim.treesitter.get_captures_at_cursor())
  else
    vim.fn.SynStack()
  end
end, { desc = 'Print highlight group list at cursor' })

nmap('<C-;>', 'g;')
nmap('<C-,>', 'g,')
