_G.mia = require('mia')

mia.load('plugin') -- loads all in mia/plugin
require('mia.lazy_init')  -- plugins
require('mia.fold').setup()
mia.load('after')
