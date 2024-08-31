-- init.lua

-- :help nvim-defaults
vim.g.mapleader = '\\'
vim.cmd.colorscheme('vim')
vim.opt.swapfile = false
vim.opt.cursorline = true
vim.opt.linebreak = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.foldlevelstart = 0
vim.opt.completeopt = 'menuone,preview'
vim.opt.path:append '**'
vim.opt.hlsearch = false
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- vim.g.netrw_preview = 1 -- split horizontally
-- vim.g.netrw_alto = 0 -- split to the right
-- vim.g.netrw_banner = 0

vim.cmd.helptags('ALL')
-- vim.cmd [[
--   silent! helptags ALL
-- ]]

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
