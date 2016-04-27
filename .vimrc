scriptencoding utf-8
" vim:set ts=8 sts=2 sw=2 tw=0: (この行に関しては:help modelineを参照)
"
" An example for a Japanese version vimrc file.
" 日本語版のデフォルト設定ファイル(vimrc) - Vim7用試作
"
" Last Change: 07-May-2013.
" Maintainer:  MURAOKA Taro <koron.kaoriya@gmail.com>
"
" 解説:
" このファイルにはVimの起動時に必ず設定される、編集時の挙動に関する設定が書
" かれています。GUIに関する設定はgvimrcに書かかれています。
"
" 個人用設定は_vimrcというファイルを作成しそこで行ないます。_vimrcはこのファ
" イルの後に読込まれるため、ここに書かれた内容を上書きして設定することが出来
" ます。_vimrcは$HOMEまたは$VIMに置いておく必要があります。$HOMEは$VIMよりも
" 優先され、$HOMEでみつかった場合$VIMは読込まれません。
"
" 管理者向けに本設定ファイルを直接書き換えずに済ませることを目的として、サイ
" トローカルな設定を別ファイルで行なえるように配慮してあります。Vim起動時に
" サイトローカルな設定ファイル($VIM/vimrc_local.vim)が存在するならば、本設定
" ファイルの主要部分が読み込まれる前に自動的に読み込みます。
"
" 読み込み後、変数g:vimrc_local_finishが非0の値に設定されていた場合には本設
" 定ファイルに書かれた内容は一切実行されません。デフォルト動作を全て差し替え
" たい場合に利用して下さい。
"
" 参考:
"   :help vimrc
"   :echo $HOME
"   :echo $VIM
"   :version

"---------------------------------------------------------------------------
" サイトローカルな設定($VIM/vimrc_local.vim)があれば読み込む。読み込んだ後に
" 変数g:vimrc_local_finishに非0な値が設定されていた場合には、それ以上の設定
" ファイルの読込を中止する。
if 1 && filereadable($VIM . '/vimrc_local.vim')
  unlet! g:vimrc_local_finish
  source $VIM/vimrc_local.vim
  if exists('g:vimrc_local_finish') && g:vimrc_local_finish != 0
    finish
  endif
endif

"---------------------------------------------------------------------------
" ユーザ優先設定($HOME/.vimrc_first.vim)があれば読み込む。読み込んだ後に変数
" g:vimrc_first_finishに非0な値が設定されていた場合には、それ以上の設定ファ
" イルの読込を中止する。
if 1 && exists('$HOME') && filereadable($HOME . '/.vimrc_first.vim')
  unlet! g:vimrc_first_finish
  source $HOME/.vimrc_first.vim
  if exists('g:vimrc_first_finish') && g:vimrc_first_finish != 0
    finish
  endif
endif

" plugins下のディレクトリをruntimepathへ追加する。
for s:path in split(glob($VIM.'/plugins/*'), '\n')
  if s:path !~# '\~$' && isdirectory(s:path)
    let &runtimepath = &runtimepath.','.s:path
  end
endfor

"---------------------------------------------------------------------------
" 日本語対応のための設定:
"
" ファイルを読込む時にトライする文字エンコードの順序を確定する。漢字コード自
" 動判別機能を利用する場合には別途iconv.dllが必要。iconv.dllについては
" README_w32j.txtを参照。ユーティリティスクリプトを読み込むことで設定される。
" メッセージを日本語にする (Windowsでは自動的に判断・設定されている)
if !(has('win32') || has('mac')) && has('multi_lang')
  if !exists('$LANG') || $LANG.'X' ==# 'X'
    if !exists('$LC_CTYPE') || $LC_CTYPE.'X' ==# 'X'
      language ctype ja_JP.eucJP
    endif
    if !exists('$LC_MESSAGES') || $LC_MESSAGES.'X' ==# 'X'
      language messages ja_JP.eucJP
    endif
  endif
endif
" MacOS Xメニューの日本語化 (メニュー表示前に行なう必要がある)
if has('mac')
  set langmenu=japanese
endif
" 日本語入力用のkeymapの設定例 (コメントアウト)
if has('keymap')
  " ローマ字仮名のkeymap
  "silent! set keymap=japanese
  "set iminsert=0 imsearch=0
endif
" 非GUI日本語コンソールを使っている場合の設定
if !has('gui_running') && &encoding != 'cp932' && &term == 'win32'
  set termencoding=cp932
endif

"---------------------------------------------------------------------------
" メニューファイルが存在しない場合は予め'guioptions'を調整しておく
if 1 && !filereadable($VIMRUNTIME . '/menu.vim') && has('gui_running')
  set guioptions+=M
endif

