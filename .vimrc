" activate pathogen.vim
call pathogen#infect()

" NERDTree
nnoremap <F4> :NERDTreeToggle<CR>
nnoremap <t> :NERDTreeMapOpenInTab<CR>

" open BufExplorer
nnoremap <F5> :BufExplorer<CR>

" make templates work
autocmd BufNewFile * silent! 0r ~/.vim/templates/%:e.template

syntax on                       " syntax highlighting
filetype on                     " try to detect filetypes
filetype plugin indent on       " enable loading indent file for filetype
filetype plugin on              " enable templates

set ic  " ignore case during search
"set cursorline

" Python completion (Ctrl-O-X). Needs: vim >= 7.0, vim-nox.
" Problematic on cygwin.
set ofu=syntaxcomplete#Complete

" Spaces instead of tabs (looks the same in all editors) ...
set expandtab       " insert space(s) when tab key is pressed
set tabstop=4       " number of spaces inserted
set shiftwidth=4    " number of spaces for indentation
" more: http://vim.wikia.com/wiki/Converting_tabs_to_spaces

" highlight tabs and trailing spaces
"set list!
"set listchars=tab:>-,trail:-

" statusline
set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
"              | | | | |  |   |      |  |     |    |
"              | | | | |  |   |      |  |     |    + current
"              | | | | |  |   |      |  |     |       column
"              | | | | |  |   |      |  |     +-- current line
"              | | | | |  |   |      |  +-- current % into file
"              | | | | |  |   |      +-- current syntax in
"              | | | | |  |   |          square brackets
"              | | | | |  |   +-- current fileformat
"              | | | | |  +-- number of lines
"              | | | | +-- preview flag in square brackets
"              | | | +-- help flag in square brackets
"              | | +-- readonly flag in square brackets
"              | +-- rodified flag in square brackets
"              +-- full path to file in the buffer
set laststatus=2

set textwidth=79
set nu          " show line numbers
"set relativenumber
colors delek    " colorscheme
set showmatch   " show matching brackets

" don't bell or blink
set noerrorbells
set vb t_vb=

" paste/nopaste (inluding don't show/show numbers)
nnoremap <F2> :set nu! invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" folding
set foldmethod=manual
inoremap <F9> <C-O>za
nnoremap <F9> za
onoremap <F9> <C-C>za
vnoremap <F9> zf
autocmd BufWinLeave *.* mkview          "save folds
autocmd BufWinEnter *.* silent loadview "load folds

"" Perl stuff

" syntax color complex things like @{${"foo"}}
let perl_extended_vars = 1

"
" START Tidy Perl file
"

" Tidy selected lines (or entire file) with _t:
"nnoremap <silent> _t :%!perltidy -q<Enter>
"vnoremap <silent> _t :!perltidy -q<Enter>

"define :Tidy command to run perltidy on visual selection || entire buffer"
command -range=% -nargs=* Tidy <line1>,<line2>!perltidy

"run :Tidy on entire buffer and return cursor to (approximate) original position"
fun DoTidy()
    let l = line(".")
    let c = col(".")
    :Tidy
    call cursor(l, c)
endfun

"shortcut for normal mode to run on entire buffer then return to current line"
au Filetype perl nmap _t :call DoTidy()<CR>

"shortcut for visual mode to run on the the current visual selection"
au Filetype perl vmap _t :Tidy<CR>

"
" STOP Tidy Perl file
"

" insert Perl variable dumping stuff
imap <F8> use Data::Dumper;<CR>print Dumper 

" insert Perl script boiler plate
imap <F3> #!/usr/bin/perl<CR>use strict;<CR>use warnings;<CR>

" Check syntax: \l
command PerlLint !perl -c %
nnoremap <leader>l :PerlLint<CR>
" Fix errors: :w => :make => :copen => :cn | :cp
set makeprg=perl\ -c\ -MVi::QuickFix\ %
set errorformat+=%m\ at\ %f\ line\ %l\.
set errorformat+=%m\ at\ %f\ line\ %l

" Comments are important

highlight Comment term=bold ctermfg=white

" Enable spell checking
"set spell

" Move through search results of
" :helpgrep PATTERN
" :vimgrep /PATTERN/ FILES...
nmap <silent> <RIGHT>           :cnext<CR>
nmap <silent> <RIGHT><RIGHT>    :cnfile<CR><C-G>
nmap <silent> <LEFT>            :cprev<CR>
nmap <silent> <LEFT><LEFT>      :cpfile<CR><C-G>
