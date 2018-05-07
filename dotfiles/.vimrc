" Basics
set nocompatible " choose no compatibility with legacy vi

" Pathogen: Load vim plugins
execute pathogen#infect()

" Vim-Markdown
let g:vim_markdown_folding_disabled=1


" EasyAlign
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)


" Localvimrc
let g:localvimrc_reverse = 1 " 1: Load files in order from current dir up to root, 0: Other way
let g:localvimrc_count   = 1 " 1: Load only files in the current directory
let g:localvimrc_ask     = 0

filetype plugin indent on  " Turns on filetype detection, filetype plugins, and filetype indenting
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
" set clipboard=unnamed " Only useful for GUI?
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
"set textwidth=100
set timeoutlen=1000
set title
set ttyfast

let mapleader = "," " Set mapleader


" Visual
if $VIM_LIGHT_MODE == "1"
  set background=light
  colorscheme github
else
  set background=dark
  colorscheme distinguished
end

highlight Pmenu    ctermfg=87  ctermbg=238 guifg=Lightgreen guibg=grey10
highlight PmenuSel ctermfg=237 ctermbg=255 guibg=DarkGrey

" http://stackoverflow.com/a/13731714
let &colorcolumn="80,".join(range(100,999),",")


" Syntastic
let g:syntastic_quiet_warning = 0
let g:syntastic_mode_map = { 'mode': 'passive' }
let g:syntastic_check_on_open = 1
let g:syntastic_enable_balloons = 0

let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_json_checkers=['jsonlint']

" Ruby checker
let g:syntastic_ruby_checkers = ['mri']
" let g:syntastic_ruby_rubocop_exec = ['./bin/rubocop']

" JavaScript checker
let g:syntastic_javascript_checkers = ['jshint']

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
nnoremap <leader>ss :SyntasticCheck<CR>


" Fugitive
nnoremap <leader>gss :Gstatus<CR>
let g:fugitive_github_domains = ['github.com', 'github.wdf.sap.corp']


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
" let g:ag_prg = 'ag -Q --vimgrep' " Enables literal search which disables regex search
nnoremap <leader>ff :Ag<space>

" nnoremap <leader>ff :Ag<Space>
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


" Call search-and-replace with args
function! ExternalSearchAndReplace(args)
  let cmd = "search-and-replace " . a:args
  echom system(cmd)
endfun
command! -nargs=1 SearchAndReplace call ExternalSearchAndReplace(<q-args>)
nnoremap <leader>RE :SearchAndReplace<space>


" Call refactoring tool quote_cleaner
function! ExternalQuoteCleaner()
  let file_path = expand('%:p')
  let cmd = "quote-cleaner-file " . file_path
  echom system(cmd)
  :e " load file w/ changes
endfun
nnoremap <leader>RQC :call ExternalQuoteCleaner()<CR>


" CtrlP
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_max_files = 0
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif
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

" Colorizer
let g:colorizer_auto_filetype='css,sass,scss'


" GitGutter
let g:gitgutter_eager = 0
let g:gitgutter_realtime = 0
nmap <Leader>ha <Plug>GitGutterStageHunk
nmap <Leader>hu <Plug>GitGutterRevertHunk


" ZoomWin
let g:zoomwin_localoptlist = [] " Performance tweak. Turning off local var storage
nnoremap <C-W>z :call ZoomWin()<cr>


" Running Tests
function! VipeStrategy(cmd)
  call vipe#push(a:cmd)
endfunction
let g:test#custom_strategies = {'vipe': function('VipeStrategy')}
let g:test#strategy = 'vipe'
nnoremap <leader>tf :TestFile<CR>
nnoremap <leader>ts :TestSuite<CR>
nnoremap <leader>tn :TestNearest<CR>
nnoremap <leader>rr :call vipe#peek()<CR>


" NERDTree
let NERDTreeShowHidden = 1
let NERDTreeMinimalUI=1
" Doesnt work right now
" let NERDTreeStatusline = ""
nnoremap <leader>ntt :NERDTreeToggle<CR>
nnoremap <leader>ntr :NERDTreeFind<CR>

let NERDTreeIgnore=['\.swp$', '\.git',  '\.sass-cache', '\.DS_Store']


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