"---------------------------------------------------------------------------
" Bram氏の提供する設定例をインクルード (別ファイル:vimrc_example.vim)。これ
" 以前にg:no_vimrc_exampleに非0な値を設定しておけばインクルードはしない。
if 1 && (!exists('g:no_vimrc_example') || g:no_vimrc_example == 0)
  if &guioptions !~# "M"
    " vimrc_example.vimを読み込む時はguioptionsにMフラグをつけて、syntax on
    " やfiletype plugin onが引き起こすmenu.vimの読み込みを避ける。こうしない
    " とencに対応するメニューファイルが読み込まれてしまい、これの後で読み込
    " まれる.vimrcでencが設定された場合にその設定が反映されずメニューが文字
    " 化けてしまう。
    set guioptions+=M
    source $VIMRUNTIME/vimrc_example.vim
    set guioptions-=M
  else
    source $VIMRUNTIME/vimrc_example.vim
  endif
endif

"---------------------------------------------------------------------------
" 検索の挙動に関する設定:
"
" 検索時に大文字小文字を無視 (noignorecase:無視しない)
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase

"---------------------------------------------------------------------------
" 編集に関する設定:
"
" タブの画面上での幅
set tabstop=4
" タブをスペースに展開しない (expandtab:展開する)
set noexpandtab
" 自動的にインデントする (noautoindent:インデントしない)
set autoindent
" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start
" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set wrapscan
" 括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
set showmatch
" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
set wildmenu
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM

"---------------------------------------------------------------------------
" GUI固有ではない画面表示の設定:
"
" 行番号を非表示 (number:表示)
set number
" ルーラーを表示 (noruler:非表示)
set ruler
" タブや改行を表示 (list:表示)
set nolist
" どの文字でタブや改行を表示するかを設定
"set listchars=tab:>-,extends:<,trail:-,eol:<
" 長い行を折り返して表示 (nowrap:折り返さない)
set wrap
" 常にステータス行を表示 (詳細は:he laststatus)
set laststatus=2
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=2
" コマンドをステータス行に表示
set showcmd
" タイトルを表示
set title
" helpは日本語を優先して表示
set helplang=ja,en
" 画面を黒地に白にする (次行の先頭の " を削除すれば有効になる)
colorscheme darkblue " (Windows用gvim使用時はgvimrcを編集すること)
"---------------------------------------------------------------------------
" ファイル操作に関する設定:
"
" バックアップファイルを作成しない (次行の先頭の " を削除すれば有効になる)
set nobackup
" swapファイルを作成しない
set noswapfile
" undoファイルを作成しない
set noundofile
" 末尾の空白は自動で削除
autocmd BufWritePre * :%s/\s\+$//ge
" 末尾の空白はハイライトする
augroup HighlightTrailingSpaces
  autocmd!
  autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
augroup END

" .mdファイルはmarkdownファイルとして認識
autocmd BufRead,BufNewFile *.md set filetype=markdown

"---------------------------------------------------------------------------
" ファイル名に大文字小文字の区別がないシステム用の設定:
"   (例: DOS/Windows/MacOS)
"
if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
  " tagsファイルの重複防止
  set tags=./tags,tags
endif

"---------------------------------------------------------------------------
" コンソールでのカラー表示のための設定(暫定的にUNIX専用)
if has('unix') && !has('gui_running')
  let s:uname = system('uname')
  if s:uname =~? "linux"
    set term=builtin_linux
  elseif s:uname =~? "freebsd"
    set term=builtin_cons25
  elseif s:uname =~? "Darwin"
    set term=beos-ansi
  else
    set term=builtin_xterm
  endif
  unlet s:uname
endif

"---------------------------------------------------------------------------
" コンソール版で環境変数$DISPLAYが設定されていると起動が遅くなる件へ対応
if !has('gui_running') && has('xterm_clipboard')
  set clipboard=exclude:cons\\\|linux\\\|cygwin\\\|rxvt\\\|screen
endif

"---------------------------------------------------------------------------
" プラットホーム依存の特別な設定

" WinではPATHに$VIMが含まれていないときにexeを見つけ出せないので修正
if has('win32') && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH = $VIM . ';' . $PATH
endif

if has('mac')
  " Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
  set iskeyword=@,48-57,_,128-167,224-235
endif

"---------------------------------------------------------------------------
" KaoriYaでバンドルしているプラグインのための設定

" autofmt: 日本語文章のフォーマット(折り返し)プラグイン.
set formatexpr=autofmt#japanese#formatexpr()

" clipbordを有効にする
set clipboard=unnamed,autoselect

" tagを使うときの時のキーバインド設定
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <leader><C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" escのキーバインド変更
imap <C-c> <esc>

" いちいちset tagsするのは面倒なのでここで設定
set tags=./tags;

