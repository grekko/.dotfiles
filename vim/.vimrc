" Basics
set nocompatible                             " choose no compatibility with legacy vi
syntax enable
filetype plugin indent on                    " Turns on filetype detection, filetype plugins, and filetype indenting
                                             " all of which add nice extra features to whatever language you're using
set encoding=utf-8                           " Set encoding
set showcmd
set sh=/bin/bash

set foldmethod=manual                        " Folding settings 
set number                                   " show line numbers
set autoindent                               " automatic indentation after newline
set pastetoggle=<F2>
let mapleader = ","                          " Set mapleader

" Whitespace stuff
set nowrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set list listchars=tab:\ \ ,trail:·

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Font size Zoom
map <c-+> :ZoomIn
map <c--> :ZoomOut

" nowrap toggle
map <F2> :set nowrap!<CR>
set textwidth=200

" Pathogen
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Visual / Must be defined after pathogen
set guifont=Consolas:h12
if has("gui_running")
  set guioptions=egmrt
  colorscheme solarized
  " set background=light
  " colorscheme ir_black
else
  color desert
endif

call togglebg#map("<F9>")


" spell check
map <F3> :setlocal spell spelllang=de_de<CR>
map <F4> :set nospell<CR>


" Statusline
set laststatus=2
" set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
" %b = ascii
" :set statusline=Current:\ %4l\ Total:\ %4L
set statusline=Line:\ %4l/%L/%P\ %3b

" vim php debugger (xdebug)
" nmap <F5> :DbgRun<CR>
" nmap <S-F5> :DbgDetach<CR>
" nmap <F6> :DbgStepInto<CR>
" nmap <F7> :DbgStepOver<CR>
" nmap <F8> :DbgStepOut<CR>
" nmap <F9> :DbgToggleBreakpoint<CR>

" TComment
map <C-C> :TComment<cr>

" Fuzzy Finder
map <C-Space> :FufFile<cr>

" split navigation
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>


" tab navigation
" nmap <c-right> :tabnext<CR>
" nmap <c-left> :tabprevious<CR>

" upAndDown Script mappings
" nmap <C-k> <Plug>upAndDownUp
" nmap <C-j> <Plug>upAndDownDown

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" vim templates
autocmd! BufNewFile * silent! 0r ~/.vim/templates/template.%:e

" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,config.ru}    set ft=ruby

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'
let g:Tex_ViewRule_pdf='Skim'
let g:Tex_SmartKeyQuote=0

" Super Tab Completion
function! Smart_TabComplete()
  let line = getline('.')                         " curline
  let substr = strpart(line, -1, col('.')+1)      " from start to cursor
  let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
  if (strlen(substr)==0)                          " nothing to match on empty string
    return "\<tab>"
  endif
  let has_period = match(substr, '\.') != -1      " position of period, if any
  let has_slash = match(substr, '\/') != -1       " position of slash, if any
  if (!has_period && !has_slash)
    return "\<C-X>\<C-P>"                         " existing text matching
  elseif ( has_slash )
    return "\<C-X>\<C-F>"                         " file matching
  else
    return "\<C-X>\<C-O>"                         " plugin matching
  endif
endfunction

" minitest completion
set completefunc=syntaxcomplete#Complete

" CTags
let Tlist_Ctags_Cmd='/usr/local/bin/ctags'
map <Leader>rt :!ctags --extra=+f -R *<CR><CR>
set tags=tags;/
map <C-D> <C-]>
" map <F4> :w<cr>:TlistUpdate<cr>
" map <F3> :TlistToggle<cr>
let tlist_php_settings = 'php;c:class;f:function;d:constant'  " set the names of flags
let Tlist_File_Fold_Auto_Close = 1                            " close all folds except for current file
let Tlist_GainFocus_On_ToggleOpen = 1                         " make tlist pane active when opened

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

" Allow saving of files as sudo when I forgot to start vim using sudo.
" http://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
cmap w!! %!sudo tee > /dev/null %


"Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup
