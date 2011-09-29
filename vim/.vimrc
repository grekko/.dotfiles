" Needed on some linux distros.
" see http://www.adamlowe.me/2009/12/vim-destroys-all-other-rails-editors.html
filetype off 
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

set nocompatible

set number
set ruler
syntax on
set textwidth=78
set wm=2

" omnicomplete
filetype plugin on
set ofu=syntaxcomplete#Complete

" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

" creating new split panes

" vim html templates
autocmd! BufNewFile * silent! 0r ~/.vim/templates/html/index.%:e

" vim coffee script auto compile on change
au BufWritePost *.coffee silent CoffeeMake! -b | cwindow

" Bubble single lines
"nmap <C-Up> [e
"nmap <C-Down> ]e
" Bubble multiple lines
"vmap <C-Up> [egv
"vmap <C-Down> ]egv

" Insert newline without entering insert mode
" http://vim.wikia.com/wiki/Insert_newline_without_entering_insert_mode
map <S-Enter> O<Esc>j
map <CR> o<Esc>k


" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

let g:Tex_ViewRule_pdf='Skim'

if has("gui_running")
" no toolbar in gui mode (:
  set guioptions=egmrt
" scheme
  colorscheme ir_black
else
  color desert
endif

" bindings
set pastetoggle=<F2>

" Move selection up/down (add =gv to reindent after move)
":vmap <D-S-Up> :m-2<CR>gv
":vmap <D-S-Down> :m'>+<CR>gv

" Set encoding
set encoding=utf-8

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

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc

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

"inoremap <tab> <C-R>=Smart_TabComplete()<CR>

" Status bar
set laststatus=2

" Without setting this, ZoomWin restores windows in a way that causes
" equalalways behavior to be triggered the next time CommandT is used.
" This is likely a bludgeon to solve some other issue, but it works
set noequalalways

" Set mapleader
let mapleader = ","

" NERDTree configuration
let NERDTreeIgnore=['\.rbc$', '\~$']
map <Leader>n :NERDTreeToggle<CR>

" Command-T configuration
let g:CommandTMaxHeight=20

" ZoomWin configuration
map <Leader><Leader> :ZoomWin<CR>

" CTags
"map <Leader>rt :!ctags --extra=+f -R *<CR><CR>
set tags=tags;/
map <C-D> <C-]>
map <F4> :w<cr>:TlistUpdate<cr>
map <F3> :TlistToggle<cr>
let Tlist_Ctags_Cmd='/usr/local/bin/ctags'
" set the names of flags
let tlist_php_settings = 'php;c:class;f:function;d:constant'
" close all folds except for current file
let Tlist_File_Fold_Auto_Close = 1
" make tlist pane active when opened
let Tlist_GainFocus_On_ToggleOpen = 1


" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

function s:setupWrapping()
  set wrap
  set wm=2
  set textwidth=72
endfunction

function s:setupMarkup()
  call s:setupWrapping()
  map <buffer> <Leader>p :Mm <CR>
endfunction

" make and python use real tabs
au FileType make                                     set noexpandtab
au FileType python                                   set noexpandtab

" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,config.ru}    set ft=ruby

" md, markdown, and mk are markdown and define buffer-local preview
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()

au BufRead,BufNewFile *.txt call s:setupWrapping()

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" Unimpaired configuration
"nmap <C-Up> [e
" Bubble single lines
"nmap <C-Down> ]e
" Bubble multiple lines
"vmap <C-Up> [egv
"vmap <C-Down> ]egv

" Use modeline overrides
set modeline
set modelines=10

" Default color scheme
" color desert

"Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup
