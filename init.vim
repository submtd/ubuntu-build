
set nocompatible

" set up vim-plug
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'stephpy/vim-php-cs-fixer'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'flazz/vim-colorschemes'
" Plug 'Valloric/YouCompleteMe'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ludovicchabant/vim-gutentags'
Plug 'arnaud-lb/vim-php-namespace'
Plug 'w0rp/ale'
Plug 'lvht/phpcd.vim', { 'for': 'php', 'do': 'composer install' }
call plug#end()

" /**
"  * BASIC SETTINGS
"  **/
" syntax highlighting
syntax enable
" filetype plugin
filetype plugin on
" set the path
set path+=**
" display the wildmenu
set wildmenu
" tabs to spaces
set tabstop=4
set shiftwidth=4
set expandtab
" fix backspace
set backspace=indent,eol,start
" change leader key to comma
let mapleader = ','
" line numbers
set number
" git rid of bells
set noerrorbells visualbell t_vb=
" set terminal colors to 256
set t_CO=256
" colorscheme
colorscheme materialtheme
" search
set hlsearch
set incsearch
nmap <Leader><space> :nohlsearch<cr>
" enable mouse support
set mouse=a

" /**
"  * PLUGIN SETTINGS
"  **/
" ctrl-p
let g:ctrlp_user_command = 'ag %s -l --nocolor -g "" '
let g:ctrlp_match_current_file = 1
let g:ctrlp_lazy_update = 1
let g:ctrlp_extensions = ['tag', 'buffertag']
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
let g:ctrlp_custom_ignore = 'node_modules\DS_Store\|git'
let g:ctrlp_match_window = 'top,order:ttb,min:1,max:30,results:30'
" php-cs-fixer
let g:php_cs_fixer_rules = "@PSR2"
" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='papercolor'
" gutentags
let g:gutentags_cache_dir = '~/.vim/gutentags'
let g:gutentags_ctags_exclude = ['*.css', '*.html', '*.js', '*.json', '*.xml',
                            \ '*.phar', '*.ini', '*.rst', '*.md',
                            \ '*vendor/*/test*', '*vendor/*/Test*',
                            \ '*vendor/*/fixture*', '*vendor/*/Fixture*',
                            \ '*var/cache*', '*var/log*']
" vim-php-namespace
let g:php_namespace_sort_after_insert=1
" ale linting
let g:ale_linters = {
    \   'php': ['php'],
    \}
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0

" /**
"  * MAPPINGS
"  **/
" toggle nerdtree
nmap <C-b> :NERDTreeToggle<CR>
" move to split to the left
nmap <C-h> <C-w><C-h>
" move to split below
nmap <C-j> <C-w><C-j>
" move to split above
nmap <C-k> <C-w><C-k>
" move to split to the right
nmap <C-l> <C-w><C-l>
" create a split to the left
nmap <M-h> :set splitright&<CR>:vsp<CR>
" create a split below
nmap <M-j> :set splitbelow<CR>:sp<CR>
" create a split above
nmap <M-k> :set splitbelow&<CR>:sp<CR>
" create a split to the right
nmap <M-l> :set splitright<CR>:vsp<CR>
" make current split narrower
nmap <S-h> <C-w><lt>
" make current split shorter
nmap <S-j> <C-w>-
" make current split taller
nmap <S-k> <C-w>+
" make current split wider
nmap <S-l> <C-w>>
" open a terminal
nmap <C-t> :copen<CR>:term<CR>i screen -R vim<CR>
tnoremap <C-t> <C-\><C-n>:q<CR>
" jump to definition
map <silent> <Leader>jd :CtrlPTag<cr><C-\>w
" php namespace
function! IPhpInsertUse()
    call PhpInsertUse()
    call feedkeys('a',  'n')
endfunction
autocmd FileType php inoremap <Leader>pnu <Esc>:call IPhpInsertUse()<CR>
autocmd FileType php noremap <Leader>pnu :call PhpInsertUse()<CR>
function! IPhpExpandClass()
    call PhpExpandClass()
    call feedkeys('a', 'n')
endfunction
autocmd FileType php inoremap <Leader>pne <Esc>:call IPhpExpandClass()<CR>
autocmd FileType php noremap <Leader>pne :call PhpExpandClass()<CR>

" /**
"  * AUTO COMMANDS
"  **/
" php-cs-fixer
autocmd BufWritePost *.php silent! call PhpCsFixerFixFile()
" auto source this file
augroup autosourcing
    autocmd!
    autocmd BufWritePost init.vim source %
augroup END
" always put quickfix at bottom
autocmd FileType qf wincmd J

