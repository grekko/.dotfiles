" Basics
set nocompatible " choose no compatibility with legacy vi
filetype off     " required!

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

Plugin 'gmarik/vundle'                " Vundle, the plug-in manager for Vim
Plugin 'AKurilin/matchit.vim'         " extended % matching for HTML, LaTeX, and many other languages
Plugin 'JazzCore/ctrlp-cmatcher'      " CtrlP C matching extension
Plugin 'Keithbsmiley/rspec.vim'       " Better rspec syntax highlighting for Vim
Plugin 'Lokaltog/vim-distinguished'   " A dark vim color scheme for 256-color terminals
Plugin 'SirVer/ultisnips'             " The ultimate snippet solution for Vim
Plugin 'airblade/vim-gitgutter'       " A Vim plugin which shows a git diff in the gutter (sign column) and stages/reverts hunks.
Plugin 'bkad/CamelCaseMotion'         " A vim script to provide CamelCase motion through words
Plugin 'bling/vim-airline'            " lean & mean status/tabline for vim that's light as air
Plugin 'ecomba/vim-ruby-refactoring'  " Refactoring tool for Ruby in vim!
Plugin 'elzr/vim-json'                " A better JSON for Vim: distinct highlighting of keywords vs values
Plugin 'endel/vim-github-colorscheme' " A vim colorscheme based on Github's syntax highlighting.
Plugin 'ervandew/supertab'            " Perform all your vim insert mode completions with Tab
Plugin 'kchmck/vim-coffee-script'     " CoffeeScript support for vim
Plugin 'kien/ctrlp.vim'               " Fuzzy file, buffer, mru, tag, etc finder
Plugin 'lukaszb/vim-web-indent'       " JavaScript Indent : Javascript indenter
Plugin 'rking/ag.vim'                 " Vim plugin for the_silver_searcher, 'ag'
Plugin 'scrooloose/nerdtree'          " A tree explorer plugin for vim.
Plugin 'scrooloose/syntastic'         " Syntax checking hacks for vim
Plugin 'slim-template/vim-slim'       " slim syntax highlighting for vim
Plugin 'tpope/vim-fugitive'           " a Git wrapper so awesome, it should be illegal
Plugin 'tpope/vim-rails'              " Ruby on Rails power tools
Plugin 'tpope/vim-surround'           " Quoting/Parenthesizing made simple
Plugin 'vim-ruby/vim-ruby'            " Vim/Ruby Configuration Files
Plugin 'vim-scripts/Align'            " Help folks to align text, eqns, declarations, tables, etc
Plugin 'vim-scripts/IndexedSearch'    " Show Match 123 of 456 /search term/ in Vim searches. By Yakov Lerner.
Plugin 'vim-scripts/L9'               " l9 is a Vim-script library, which provides some utility
                                      " functions and commands for programming in Vim.
Plugin 'vim-scripts/YankRing.vim'     " Maintains a history of previous yanks, changes and deletes
Plugin 'regedarek/ZoomWin'            " Zoom in/out of windows (toggle between one window and multi-window)
Plugin 'tomtom/tcomment_vim'          " An extensible & universal comment vim-plugin that also handles embedded filetypes


" Testing
Plugin 'luan/vipe'

filetype plugin indent on                    " Turns on filetype detection, filetype plugins, and filetype indenting
                                             " all of which add nice extra features to whatever language you're using
if has("syntax")
  syntax on
end


set nocursorcolumn
set nocursorline
" syntax sync minlines=256
syntax sync minlines=50

