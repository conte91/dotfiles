scriptencoding utf-8
set nocompatible

filetype off
set rtp+=~/utils/vim
set rtp+=~/dotfiles/vim
set rtp+=~/.vim/bundle/Vundle.vim

let mapleader = " "

try
    call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'
    Plugin 'systemverilog.vim'
    Plugin 'ctrlp.vim'
    Plugin 'tabular'
    Plugin 'matchit.zip'
    Plugin 'vim-airline/vim-airline'
    call vundle#end()
catch /^Vim\%((\a\+)\)\=:E117/ "catch error E117 (function unknown)
    " Just pass if Vundle is not installed
endtry

" Now we can turn our filetype functionality back on
filetype plugin indent on

syntax on
set si
set ts=4
set sw=4


" Move between tabs and buffers with C-<direction>
map <C-n> :tabnew<CR>
noremap <C-k> :bnext<CR>
noremap <C-j> :bprev<CR>
noremap <C-h> :tabprev<CR>
noremap <C-l> :tabnext<CR>
nnoremap <Leader><CR> <ESC>:w<CR>:make<CR>
map <S-Right> :tn<CR>
map <S-Left> :tp<CR>
imap <C-n> <ESC>:tabnew<CR>
imap <C-j> <ESC><C-j>
imap <C-k> <ESC><C-k>
imap <C-h> <ESC><C-h>
imap <C-l> <ESC><C-l>
inoremap <C-S-n> <C-n>
inoremap <S-Tab> <ESC>==i

"Quickfix window: scroll with <L>j, <L>k
nnoremap <Leader>k :cp<CR>
nnoremap <Leader>j :cn<CR>

" Update file
nnoremap <F5> <ESC>:e!<Return>
nnoremap <F6> <ESC>:e!<Return>G
nnoremap <F6><F6> <ESC>:!tail -f %<Return>

"Grep word under cursor in current directory
nnoremap <C-g> :execute "vimgrep /" . expand("<cword>") . "/j **" <Bar> cw <CR>
set mouse=a
set noacd

command RiseVol !mpc volume +5
command LowerVol !mpc volume -5 
imap <ScrollWheelUp> <ESC>:RiseVol<CR><CR>i
map <ScrollWheelUp> :RiseVol<CR><CR>

imap <ScrollWheelDown> <ESC>:LowerVol<CR><CR>i
map <ScrollWheelDown> :LowerVol<CR><CR>
"autocmd  BufNewFile,BufRead *.html noremap <silent> <C-F> :%s/à/\&agrave;/g <Bar> %s/è/\&egrave;/g <Bar> %s/é/\&egrave;/g <Bar> %s/ì/\&igrave;/g <Bar> %s/ò/\&ograve;/g <Bar> %sù/\&ugrave;/g <CR>
"autocmd BufNewFile,BufRead *.html imap <silent> <C-F> <ESC><ESC><C-f>i
set backspace=indent,eol,start  " more powerful backspacing
command -nargs=1 -complete=file Class tabnew | edit <args>.h | sp | edit <args>.cpp
command CDC cd %:p:h
command -nargs=1 Grr vimgrep /<args>/ ** | cw

" Perforce
nnoremap <Leader>pe :PEdit<CR>
nnoremap <Leader>pl :PLogin<CR>
command PEdit !p4 edit %
command PLogin !p4 login

" Grep
nnoremap <Leader>gh :call GrrCWHere()<CR>
nnoremap <Leader>ga :call GrrCWAll()<CR>
nnoremap <Leader>gg :Grr<CR>

" Tag management/source navigation
nnoremap <Leader>tt :call TagGo()<CR>
nnoremap <Leader>tc :call TagCallers()<CR>
nnoremap <Leader>td :call TagDepends()<CR>

nnoremap <silent> <Leader>/ <C-l>

"Search for visual selection with *
vnoremap * "vy/<C-R>v<CR>
command Home cd $MIPS_HOME
set tags=./tags;,tags;
"let g:easytags_always_enabled = 1
"let g:easytags_dynamic_files = 1
"let g_easytags_enabled = 0

"Useful for auto formatting code
aug CppFormatting
  au BufNewFile,BufRead *.cpp set formatprg=astyle\ -A2\ -s2\ -j
aug END

autocmd BufRead,BufNewFile *.sv,*.svh set filetype=systemverilog
let g:projectManagerFileName = ".vimproject"

set modeline
set number

let g:ctrlp_map = '<C-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'

colorscheme desert
"Highlight comment color
highlight Folded ctermfg=blue cterm=bold
"Vimdiff
highlight DiffAdd cterm=none ctermbg=Green ctermfg=DarkGrey
highlight DiffDelete cterm=none ctermbg=Red ctermfg=DarkGrey
highlight DiffChange cterm=none ctermbg=LightGrey ctermfg=Black
highlight DiffText cterm=bold ctermbg=White ctermfg=Black
highlight Search ctermfg=grey ctermbg=darkgrey

set listchars=tab:»\ ,trail:§
set list

set foldmethod=indent

" This to exclude when expanding globs
set wildignore=*.o,*.obj,*.bin,*.so,*.a,*.d

" gf should not use = or , if run from a wise person
set isfname-=,
set isfname-==
"License files
command Beerware r !cat ~/.licenses/beerware
command MIT call LicenseMIT()

