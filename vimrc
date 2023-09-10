set nocompatible " be iMproved, required
filetype off     " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'scrooloose/nerdtree' " file tree
Plugin 'tomtom/tcomment_vim' " comment out code
Plugin 'tpope/vim-surround'  " ys cs ds
Plugin 'tpope/vim-repeat'    " better .
Plugin 'tpope/vim-abolish'   " correct typos
Plugin 'mru.vim' " Most Recently Used :MRU
Plugin 'tmhedberg/matchit' " bracket matching
Plugin 'ConradIrwin/vim-bracketed-paste'

" All of your Plugins must be added before the following line
call vundle#end()         " required
filetype plugin indent on " required
syntax on

" Disable visual bell
set t_vb=

" Don't scroll until cursor is on the first or last line
set scrolloff=0

colorscheme default
highlight Visual ctermfg=NONE ctermbg=None cterm=inverse
highlight Search ctermfg=NONE ctermbg=3 ctermfg=0
highlight Pmenu ctermbg=7
highlight PmenuSel ctermbg=8

set cursorline
" set cursorlineopt=number
highlight LineNr ctermfg=8
highlight CursorLine cterm=None
highlight CursorLineNR cterm=None ctermfg=3

highlight clear SignColumn
" highlight GitGutterAdd    guifg=#009900 ctermbg=NONE ctermfg=2
" highlight GitGutterChange guifg=#bbbb00 ctermbg=NONE ctermfg=grey
" highlight GitGutterDelete guifg=#ff2222 ctermbg=NONE ctermfg=1

highlight Statement ctermfg=3

highlight SpellBad  ctermbg=88
highlight SpellLocal ctermbg=18

set nojoinspaces

set splitright " new split on the right

" time to wait for next key press
set timeoutlen=1000 " vim
set ttimeoutlen=10  " terminal
" set noesckeys

" Search down into subfolders
set path+=**

" Display all matching files when tab completing
set wildmenu

" Prevent comment continuation
au FileType * set fo-=c fo-=r fo-=o

" Set tab width and behavior
set expandtab
set shiftwidth=2
set softtabstop=2

set list lcs=tab:»\ ,trail:·,nbsp:␣,extends:›,precedes:‹
" set showbreak=↪
" hi SpecialKey ctermfg=LightRed

" line numbers
set number
set rnu
noremap <F7> :set rnu!<CR>

" right margin
set textwidth=100

set colorcolumn=101 " cc
highlight ColorColumn ctermbg=235*

" text wrap while typing
set formatoptions+=t
set wrapmargin=0

" toggle color column
noremap <silent><F8> :let &cc = &cc == '' ? '101' : ''<CR>
imap <F8> <C-O><F8>

" make sure seach is highlighted
set hlsearch

" search only open files
set complete-=i complete-=t

let mapleader = "\\"
let maplocalleader = ","

let g:tcomment_mapleader1 = "<C-_>"

" Y
noremap Y y$

" Toggle search highlighting
nnoremap <Leader><Leader> :noh<CR>

" NERDTree
map <C-n> :NERDTreeToggle<CR>

" Toggle spellcheck
nnoremap <F2> :setlocal spell! spelllang=en_us<CR>
imap <F2> <ESC><F2>

" delete trailing whitespace
nnoremap <F3> :%s/\s\+$//e <bar> :noh<CR>
vnoremap <F3> :s/\s\+$//e <bar> :noh<CR>
imap <F3> <ESC><F3>

" Toggle MRU
function! MRUToggle()
  let l:w = bufwinnr('__MRU_Files__')
  if l:w != -1
    exe l:w . 'wincmd w'
    silent! close
  else
    exec ':MRU'
  endif
  echo ':MRU'
endfunction
noremap <silent> <F4> :call MRUToggle()<CR>

" save and make
" map <F5> <F3>:wa<CR>:!make -j`nproc`<CR>
map <F5> <F3>:wa<CR>:!make<CR>
imap <F5> <ESC><F5>
noremap <S-F5> :!make clean<CR>
imap <S-F5> <ESC><S-F5>

" toggle line wrapping
nnoremap <F9> :set wrap! wrap?<CR>
imap <F9> <C-O><F9>

" toggle completion mode
function! ToggleComplete_it()
  if (&complete =~ 'i' || &complete =~ 't')
    set complete-=i complete-=t
  else
    set complete+=i,t
  endif
  echo 'complete=' . &complete
endfunction
noremap <F10> :call ToggleComplete_it()<CR>

" paste without formatting
set pastetoggle=<F12>

" max tabs with -p
set tabpagemax=128
" open file in new tab
nnoremap <C-f> <C-w>gf
" move tabs
nnoremap t<left> :tabm -1<CR>
nnoremap t<right> :tabm +1<CR>
nnoremap <leader>: :tabe<space>
nnoremap <leader>; :vsp<space>

" move in insert mode
inoremap <C-e> <C-O><C-e>
inoremap <C-y> <C-O><C-y>
inoremap <C-d> <C-O><C-d>
inoremap <C-u> <C-O><C-u>

" scroll like ^E and ^Y
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

" comment decoration
let s:cdw = 100 " comment decoration width
function! DecorateComment(c)
  exec 'normal! $'
  let l:len = col('.')
  let l:num = s:cdw-l:len
  let l:last = getline('.')[l:len-1]
  let l:char = nr2char(a:c)
  let l:last_check = (l:last == l:char || l:last == ' ')

  if (l:num > 1 && !l:last_check)
    exec 'normal! A '
    exec 'normal! '.(l:num-1).'A'.l:char
  elseif l:last_check
    if l:num > 0
      exec 'normal! '.l:num.'A'.l:char
    else
      while (col('.') > s:cdw && getchar('.') == l:char)
        exec 'normal! x'
      endwhile
    endif
  endif
endfunction
nnoremap <silent><expr> <leader>c ':call DecorateComment('.getchar().')<CR>'

nnoremap <Leader>o ^yWo<C-r>0

" pretty json
nnoremap <Leader>j :setf json <bar> :%!python -m json.tool<CR>

" open vimrc
nmap <Leader>v :e $MYVIMRC<CR>