set autoindent " automatic indentation after newline
set autowriteall " http://vim.wikia.com/wiki/Auto_save_files_when_focus_is_lost
set backspace=2
set backupdir=~/.vim/backup
set directory=~/.vim/backup
set encoding=utf-8 " Set encoding
set expandtab
set foldmethod=manual " Folding settings
set hidden
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set lazyredraw
set list listchars=tab:\ \ ,trail:·
set matchpairs+=<:> " http://vim.1045645.n5.nabble.com/Highlighting-matching-angle-brackets-lt-gt-td1188629.html
set modelines=0 " http://www.techrepublic.com/blog/it-security/turn-off-modeline-support-in-vim/
set nomodeline
set norelativenumber
set nowrap " wrap lines
set number " show line numbers
set pastetoggle=<F10>
set ruler
set scrolloff=5
set shell=/bin/bash
set shiftwidth=2
set showbreak=↪
set showcmd
set sidescroll=1
set sidescrolloff=20
set smartcase
set softtabstop=2
set statusline=File:\ %F\ Line:\ %4l/%L/%P\ %3b
set synmaxcol=128
set tabstop=2
set tags=tags;/
set textwidth=200
set timeoutlen=1000
set title
set ttyfast

let mapleader = "," " Set mapleader


" Visual
set background=dark
try
  colorscheme distinguished
catch
  colorscheme desert
endtry

set guifont=Meslo\ LG\ M\ DZ\ for\ Powerline:h12
highlight Pmenu    ctermfg=87  ctermbg=238 guifg=Lightgreen guibg=grey10
highlight PmenuSel ctermfg=237 ctermbg=255 guibg=DarkGrey

" http://stackoverflow.com/questions/2447109/\
" showing-a-different-background-colour-in-vim-past-80-characters
let &colorcolumn="80,".join(range(120,999),",")


" Syntastic
let g:syntastic_quiet_warning = 0
let g:syntastic_ruby_checkers = ['mri', 'rubocop']
let g:syntastic_mode_map = { 'mode': 'passive' }

let g:syntastic_enable_balloons = 0
let g:syntastic_check_on_open = 1
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_json_checkers=['jsonlint']

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
nnoremap <leader>ss :SyntasticCheck<CR>


" Vim-JSON
let g:vim_json_syntax_conceal = 0


" Syntastic Colors
highlight SyntasticErrorSign   ctermfg=124 ctermbg=0 guifg=#af0000 guibg=black
highlight SyntasticErrorLine   ctermfg=124 ctermbg=0 guifg=#af0000 guibg=black
highlight SyntasticWarningSign ctermfg=64  ctermbg=0 guifg=#5f5f00 guibg=black

function! ToggleColorscheme()
  if g:darkcolorscheme == 1
    colorscheme github
    set background=light
    let g:darkcolorscheme = 0
    echo "Light colorscheme enabled"
  else
    colorscheme distinguished
    set background=dark
    let g:darkcolorscheme = 1
    echo "Dark colorscheme enabled"
  endif
endfunction

let g:darkcolorscheme = 1
nnoremap <F1> :call ToggleColorscheme()<CR>


" Yankring
nnoremap <silent> <F11> :YRShow<CR>


" CamelCaseMotion
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e


" Ag
nnoremap <leader>ff :Ag<Space>
" Search for the word under the cursor
nnoremap <leader>fh yiw:Ag <C-R>"<CR>


" Trying to fix regexp performance issues
if version >= 704
  set regexpengine=1
end


" Airline
let g:airline_theme='powerlineish'
let g:airline#extensions#tabline#enabled = 1     " Enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename


