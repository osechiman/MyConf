scriptencoding utf-8

set ai
set autoindent
set autoread
set backspace=indent,eol,start
set bs=2
set clipboard=unnamed,unnamedplus
set cmdheight=2
set confirm
set cursorbind
set cursorline
set encoding=utf-8
set expandtab
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp
set fileformats=unix,dos,mac
set helpheight=999
set hidden
set history=50
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set mouse=
set nobackup
set nocompatible
set noerrorbells
set nomodeline
set noswapfile
set number
set ruler
set scrolloff=8
set shellslash
set shiftwidth=4
set showmatch
set sidescroll=1
set sidescrolloff=16
set smartcase
set smartindent
set softtabstop=4
set suffixes+=.info,.aux,.log,.dvi,.bbl,.out,.o,.lo
set tabstop=4
set tags+=.git/tags
set visualbell t_vb=
set whichwrap=b,s,h,l,<,>,[,]
set wildmenu wildmode=list:longest,full
set wrapscan

" Don't use Ex mode, use Q for formatting
map Q gq

" When doing tab completion, give the following files lower priority.

syntax on
autocmd BufRead APKBUILD set filetype=sh
"dein Scripts-----------------------------
if &compatible
set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.vim/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.vim')
call dein#begin('~/.vim')

" Nomal load
call dein#load_toml('~/.vim/config/plugin.toml', {'lazy': 0})
" Lazy load
call dein#load_toml('~/.vim/config/lazy.toml', {'lazy': 1})

" Required:
    call dein#end()
call dein#save_state()
    endif

    " Required:
    filetype plugin indent on
    syntax enable
    colorscheme molokai

    " If you want to install not installed plugins on startup.
    if dein#check_install()
call dein#install()
    endif
colorscheme molokai

noremap <S-h> ^
noremap <S-j> }
noremap <S-k> {
noremap <S-l> $
imap <C-h> <Left>
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-l> <Right>
" Ctags
noremap <C-]> g<C-]>

" filepath to clipboard
nmap <silent> <C-g> :let @*=expand("%") <bar> echo @* <CR>

" Unite.vim
nnoremap [unite]    <Nop>
nmap     <Space>u [unite]
nnoremap <silent> [unite]c   :<C-u>UniteWithCurrentDir -buffer-name=files buffer file_mru bookmark file<CR>
nnoremap <silent> [unite]b   :<C-u>Unite buffer<CR>

" Git grep
nnoremap [ggrep]    <Nop>
nmap     <Space>g [ggrep]
nnoremap <silent> [ggrep]g   :<C-u>Unite grep/git:<CR>
nnoremap [ggrep]f   :<C-u>Gfind <C-R>"

" Filer.vim
nnoremap [filer]    <Nop>
nmap     <Space>f [filer]
nnoremap <silent> [filer]f   :<C-u>VimFilerTab<CR>

" Open-brower.vim
nnoremap [open]    <Nop>
nmap     <Space>p [open]
nnoremap <silent> [open]o   :<C-u>PrevimOpen<CR>

" Memolist.vim'
nnoremap [memo]    <Nop>
nmap     <Space>m [memo]
nnoremap <silent> [memo]n   :<C-u>MemoNew<CR>
nnoremap <silent> [memo]l   :<C-u>MemoList<CR>
nnoremap <silent> [memo]g   :<C-u>MemoGrep<CR>

" Lightline Scripts-----------------------------
let g:lightline = {
      \ 'active': {
      \   'left': [['mode', 'paste'],
      \            ['fugitive', 'filename']]
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightlineFugitive',
      \   'readonly': 'LightlineReadonly',
      \   'modified': 'LightlineModified',
      \   'filename': 'LightlineFilename'
      \ },
      \ 'separator': {'left': '|', 'right': '>' },
      \ 'subseparator': {'left': '>'}
      \ }

function! LightlineModified()
    if &filetype == "help"
        return ""
    elseif &modified
        return "+"
    elseif &modifiable
        return ""
    else
        return ""
    endif
endfunction

function! LightlineReadonly()
    if &filetype == "help"
        return ""
    elseif &readonly
        return "<-|"
    else
        return ""
    endif
endfunction

function! LightlineFugitive()
    if exists("*fugitive#head")
        let branch = fugitive#head()
        return branch !=# '' ? 'branch:'.branch : ''
    endif
    return ''
endfunction

function! LightlineFilename()
    return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
                \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
                \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction
" Lightline Scripts-----------------------------end

" Workaround Gls-files Scripts-----------------------------
function! Find(regex, find, git_toplevel)
    if (a:regex == "")
        echomsg 'Empty word!'
        return
    endif
    if (a:git_toplevel)
        let l:toplevel = system('git rev-parse --show-toplevel')
        if (v:shell_error)
            echomsg 'Not in a Git repo?'
            return
        endif
        execute 'lcd ' . l:toplevel
    endif
    let l:files = system(a:find . " | grep -E " . shellescape(a:regex))
    if (v:shell_error)
        echomsg 'No matching files.'
        return
    endif
    tabedit
    set filetype=filelist
    silent file [filelist]
    set buftype=nofile
    put =l:files
    normal ggdd
    nnoremap <buffer> <Enter> <C-W>gf
    execute 'autocmd BufEnter <buffer> lcd ' . getcwd()
endfunction
command! -nargs=? Find call Find('<args>', 'find . -type f', 0)
command! -nargs=? Gfind call Find('<args>', 'git ls-files', 0)
command! -nargs=? Gtfind call Find('<args>', 'git ls-files', 1)
" Workaround Gls-files Scripts-----------------------------end

" Clipboard past Scripts-----------------------------
if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif
" Clipboard past Scripts-----------------------------end

" Turn off paste mode when leaving insert
autocmd InsertLeave * set nopaste

" Last space Highlight
augroup HighlightTrailingSpaces
    autocmd!
    autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
    autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
augroup END

" Auto GoLint
auto BufWritePre *.go GoLint
