" Basics
set nocompatible " choose no compatibility with legacy vi
filetype off     " required!

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

Plugin 'AKurilin/matchit.vim'
Plugin 'JazzCore/ctrlp-cmatcher'
Plugin 'Keithbsmiley/rspec.vim'
Plugin 'Lokaltog/vim-distinguished'
Plugin 'SirVer/ultisnips'
Plugin 'airblade/vim-gitgutter'
Plugin 'altercation/vim-colors-solarized'
Plugin 'bkad/CamelCaseMotion'
Plugin 'bling/vim-airline'
Plugin 'ecomba/vim-ruby-refactoring'
Plugin 'elzr/vim-json'
Plugin 'endel/vim-github-colorscheme'
Plugin 'ervandew/supertab'
Plugin 'gmarik/vundle'
Plugin 'kana/vim-textobj-user'
Plugin 'kchmck/vim-coffee-script'
Plugin 'kien/ctrlp.vim'
Plugin 'lukaszb/vim-web-indent'
Plugin 'mattn/webapi-vim'
Plugin 'mileszs/ack.vim'
Plugin 'rhysd/vim-textobj-ruby'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'slim-template/vim-slim'
Plugin 't9md/vim-ruby-xmpfilter'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'vim-ruby/vim-ruby'
Plugin 'vim-scripts/Align'
Plugin 'vim-scripts/IndexedSearch'
Plugin 'vim-scripts/L9'
Plugin 'vim-scripts/YankRing.vim'
Plugin 'vim-scripts/ZoomWin'
Plugin 'vim-scripts/tComment'


" Testing
Plugin 'luan/vipe'

filetype plugin indent on                    " Turns on filetype detection, filetype plugins, and filetype indenting
                                             " all of which add nice extra features to whatever language you're using
if has("syntax")
  syntax on
end


" XMPFilter
nmap <buffer> <F5> <Plug>(xmpfilter-run)
xmap <buffer> <F5> <Plug>(xmpfilter-run)
imap <buffer> <F5> <Plug>(xmpfilter-run)

nmap <buffer> <F4> <Plug>(xmpfilter-mark)
xmap <buffer> <F4> <Plug>(xmpfilter-mark)
imap <buffer> <F4> <Plug>(xmpfilter-mark)


set nocursorcolumn
set nocursorline
" syntax sync minlines=256
syntax sync minlines=50

set autoindent                               " automatic indentation after newline
set autowriteall                             " http://vim.wikia.com/wiki/Auto_save_files_when_focus_is_lost
set backspace=2
set backupdir=~/.vim/backup
set directory=~/.vim/backup
set encoding=utf-8                           " Set encoding
set expandtab
set foldmethod=manual                        " Folding settings
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set lazyredraw
set list listchars=tab:\ \ ,trail:·
set matchpairs+=<:> " http://vim.1045645.n5.nabble.com/Highlighting-matching-angle-brackets-lt-gt-td1188629.html
set number                                   " show line numbers
set pastetoggle=<F10>
set norelativenumber
set ruler
set scrolloff=5
set shell=/bin/bash                               "set shell=/usr/local/bin/zsh\ --interactive
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
set nowrap                                   " wrap lines

let mapleader = ","                          " Set mapleader


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
" Make vim aware of json filetype
autocmd BufRead,BufNewFile *.json set filetype=json


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


" Ack
nnoremap <leader>ff :Ack<Space>
" Using Ag instead of ACK
let g:ackprg = 'ag --nogroup --nocolor --column'
" Search for the word under the cursor
nnoremap <leader>fh yiw:Ack <C-R>"<CR>


" Trying to fix regexp performance issues
if version >= 704
  set regexpengine=1
end


" Airline
let g:airline_theme='powerlineish'


" TComment
map <C-C> :TComment<cr>


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
let g:ctrlp_max_files = 0
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden --depth=4 -g ""'
let g:ctrlp_match_func = { 'match' : 'matcher#cmatch' }

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
inoremap jk <esc>


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
nmap <C-W>z <Plug>ZoomWin


" Running Tests
nnoremap <leader>rt :call RunTestFile()<cr>


" NERDTree
let NERDTreeShowHidden = 1
let NERDTreeMinimalUI=1
" Doesnt work right now
" let NERDTreeStatusline = ""
nnoremap <leader>ntt :NERDTreeToggle<CR>
nnoremap <leader>ntr :NERDTreeFind<CR>

" autocmd hooks
if has("autocmd")

  augroup ruby
    autocmd!
  augroup END

end

" http://robots.thoughtbot.com/5-useful-tips-for-a-better-commit-message
autocmd Filetype gitcommit setlocal spell textwidth=72

" Remove trailing whitespace from all files
" http://stackoverflow.com/questions/356126/how-can-you-automatically-remove-trailing-whitespace-in-vim
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Switching between Production and Test code
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction

function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let spec_dir_prefix = 'spec'
  let in_spec = match(current_file, '^' . spec_dir_prefix . '/') != -1
  let going_to_spec = !in_spec

  if isdirectory('app') != 0
    let lib_or_app = 'app'
  elseif isdirectory('lib') != 0
    let lib_or_app = 'lib'
    let spec_dir_prefix = spec_dir_prefix . '/lib'
  else
    echo 'Found nothing'
  endif

  if going_to_spec
    let new_file = substitute(new_file, '^' . lib_or_app, spec_dir_prefix, '')
    let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
  else
    let new_file = substitute(new_file, '^' . spec_dir_prefix, lib_or_app, '')
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
  endif
  return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<CR>


" Emmet: https://github.com/grekko/emmet-vim
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall


" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,config.ru} set ft=ruby


" SuperTab
" let g:SuperTabMappingForward='<c-space>'
let g:SuperTabMappingBackward='<s-tab>'


" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

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
      let command = "zeus rspec " . a:filename
      " let command = "bundle exec rspec --color " . a:filename
    else
      let command = "rspec --color " . a:filename
    end
  end

  call vipe#push(command)
endfunction