" Buffer management
" inspired by: https://joshldavis.com/2014/04/05/vim-tab-madness-buffers-vs-tabs/
nnoremap ]b :bnext<CR>     " Move to the next buffer
nnoremap [b :bprevious<CR> " Move to the previous buffer
nnoremap <leader>bq :bp <BAR> bd! #<CR>
nnoremap <leader>bl :ls<CR>


" TComment
noremap <C-C> :TComment<cr>


" Configure navigation keys
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>


" Splits
nnoremap <leader>sh :vsplit<CR>
nnoremap <leader>sv :split<CR>
" http://robots.thoughtbot.com/post/48275867281/vim-splits-move-faster-and-more-naturally
set splitbelow
set splitright


" UltiSnips
let g:UltiSnipsExpandTrigger = "<C-E>"
let g:UltiSnipsSnippetDirectories = ["my-ultisnips"]


" copy paste
vnoremap <leader>cop "*y


" save of file
nnoremap SS :w<CR>


" Remove trailing whitespace
function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun


" CtrlP
let g:ctrlp_working_path_mode = 'ra' " Use the nearest .git directory as the cwd
let g:ctrlp_max_files = 0
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --skip-vcs-ignores --hidden -g ""'
" Check if ctrlp-c is compiled.
if filereadable($HOME . "/.vim/bundle/ctrlp-cmatcher/autoload/fuzzycomt.so")
  let g:ctrlp_match_func = { 'match' : 'matcher#cmatch' }
else
  echom "Missing compiled version of 'CtrlP C-Matcher'"
endif

nnoremap <leader>pp :CtrlP<CR>
nnoremap <leader>pm :CtrlPBufTag<CR>


" Align
vnoremap <leader>a :Align =<CR>


" Ruby Refactoring
" Default Bindings
" nnoremap <leader>rap  :RAddParameter<cr>
" nnoremap <leader>rcpc :RConvertPostConditional<cr>
" nnoremap <leader>rel  :RExtractLet<cr>
" vnoremap <leader>rec  :RExtractConstant<cr>
" vnoremap <leader>relv :RExtractLocalVariable<cr>
" nnoremap <leader>rit  :RInlineTemp<cr>
" vnoremap <leader>rrlv :RRenameLocalVariable<cr>
" vnoremap <leader>rriv :RRenameInstanceVariable<cr>
" vnoremap <leader>rem  :RExtractMethod<cr>
" (r)eplace (h)ash(r)ocket
nnoremap <leader>rhr :%s/:\([^ ]*\)\(\s*\)=>/\1:/gc<CR>
nnoremap <leader>rtw :%s/\s\+$//<CR>
nnoremap <leader>rrev :%!vim-filter-reverse<CR>


" Vim Diff
set diffopt=vertical


" Custom commands / productivity
" Fast escape of insert mode: http://learnvimscriptthehardway.stevelosh.com/chapters/10.html
inoremap jk <esc>
" inoremap jk <esc>


" Unbind Ex mode
" http://www.bestofvim.com/tip/leave-ex-mode-good/
nnoremap Q <nop>


" Barbaric Mode: Force yourself not using esc in insert mode..

function! BarbaricModeOn()
  inoremap <esc> <nop>
  nnoremap <Up>    <Nop>
  nnoremap <Down>  <Nop>
  nnoremap <Left>  <Nop>
  nnoremap <Right> <Nop>
endfunc

function! BarbaricModeOff()
  inoremap <esc> <esc>
  nnoremap <Up>  <up>
  nnoremap <Down> <down>
  nnoremap <Left>  <left>
  nnoremap <Right> <right>
endfunc

function! BarbaricModeToggle()
  if g:barabaric_mode == 1
    call BarbaricModeOff()
    let g:barabaric_mode = 0
    echo 'Turned barbaric mode OFF: You can use the arrow keys again champ.'
  else
    let g:barabaric_mode = 1
    call BarbaricModeOn()
    echo 'Turned barbaric mode ON: You are on your own now..'
  endif
endfunc
nnoremap <F7> :call BarbaricModeToggle()<CR>

let g:barabaric_mode = 1
call BarbaricModeOn()



" Quickly kill/reset current Search
" http://www.bestofvim.com/tip/switch-off-current-search/
nnoremap <silent> <CR> :nohlsearch<CR>


" GitGutter
let g:gitgutter_eager = 0
let g:gitgutter_realtime = 0


" ZoomWin
let g:zoomwin_localoptlist = [] " Performance tweak. Turning off local var storage


" Running Tests
nnoremap <leader>rt :call RunTestFile()<cr>


" NERDTree
let NERDTreeShowHidden = 1
let NERDTreeMinimalUI=1
" Doesnt work right now
" let NERDTreeStatusline = ""
nnoremap <leader>ntt :NERDTreeToggle<CR>
nnoremap <leader>ntr :NERDTreeFind<CR>


" Switching between Production and Test code
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction

function! AlternateForCurrentFile()
  let current_file = expand("%")
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec

  if going_to_spec
    return AlternateProbableSpecFile(current_file)
  else
    return AlternateProbableImplFile(current_file)
  endif
endfunction

function! AlternateProbableSpecFile(impl_file)
  let in_app_dir = match(a:impl_file, '^app') != -1
  if in_app_dir
    return AlternateFileAddSpecSuffix(substitute(a:impl_file, '^app/', 'spec/', ''))
  else
    return AlternateFileAddSpecSuffix(substitute(a:impl_file, '^', 'spec/', ''))
  end
endfunction

function! AlternateProbableImplFile(spec_file)
  let rails_impl_file = AlternateFileRemoveSpecSuffix(substitute(a:spec_file, '^spec', 'app', ''))
  let basic_impl_file = AlternateFileRemoveSpecSuffix(substitute(a:spec_file, '^spec/', '', ''))
  if filereadable(rails_impl_file)
    return rails_impl_file
  else
    return basic_impl_file
  endif
endfunction

function! AlternateFileRemoveSpecSuffix(file)
  return substitute(a:file, '_spec\.rb$', '.rb', '')
endfunction

function! AlternateFileAddSpecSuffix(file)
  return substitute(a:file, '\.rb$', '_spec\.rb', '')
endfunction

" SuperTab
" let g:SuperTabMappingForward='<c-space>'
let g:SuperTabMappingBackward='<s-tab>'


" Remember last location in file
if has("autocmd")
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif

  " http://robots.thoughtbot.com/5-useful-tips-for-a-better-commit-message
  autocmd Filetype gitcommit setlocal spell textwidth=72

  " Remove trailing whitespace from all files
  " http://stackoverflow.com/questions/356126/how-can-you-automatically-remove-trailing-whitespace-in-vim
  autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

  " Thorfile, Rakefile and Gemfile are Ruby
  autocmd BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,config.ru} set ft=ruby

  " Make vim aware of json filetype
  autocmd BufRead,BufNewFile *.json set filetype=json

  " Use Rspec/Impl switcher for ruby projects
  autocmd Filetype ruby nnoremap <leader>. :call OpenTestAlternate()<CR>
