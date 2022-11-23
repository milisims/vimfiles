vim.env.CFGDIR = (vim.env.XDG_CONFIG_HOME or vim.env.HOME)..'/.config/nvim'
vim.env.DATADIR = (vim.env.XDG_DATA_HOME or vim.env.HOME)..'/.local/share/nvim'
vim.cmd 'runtime settings.vim'

require 'mia'

require 'mia.tslib'
require 'mia.fold'

