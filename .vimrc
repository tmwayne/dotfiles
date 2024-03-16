"
" ------------------------------------------------------------------------------
" .vimrc
" ------------------------------------------------------------------------------
"
" Tyler Wayne © 2022
"

" VARIABLES {{{

let mapleader = '\'

" }}}

" GENERAL {{{

" set verbose=9
set nocompatible " Disable backwards compatibility with VI
set noswapfile
set encoding=utf-8
set cm=blowfish2 " More secure encryption algo

" }}}

" DISPLAY {{{

" colorscheme desert
set cursorline
set showcmd " Displays commands as they're typed
set nolist wrap linebreak breakat&vim
set splitright splitbelow " Open new tabs below or to the right

set noerrorbells visualbell t_vg= " Turn off the bell
set foldlevelstart=0 " Start with all folds closed

set modeline modelines=1 " Read vim setting in first line

" }}}

" CODE EDITING {{{

syntax on
set autoindent
set tags=.git/tags;
set completeopt=menuone,preview

" }}}

" FILE BROWSING {{{

set path+=**
set wildmenu

" Netrw
let g:netrw_banner=0          " disable annoying banner
let g:netrw_liststyle=3       " tree view
" let g:netrw_altv=1            " open splits to the right
" let g:netrw_browse_split=3  " open files in new tab

" Latex-Suite
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_SmartKeyQuote=0
let g:Imap_FreezeImap=1
let g:Tex_MultipleCompileFormats='pdf,bib'

" }}}

" SEARCH {{{

set nohlsearch " no highlight search
set incsearch " search as characters are entered

" }}}

" DEFAULT TAB SETTINGS {{{

set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

" }}}

" PLUGINS {{{

filetype plugin on
packadd! matchit " For increased functionality of %
packadd! termdebug

" }}}

" MAPPINGS {{{

" Remove mappings
noremap gk K
noremap K k
noremap J j

" Move between buffers
nnoremap <silent> ]b :bprev<CR>
nnoremap <silent> [b :bnext<CR>

" Capitalize word
inoremap <C-u> <esc>gUiwea

" Insert blank line
nnoremap <silent> L o<esc>

" Remap tab completion
inoremap <c-f> <c-x><c-f>

" Remap omni-completion
inoremap <c-@> <c-x><c-o>

" Insert current datestamp
nnoremap <F5> "=strftime("%Y-%m-%d")<CR>p
inoremap <F5> <C-R>=strftime("%Y-%m-%d")<CR>

" Working with xclip
" noremap <F7> :w !xclip<cr><cr>
" vnoremap <F7> "*y
noremap <S-F7> :r !xclip -o<cr>

" }}}