" viminfoは作成しない
set viminfo=

"---------------------------------------------------------------------------
" dein.vimの設定
if &compatible
  set nocompatible
endif

" dein.vimがなければgit clone
if !isdirectory($DEIN_VIM_HOME)
  execute '!git clone https://github.com/Shougo/dein.vim' $DEIN_VIM_HOME
endif

" dein.vimの本体があるパス
set runtimepath^=$DEIN_VIM_HOME

if dein#load_state($DEIN_VIM_PLUGIN_HOME)
  " plugin格納ディレクトリ設定
  call dein#begin(expand($DEIN_VIM_PLUGIN_HOME))

    " dein.vimの本体を最初に読み込む
    call dein#add($DEIN_VIM_HOME)

    " vim:helpの日本語化
    call dein#add('vim-jp/vimdoc-ja')

    " unite.vimの読み込み
    call dein#add('Shougo/unite.vim')

    " snippets系の設定
    " luaがcygwin環境に入っていないと動かないのでエラーが出る場合はapt-cyg使ってinstallしてみる
    if has('lua')
      call dein#add('Shougo/neocomplete', {
        \ 'on_i' : 1,
        \ 'lazy' : 1
        \ })
        "---------------------------------------------------------------------------
        " necompleteの設定
        " AutoComplPopを無効にする
        let g:acp_enableAtStartup = 0
        " neocomplete起動時に有効にする
        let g:neocomplete#enable_at_startup = 1
        " smartcaseを使う
        let g:neocomplete#enable_smart_case = 1
        " 構文の最小値を設定
        let g:neocomplete#sources#syntax#min_keyword_length = 2
        let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

        " 辞書ファイルの設定
        let g:neocomplete#sources#dictionary#dictionaries = {
          \ 'default' : '',
          \ 'vimshell' : $HOME.'/.vimshell_hist',
          \ 'scheme' : $HOME.'/.gosh_completions'
          \ }

        " keywordの設定
        if !exists('g:neocomplete#keyword_patterns')
            let g:neocomplete#keyword_patterns = {}
        endif
        let g:neocomplete#keyword_patterns['default'] = '\h\w*'
        " Plugin key-mappings
        " 補完機能で表示されているリストを一度リセットする時のkeymap
        inoremap <expr><C-g> neocomplete#undo_completion()

        " omni補完設定
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
        autocmd FileType php setlocal omnifunc=phpcomplete#CompleteTags

      " neocompleteが読み込まれた際に読み込む
      call dein#add('Shougo/neosnippet', {
        \ 'on_source' : ['neocomplete'],
        \ 'lazy' : 1
        \ })
      call dein#add('Shougo/neosnippet-snippets', {
        \ 'on_source' : ['neocomplete'],
        \ 'lazy' : 1
        \ })

        "---------------------------------------------------------------------------
        " snippets系の設定
        " Plugin key-mappings.
        " 補完候補の上で以下のkey-mapをすると反映される
        imap <C-k> <Plug>(neosnippet_expand_or_jump)
        smap <C-k> <Plug>(neosnippet_expand_or_jump)
        xmap <C-k> <Plug>(neosnippet_expand_target)

        " スニペット展開が可能なら展開、通常補完なら補完確定、それ以外は改行
        imap <expr><CR> neosnippet#expandable() ?
          \ '<Plug>(neosnippet_expand_or_jump)' : pumvisible() ?
          \ '<C-y>'. neocomplete#smart_close_popup() : '<CR>'

        " For conceal markers.
        if has('conceal')
          set conceallevel=2 concealcursor=niv
        endif

        " Neosnippetで標準以外の辞書も使うときの設定
        let g:neosnippet#snippets_directory = $DEIN_VIM_PLUGIN_HOME. '/repos/github.com/fatih/vim-go/gosnippets/snippets/go.snip'

    endif

  " markdownをいい感じに編集できるやつ
  call dein#add('plasticboy/vim-markdown', {
    \ 'on_ft' : 'markdown',
    \ 'lazy' : 1})
  " vimからファイルをブラウザで見れるようにする
  call dein#add('kannokanno/previm', {
    \ 'on_source' : ['vim-markdown'],
    \ 'lazy' : 1
    \ })
  call dein#add('tyru/open-browser.vim', {
    \ 'on_source' : ['vim-markdown'],
    \ 'lazy' : 1
    \ })


  " Go言語を触るときはvim-goを読み込む
  call dein#add('fatih/vim-go', {
    \ 'on_ft' : 'go',
    \ 'lazy' : 1
    \ })

  call dein#end()
  call dein#save_state()
endif

" installがまだのものがあればinstallさせる
if dein#check_install()
  call dein#install()
endif

filetype plugin indent on