" JS Beautify (JS, JSON, JSX, CSS, HTML, XML)
" https://github.com/maksimr/vim-jsbeautify
if has("autocmd")
  " For visualmode when selecting an area
  autocmd FileType javascript vnoremap <buffer>  <c-f> :call RangeJsBeautify()<cr>
  autocmd FileType json vnoremap <buffer> <c-f> :call RangeJsonBeautify()<cr>
  autocmd FileType jsx vnoremap <buffer> <c-f> :call RangeJsxBeautify()<cr>
  autocmd FileType javascript.jsx vnoremap <buffer> <c-f> :call RangeJsxBeautify()<cr>
  autocmd FileType html vnoremap <buffer> <c-f> :call RangeHtmlBeautify()<cr>
  autocmd FileType xml vnoremap <buffer> <c-f> :%!xmllint --format %<cr>
  autocmd FileType erb vnoremap <buffer> <c-f> :call RangeHtmlBeautify()<cr>
  autocmd FileType css vnoremap <buffer> <c-f> :call RangeCSSBeautify()<cr>
  " https://robots.thoughtbot.com/5-useful-tips-for-a-better-commit-message
  autocmd Filetype gitcommit setlocal spell textwidth=72
  autocmd BufRead,BufNewFile *.handlebars,*.hbs set ft=html syntax=handlebars
end

let g:config_Beautifier = {}
let g:config_Beautifier['js'] = {}
let g:config_Beautifier['js'].path = '~/.vim/bundle-deps/js-beautify/js/lib/beautify.js'
let g:config_Beautifier['js'].indent_style = 'space'
let g:config_Beautifier['js'].indent_size = 2
let g:config_Beautifier['js'].max_preserve_newlines = 2
let g:config_Beautifier['json'] = g:config_Beautifier['js']
let g:config_Beautifier['html'] = {}
let g:config_Beautifier['html'].path = '~/.vim/bundle-deps/js-beautify/js/lib/beautify-html.js'
let g:config_Beautifier['html'].indent_style = 'space'
let g:config_Beautifier['html'].indent_size = 2
let g:config_Beautifier['html'].max_preserve_newlines = 1
let g:config_Beautifier['jsx'] = {}
let g:config_Beautifier['jsx'].path = '~/.vim/bundle-deps/js-beautify/js/lib/beautify.js'
let g:config_Beautifier['jsx'].indent_style = 'space'
let g:config_Beautifier['jsx'].indent_size = 2
let g:config_Beautifier['jsx'].max_preserve_newlines = 2
let g:config_Beautifier['jsx'] = {}
let g:config_Beautifier['css'] = {}
let g:config_Beautifier['css'].path = '~/.vim/bundle-deps/js-beautify/js/lib/beautify-css.js'
let g:config_Beautifier['css'].indent_style = 'space'
let g:config_Beautifier['css'].indent_size = 2
let g:config_Beautifier['css'].max_preserve_newlines = 3


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
  autocmd BufNewFile,BufRead *.jsbeautifyrc set filetype=json

  " Use Rspec/Impl switcher for ruby projects
  autocmd Filetype ruby nnoremap <leader>. :call OpenTestAlternate()<CR>
endif


" Custom mappings
" Allow saving of files as sudo when I forgot to start vim using sudo.
" http://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
cnoremap w!! %!sudo tee > /dev/null %

" Define a command to make it easier to use
" USAGE: :QFDo %s/foo/bar/
"        :QFDo %s//bar/        # If "foo" is selected
command! -nargs=+ QFDo call QFDo(<q-args>)

" Function that does the work
function! QFDo(command)
    " Create a dictionary so that we can
    " get the list of buffers rather than the
    " list of lines in buffers (easy way
    " to get unique entries)
    let buffer_numbers = {}
    " For each entry, use the buffer number as
    " a dictionary key (won't get repeats)
    for fixlist_entry in getqflist()
        let buffer_numbers[fixlist_entry['bufnr']] = 1
    endfor
    " Make it into a list as it seems cleaner
    let buffer_number_list = keys(buffer_numbers)

    " For each buffer
    for num in buffer_number_list
        " Select the buffer
        exe 'buffer' num
        " Run the command that's passed as an argument
        exe a:command
        " Save if necessary
        update
    endfor
endfunction