endif


" Custom mappings
" Allow saving of files as sudo when I forgot to start vim using sudo.
" http://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
cnoremap w!! %!sudo tee > /dev/null %

" ---------------
" Tests
" ---------------
function! RunTestFile(...)
  if a:0
    let command_suffix = a:1
  else
    let command_suffix = ""
  endif

  " Run the tests for the previously-marked file.
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
  if in_test_file
    call RunTests(expand("%") . command_suffix)
  else
    call RunTests('')
  end
endfunction

function! RunNearestTest()
  let spec_line_number = line('.')
  let s:last_command = ":" . spec_line_number
  call RunTestFile(":" . spec_line_number)
endfunction

function! RunTests(filename)
  :wa

  if a:filename == ''
    call vipe#peek()
    return
  endif

  let command = ''

  if match(a:filename, '\.feature') != -1
    if filereadable("script/features")
      let command = "script/features " . a:filename
    elseif filereadable("Gemfile")
      let command = "bundle exec cucumber " . a:filename
    else
      let command = "cucumber " . a:filename
    end
  else
    if filereadable(".zeus.running_for_vpipe")
      let command = "zeus rspec " . a:filename
    elseif filereadable("Gemfile")
      " HACK: filereadable can not check for .zeus.sock :-/
      " let command = "zeus rspec " . a:filename
      let command = "bundle exec rspec --color " . a:filename
    else
      let command = "rspec --color " . a:filename
    end
  end

  call vipe#push(command)
endfunction
