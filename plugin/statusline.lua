local ts_statusline = require 'mia.tslib'.statusline
local fugitive_object = vim.fn['fugitive#Object']  ---@type function
local fugitive_head = vim.fn['fugitive#Head']  ---@type function

local obsession_status
obsession_status = function()
  if vim.g.loaded_obsession then
    obsession_status = function() return ' ' .. vim.fn.ObsessionStatus() end
    return obsession_status()
  end
  return ''
end

local modecolors = {
  n = { color = 'stlNormalMode', abbrev = 'n' },
  i = { color = 'stlInsertMode', abbrev = 'i' },
  v = { color = 'stlVisualMode', abbrev = 'v' },
  V = { color = 'stlVisualMode', abbrev = 'V' },
  [''] = { color = 'stlVisualMode', abbrev = 'B' },
  R = { color = 'stlReplaceMode', abbrev = 'R' },
  s = { color = 'stlSelectMode', abbrev = 's' },
  S = { color = 'stlSelectMode', abbrev = 'S' },
  [''] = { color = 'stlSelectMode', abbrev = 'S' },
  c = { color = 'stlTerminalMode', abbrev = 'c' },
  t = { color = 'stlTerminalMode', abbrev = 't' },
  ['-'] = { color = 'stlNormalMode', abbrev = '-' },
  ['!'] = { color = 'stlNormalMode', abbrev = '!' },
}

local function mode_info()
  return modecolors[nvim.get_mode().mode:sub(1, 1)] or { color = 'stlNormalMode', abbrev = '-' }
end

local function hl(text, group, skip_close)
  if not group or not text or text == '' then
    return text and ' ' .. text .. ' ' or ''
  end
  return ('%%#%s# %s %s'):format(group, text, skip_close and '' or '%*')
end

local function gitinfo()
  if vim.g.loaded_fugitive and vim.bo.modifiable then
    local head = fugitive_head()
    return head ~= '' and ('(%s)'):format(head) or ''
  end
  return ''
end

local function dirinfo()
  if vim.bo.filetype == 'help' or vim.bo.buftype == 'nofile' then
    return ''
  end
  if vim.b.term_title then
    return vim.b.term_title
  elseif nvim.buf_get_name(0):match '^fugitive' then
    return gitinfo()
  end
  return gitinfo() .. vim.fn.expand '%:h' .. '/'
end

local function filename()
  local name = nvim.buf_get_name(0)
  if name:match '^fugitive' then
    return ' ' .. fugitive_object(name)
  end
  return ' ' .. vim.fs.basename(name)
end

local function peek()
  ---@diagnostic disable
  local res
  if _G.peek == 'function' then
    res = peek(_G.peek())
  elseif _G.peek == 'table' then
    res = table.concat(_G.peek, ' ')
  elseif _G.peek ~= nil then
    res = tostring(_G.peek)
  end
  return res or ''
  ---@diagnostic enable
end

local function error_info()
  if _G.stl_noerr then  ---@diagnostic disable-line: undefined-field
    return
  end
end

local function cursor_info()
  local digits = math.ceil(math.log10(vim.fn.line '$' + 1))
  local width = '%' .. digits .. '.' .. digits
  return '%2p%% ☰ ' .. ('%sl/%sL '):format(width, width) .. ': %02c'
end

local function encoding()
  local digits = math.ceil(math.log10(vim.fn.line '$' + 1))
  local typeinfo = (' %s[%s]'):format(vim.bo.fileencoding, vim.bo.fileformat)
  return typeinfo .. (' '):rep(14 + 2 * digits - #typeinfo)
end

local function active()
  local mode = mode_info()
  return table.concat {
    hl(mode.abbrev, mode.color),
    hl(dirinfo(), 'stlDirInfo'),
    filename(),
    hl('%m', 'stlModified'),
    peek(),
    '%=',
    ts_statusline(),
    obsession_status(),
    hl(error_info(), 'stlErrorInfo'),
    hl('%y', 'stlTypeInfo'),
    hl(cursor_info(), mode.color),
  }
end

local function inactive()
  return table.concat({ hl(' ', 'SignColumn'), dirinfo(), filename(), '%m %=%y', encoding() }, ' ')
end


_G.Statusline = { active = active, inactive = inactive }

local gid = nvim.create_augroup('mia-statusline', { clear = true })
nvim.create_autocmd('WinLeave', {
  group = gid,
  desc = 'Set inactive statusline',
  callback = function() vim.wo.statusline = '%!v:lua.Statusline.inactive()' end,
})

nvim.create_autocmd({ 'WinEnter', 'BufEnter' }, {
  group = gid,
  desc = 'Set active statusline',
  callback = function() vim.wo.statusline = '%!v:lua.Statusline.active()' end,
})
