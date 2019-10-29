" make use of terminal colors
set termguicolors

colorscheme NeoSolarized
set background=dark

set hidden

let mapleader=","
let maplocalleader=","

" use X clipboard
set clipboard=unnamed
set clipboard=unnamedplus

" detect file type for plugins and indentation
filetype plugin indent on
syntax enable

" do not display mode line
set nomodeline

" convert tabs to two spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" text display settings
set wrap
set textwidth=0
set wrapmargin=0
set formatoptions=qrn1
set linebreak
set number
set scrolloff=15

nmap <leader>N :set number!<CR>

" auto-completion for menu commands
set wildmenu
set wildmode=list:longest

" do not use terminal bell, only display visual
set visualbell

" highlight line under cursor
set cursorline

" search settings
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch

" complete % to current file
nnoremap <tab> %
vnoremap <tab> %

" toggle search highlight
nmap <silent><leader>h :set hls!<CR>

" toggle invisible characters
nmap <silent><leader>l :set list!<CR>
set listchars=tab:▸\ ,eol:¬

" fix movement on wrapped lines
nnoremap j gj
nnoremap k gk
nnoremap 0 g0
nnoremap $ g$
" TODO: fix movement on wrapped lines also in visual mode

" TODO: simplify split movement

" auto completion
let g:deoplete#enable_at_startup = 1
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'

inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><s-tab> pumvisible() ? "\<C-p>" : "\<TAB>"

" IDE
let g:LanguageClient_serverCommands = { 'python': ['pyls'] }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> gh :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent>gt :call LanguageClient#textDocument_typeDefinition()<CR>
nnoremap <silent> gr :call LanguageClient_textDocument_references()<CR>
nnoremap <silent> gs :call LanguageClient_textDocument_documentSymbol()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
nnoremap <silent> gf :call LanguageClient_textDocument_formatting()<CR>

" go back
nnoremap gb <C-o>
