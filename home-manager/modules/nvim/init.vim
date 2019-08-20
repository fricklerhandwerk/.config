" make use of terminal colors
set termguicolors

colorscheme NeoSolarized
set background=light

let mapleader=","
let maplocalleader=","

" detect file type for plugins and indentation
filetype on
filetype plugin on
filetype indent on

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
" TODO: fix edge cases

" TODO: simplify split movement
