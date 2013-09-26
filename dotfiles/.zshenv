export DOTFILES_HOME=~/.dotfiles
# https://github.com/sstephenson/rbenv/issues/369#issuecomment-22200587
if [ -x /usr/libexec/path_helper ]; then
  PATH=''
  eval `/usr/libexec/path_helper -s`
fi
