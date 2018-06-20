" Use Vim settings, rather than Vi settings
set nocompatible

" Check color support
if (&t_Co > 2 || has("gui_running"))
  " Enable syntax highlighting
  syntax on

  " Color scheme
  colorscheme afterglow

  " Enable last used search pattern highlighting
  set hlsearch

  " Enable cursor line highlighting
  set cursorline

  " Enable support for 256 colors
  set t_Co=256

  " Enable overlength line highlighting
  if exists('+colorcolumn')
    set colorcolumn=80
  else
    au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
  endif

  " Enable trailing whitespace hightlighting
  highlight WhitespaceEOL ctermbg=DarkRed
  match WhitespaceEOL /\s\+$/
endif

" Enable mouse support
set mouse=a

" Enable line numbers
set number

" Enable case-insensitive search
set ic

" Enable specific configuration for filetypes
filetype plugin indent on

" Set history size
set history=100

" Enable .viminfo
set viminfo='20,\"50

" Set utf-8 encoding
set encoding=utf-8
set fileencoding=utf-8

" Use two spaces as tab
set tabstop=2 shiftwidth=2 expandtab

" Set swap files directory
set directory=/tmp

" Set backup files directory
set backupdir=/tmp

" Auto reload files when they change
set autoread

" Shortcuts
cab W! w!
cab Q! q!
cab Wq wq
cab Wa wa
cab wQ wq
cab WQ wq
cab W w
cab Q q

"
" Pathogen
"
" Enable pathogen as submodule
runtime bundle/vim-pathogen/autoload/pathogen.vim
" Infect!
execute pathogen#infect()

"
" NERDTree
"
" Map Control-n to toggle NERDTree
map <C-\> :NERDTreeToggle<CR>
" Open NERDTree in new tabs and windows if no command line args set
autocmd VimEnter * if !argc() | NERDTree | endif
autocmd BufEnter * if !argc() | NERDTreeMirror | endif
" Open automatically when vim starts up but no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Close vim when NERDTree is the only window left
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Show hidden files by default
let NERDTreeShowHidden = 1
" Minimal UI
let NERDTreeMinimalUI = 1
" Dir arrows
let NERDTreeDirArrows = 1

"
" Airline
"
" Start airline
let g:airline#extensions#tabline#enabled = 1
" Use powerline fonts
let g:airline_powerline_fonts = 1
" Don't redraw while executing macros
set lazyredraw
" Appear all time
set laststatus=2

"
" Syntastic
"
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"
" NERDCommenter
"
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

"
" Vim-javascript
"
let g:javascript_plugin_jsdoc = 1

"
" Vim-jsx
"
let g:jsx_ext_required = 1

"
" Minimap
"
au BufReadPost,BufNewFile * Minimap
