scriptencoding utf-8
set nocompatible
filetype off

let mapleader = " "

set rtp+=~/utils/vim

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'systemverilog.vim'
Plugin 'ctrlp.vim'
Plugin 'matchit.zip'
Plugin 'vim-airline/vim-airline'
call vundle#end()
filetype plugin indent on

syntax on
set si
set et
set ts=3
set sw=3


map <C-n> :tabnew<CR>
noremap <C-k> :bnext<CR>
noremap <C-j> :bprev<CR>
"nnoremap <C-m> :w<CR>:make<CR>
map <S-Right> :tn<CR>
map <S-Left> :tp<CR>
map [a :cp<CR>
map [b :cn<CR>
imap <C-n> <ESC>:tabnew<CR>
imap <C-j> <ESC><C-j>
imap <C-k> <ESC><C-k>
inoremap <C-S-n> <C-n>
noremap <C-h> :tabprev<CR>
noremap <C-l> :tabnext<CR>
imap <C-h> <ESC><C-h>
imap <C-l> <ESC><C-l>
imap <Tab> <ESC>==i
inoremap <S-Tab> <Tab>

"Grep word under cursor in current directory
nnoremap <C-g> :execute "vimgrep /" . expand("<cword>") . "/j **" <Bar> cw <CR>
set mouse=a

"Use very magic regexes by default
"nnoremap / /\v

"autocmd  BufNewFile,BufRead *.html noremap <silent> <C-F> :%s/à/\&agrave;/g <Bar> %s/è/\&egrave;/g <Bar> %s/é/\&egrave;/g <Bar> %s/ì/\&igrave;/g <Bar> %s/ò/\&ograve;/g <Bar> %sù/\&ugrave;/g <CR>
"autocmd BufNewFile,BufRead *.html imap <silent> <C-F> <ESC><ESC><C-f>i
set backspace=indent,eol,start  " more powerful backspacing
command -nargs=1 -complete=file Class tabnew | edit <args>.h | sp | edit <args>.cpp
command CDC cd %:p:h
command -nargs=1 Grr vimgrep /<args>/ ** | cw
command PEdit !p4 edit %
command PLogin !p4 login

nnoremap <Leader>pe :PEdit<CR>
nnoremap <Leader>pl :PLogin<CR>
nnoremap <silent> <Leader>/ <C-l>

"Search for visual selection with *
vnoremap * "vy/<C-R>v<CR>
command Home cd $MIPS_HOME
set tags=./.vimtags;
"let g:easytags_always_enabled = 1
"let g:easytags_dynamic_files = 1
let g_easytags_enabled = 0

aug CppFormatting
  au BufNewFile,BufRead *.cpp set formatprg=astyle\ -A2\ -s2\ -j
aug END

autocmd BufRead,BufNewFile *.sv,*.svh set filetype=systemverilog
autocmd BufRead,BufNewFile sim.log set filetype=cmlog
let g:projectManagerFileName = ".vimproject"

set modeline
set number

let g:ctrlp_map = '<C-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_root_markers = 'sys_base'

colorscheme desert
"Highlight comment color
highlight Folded ctermfg=blue cterm=bold
"Vimdiff
highlight DiffAdd cterm=none ctermbg=Green ctermfg=DarkGrey
highlight DiffDelete cterm=none ctermbg=Red ctermfg=DarkGrey
highlight DiffChange cterm=none ctermbg=LightGrey ctermfg=Black
highlight DiffText cterm=bold ctermbg=White ctermfg=Black

set listchars=tab:>.,trail:§
set list

set foldmethod=indent

" gf should not use = or , if run from a wise person
set isfname-=,
set isfname-==
