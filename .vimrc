let mapleader = ' '
" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

colorscheme elflord

call plug#begin()

Plug 'prabirshrestha/vim-lsp'

call plug#end()

set number
set relativenumber
set colorcolumn=80





if executable('clangd')
	au User lsp_setup call lsp#register_server({
		\ 'name': 'clangd',
		\ 'cmd': {server_info->['clangd']},
		\ 'allowlist': ['c', 'cpp'],
		\ })
endif


function! s:on_lsp_buffer_enabled() abort
	setlocal omnifunc=lsp#complete
	setlocal signcolumn=yes
	if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
	nmap <buffer> gd <plug>(lsp-definition)
	nmap <buffer> gs <plug>(lsp-document-symbol-search)
	nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
	nmap <buffer> gr <plug>(lsp-references)
	nmap <buffer> gi <plug>(lsp-implementation)
	nmap <buffer> gt <plug>(lsp-type-definition)
	nmap <buffer> <leader>rn <plug>(lsp-rename)
	nmap <buffer> <leader>d <plug>(lsp-document-diagnostics)
	nmap <buffer> K <plug>(lsp-hover)
	nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
	nnoremap <buffer> <expr><c-d> lsp#scroll(-4)
	inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-x><C-o>"

	let g:lsp_format_sync_timeout = 1000
	autocmd! BufWritePre *.c,*.cpp,*.h call execute('LspDocumentFormatSync')

 endfunction

augroup lsp_install
	au!
        " call s:on_lsp_buffer_enabled only for registered servers
	autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
