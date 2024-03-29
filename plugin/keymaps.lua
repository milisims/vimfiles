---@diagnostic disable-next-line: unused-local
local cmap, xmap, nmap, tmap, omap, imap, map = require 'mapfun' 'cxntoim'

local remap = { remap = true }
local silent = { silent = true }
local cmd = function(c) return ('<Cmd>%s<Cr>'):format(c) end

nmap('<F1>', function() nvim.echo({ { require 'mia.tslib'.statusline(math.huge) } }, false, {}) end)
local og = require 'mia.og'
og.gx = og.gx or vim.fn.maparg('gx', 'n', false, true).callback
og.vgx = og.vgx or vim.fn.maparg('gx', 'x', false, true).callback
nmap('<F2>', og.gx)
xmap('<F2>', og.vgx)

nmap('<F3>', cmd 'messages clear')
nmap('<F4>', cmd 'messages')

nmap('<F5>', cmd 'update|mkview|edit|TSBufEnable highlight')
nmap('<F6>', '<cmd>UndotreeToggle<Cr>')

nmap('<F7>', function()
  if vim.bo.fo:match 'a' then
    vim.opt_local.formatoptions:remove 'a'
  else
    vim.opt_local.formatoptions:append 'a'
  end
end, { desc = 'Toggle paragraph autoformat' })

nmap('<F8>', cmd 'w|so%')
nmap('<F10>', function() vim.lsp.inlay_hint(0) end, { desc = 'Toggle inlay hints' })

xmap('gs', ':s//g<Left><Left>')
cmap('!', '<C-]>!')

-- associated with autocmds in lua/mia/autocmds.lua
tmap('<Plug>(termLeave)', "<C-\\><C-n>:let b:last_mode = 'n'<Cr>", silent)
tmap('<Plug>(term2nmode)', "<C-\\><C-n>:let b:last_mode = 't'<Cr>", silent)

tmap('<C-h>', '<Plug>(term2nmode)<C-w>h', remap)
tmap('<C-j>', '<Plug>(term2nmode)<C-w>j', remap)
tmap('<C-k>', '<Plug>(term2nmode)<C-w>k', remap)
tmap('<C-l>', '<Plug>(term2nmode)<C-w>l', remap)
tmap('<C-^>', '<Plug>(term2nmode)<C-^>', remap)
tmap('<C-\\>', '<Plug>(term2nmode)<C-w>p', remap)
tmap('<Esc>', '<Plug>(termLeave)', remap)
tmap('<C-[>', '<C-[>')
tmap('<M-n>', '<Plug>(termLeave)', remap)

tmap('<C-Space>', '<Space>')
tmap('<S-Space>', '<Space>')

local function open_float_after(func)
  return function()
    if func then func() end
    vim.diagnostic.open_float { focusable = false }
  end
end

nmap('\\d', open_float_after(nil))
nmap('[d', open_float_after(vim.diagnostic.goto_prev))
nmap(']d', open_float_after(vim.diagnostic.goto_next))
imap('<C-h>', vim.lsp.buf.signature_help)

-- lua/mia/repl.lua
nmap('gxl', require 'mia.repl'.send_line, { dotrepeat = true })
nmap('gx', require 'mia.repl'.send_motion, { expr = true, dotrepeat = true })
xmap('gx', require 'mia.repl'.send_visual)

-- Delete surrounding function, retains arg the cursor is on.
nmap('dsf', function()
  local query = vim.treesitter.query.get(vim.o.filetype, 'textobjects')
  -- local cursor_node = vim.treesitter.get_node()
  local root = vim.treesitter.get_parser():parse()[1]:root()
  local _, lnum, col = unpack(vim.fn.getcurpos())
  lnum, col = lnum - 1, col - 1

  -- Get all the calls and smallest param here
  local calls, param = {}, {}
  for id, node, _ in query:iter_captures(root, 0, lnum, lnum + 1) do
    if query.captures[id]:match 'param' and vim.treesitter.is_in_node_range(node, lnum, col) then
      param = node
    elseif query.captures[id]:match 'call.outer' and vim.treesitter.is_in_node_range(node, lnum, col) then
      calls[#calls + 1] = node
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
    require 'nvim-treesitter.ts_utils'.update_selection(0, param)
    nvim.feedkeys('y', 'nx', true)
    require 'nvim-treesitter.ts_utils'.update_selection(0, call)
    nvim.feedkeys('p', 'nx', true)
  else
    nvim.echo({ { 'param or call not found', 'WarningMsg' } }, true, {})
  end
end, { dotrepeat = true })

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
