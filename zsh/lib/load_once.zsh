if [ ! -z $DOTFILES_LOADED ];
 then echo "Dotfiles already loaded. You may be polluting your environment."
else
  export DOTFILES_LOADED=1
fi
