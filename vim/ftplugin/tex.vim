" Tex specific settings.
setlocal textwidth=72
augroup vimrc_autocmds
  autocmd BufEnter * highlight OverLength ctermbg=darkgrey guibg=#592929
  autocmd BufEnter * match OverLength /\%72v.*/
augroup END
