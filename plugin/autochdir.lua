vim.opt.autochdir = false

local function gitdir(path, bufnr)
  if vim.b[bufnr].autochdir then
    return vim.b[bufnr].autochdir
  elseif path:match '^fugitive' then
    return path:match 'fugitive://(.*)/%.git.*'
  end

  local dir = vim.fn.finddir('.git', path .. ';')
  if dir ~= '' then
    return vim.fn.fnamemodify(dir, ':p'):match '(.*)/%.git/?'
  end
  return vim.fn.fnamemodify(path, ':p:h')
end

local gid = nvim.create_augroup('mia-chdir', { clear = true })
nvim.create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = gid,
  desc = ':lcd into git dir',
  callback = function(ev) vim.cmd.lcd(gitdir(ev.match, ev.buf)) end,
})

nvim.create_autocmd('DirChanged', {
  group = gid,
  pattern = 'window',
  desc = 'manually set autochdir',
  callback = function(ev) vim.b[ev.buf].autochdir = vim.fn.getcwd() end,
})

nvim.create_user_command('FixAutochdir', function()
  vim.b.autochdir = nil
  vim.cmd.lcd(gitdir(vim.fn.expand('%:p'), vim.fn.bufnr()))
end, {})
