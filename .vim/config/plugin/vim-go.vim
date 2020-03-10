Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

let g:go_highlight_structs = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_version_warning = 0

nnoremap [go]    <Nop>
nmap     <Space>g [go]
nnoremap <silent> [go]r   :<C-u>GoRun %<CR>
nnoremap <silent> [go]l   :<C-u>GoLint <C-r>%<CR>
nnoremap <silent> [go]fs  :<C-u>GoFillStruct<CR>
