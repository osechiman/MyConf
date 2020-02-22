"*****************************************************************************
"" Vim-PLug core
"*****************************************************************************
let g:vimplugged = '~/.vim/plugged'
let vimplug_exists=expand('~/.vim/autoload/plug.vim')

if !filereadable(vimplug_exists)
  if !executable("curl")
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent exec "!\curl -fLo " . vimplug_exists . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

" Plugins will be downloaded under the specified directory.
call plug#begin(expand(vimplugged))

  runtime! config/plugin/vim-go.vim
  runtime! config/plugin/ultisnips.vim
  runtime! config/plugin/YouCompleteMe.vim
  runtime! config/plugin/vim-colorschemes.vim

call plug#end()
