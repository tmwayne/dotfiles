-- init.lua

-- Plugins to check out
-- - which-key.nvim : displays a popup with possible key bindings of the
--   command you started typing
-- - bufferline.nvim : buffer management
-- - flash.nvim : quickly jump around your files

-- :help nvim-defaults
vim.g.mapleader = '\\'
-- vim.g.colorscheme = 'desert'
vim.opt.swapfile = false
vim.opt.cursorline = true
vim.opt.list = false
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.splitright = true -- open new tables below
vim.opt.splitbelow = true -- or to the right
vim.opt.foldlevelstart = 0
vim.opt.completeopt = 'menuone,preview'
vim.opt.path:append '**'
vim.opt.hlsearch = false -- no highlight search
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- is this needed?
vim.cmd [[
  packadd! matchit " For increased functionality of %
  packadd! termdebug
  packloadall " load all plugins now
  silent! helptags ALL
]]

-- not sure if this is needed for neovim
-- the url parser for gx has bug, remap to this per
-- https://github.com/vim/vim/issues/4738#issuecomment-521506447
-- nmap gx yiW:!open <cWORD><CR> <C-r>" & <CR><CR>

vim.keymap.set('n', 'gk', 'K', {desc = "Runs the program given by 'keywordprg'"})
vim.keymap.set('n', 'K', 'k')
vim.keymap.set('v', 'K', 'k')
vim.keymap.set('n', 'J', 'j')
vim.keymap.set('v', 'J', 'j')

vim.keymap.set('n', '[b', ':bnext<cr>', {silent = true})
vim.keymap.set('n', ']b', ':bprevious<cr>', {silent = true})
vim.keymap.set('n', '[n', ':tabnext<cr>', {silent = true})
vim.keymap.set('n', ']n', ':tabprevious<cr>', {silent = true})

vim.keymap.set('i', '<c-u>', '<esc>gUiwea', {desc = 'Capitalize word'})
vim.keymap.set('n', 'L', 'o<esc>', {desc = 'Insert blank line'})
vim.keymap.set('i', '<c-f>', '<c-x><c-f>', {desc = 'Tab completion'})

-- local configs = require('lspconfig/configs')
-- local util = require('lspconfig/util')
-- local lspconfig = require('lspconfig')
-- local completion = require('completion')
-- local parser_config = require('nvim-treesitter.parsers').get_parser_configs()

-- https://www.internalfb.com/intern/wiki/Development_Environment/Neovim/nvim/#null-ls
-- https://github.com/jose-elias-alvarez/null-ls.nvim (an attempt to reduce
-- the boilerplate required to set up general-purpose language servers and
-- improve performance by removing the need for external processes)
-- local null_ls = require('null-ls')

-- https://www.internalfb.com/intern/wiki/Development_Environment/Neovim/nvim/#telescope
-- https://github.com/nvim-telescope/telescope.nvim (fuzzy finder)
-- require('plenary.filetype').add_file('meta')
-- require('telescope').load_extension('myles') -- fast, internal fuzzy-finder for files
-- require('telescope').load_extension('biggrep') -- picker for our Big Grep Search

-- https://github.com/nvim-telescope/telescope-file-browser.nvim
-- require('telescope').load_extension('file_browser')

-- local builtin = require('telescope.builtin')
-- local file_browser = require('telescope').extensions.file_browser.file_browser
-- vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
-- vim.keymap.set('n', '<leader>fb', file_browser, {})
-- vim.keymap.set('n', '<leader>fB', builtin.buffers, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- https://github.com/nvim-lua/plenary.nvim (helper functions?)
-- local async = require('plenary.async')

-- https://github.com/echasnovski/mini.comment
-- require('mini.comment').setup()

-- https://github.com?echasnovski/mini.surround
-- require('mini.surround').setup()

