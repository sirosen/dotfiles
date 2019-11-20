set nomodeline "patch over a vuln
set nocompatible "Use vim mode, ffs

" :hi Visual term=reverse cterm=reverse guibg=Grey

" turn off filetype during plugin setup
filetype off
filetype plugin indent off

""" Remove trailing whitespace from code
"" autocmd FileType c,cpp,java,php,ruby,python,markdown,javascript,json autocmd BufWritePre <buffer> :%s/\s\+$//e
" always highlight trailing whitespace in red while editing
highlight TrailingWhitespace ctermbg=red guibg=red
match TrailingWhitespace /\s\+$/
:autocmd ColorScheme * highlight TrailingWhitespace ctermbg=red guibg=red

if isdirectory($HOME.'/.vim/bundle/vundle')
    " Use Vundle Plugins
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()

    " let Vundle manage Vundle, required
    Plugin 'gmarik/vundle'

    " Colorizing plugins
    Plugin 'morhetz/gruvbox'

    " Python project plugins and completion
    Plugin 'ycm-core/YouCompleteMe'

    " File-Type Plugins
    Plugin 'plasticboy/vim-markdown'
    Plugin 'elzr/vim-json'
    Plugin 'chrisbra/csv.vim'
    Plugin 'cespare/vim-toml'
    Plugin 'rdolgushin/groovy.vim'
    Plugin 'Glench/Vim-Jinja2-Syntax'

    " Linting pluins
    "   Plugin 'scrooloose/syntastic'
    "   Plugin 'ambv/black'
    Plugin 'w0rp/ale'

    " Git plugins
    Plugin 'tpope/vim-fugitive'

    " Utility plugins
    Plugin 'vim-airline/vim-airline'
    Plugin 'vim-airline/vim-airline-themes'
    " Plugin 'scrooloose/nerdtree'

    call vundle#end()
endif

if ($GOROOT != "")
    " Add support for GO Lang highlighting
    set runtimepath+=$GOROOT/misc/vim
endif

" NERDTree settings
" if isdirectory($HOME.'/.vim/bundle/nerdtree')
"     let NERDTreeIgnore = ['\.pyc$']
" endif

" YouCompleteMe
let g:ycm_autoclose_preview_window_after_insertion = 1

" airline settings
if isdirectory($HOME.'/.vim/bundle/vim-airline')
    let g:airline_theme='solarized'
    set laststatus=2
endif

" vim-markdown settings
let g:vim_markdown_folding_disabled=1

" vim-json settings
let g:vim_json_syntax_conceal = 0

" Solarized gvim
"if isdirectory($HOME.'/.vim/bundle/solarized') && has('gui_running')
"    colorscheme solarized
"endif
"if &diff
"    colorscheme desert
"endif

" Soft tabs, 4-ist mode
set tabstop=4 shiftwidth=4 expandtab
au FileType ruby,json,yml,yaml setl sw=2 sts=2
set wrap
set textwidth=79
autocmd FileType gitcommit set textwidth=70
" incremental search for ease
set incsearch
" use undofiles and turn off swapfiles
set undodir=~/.vim/undodir
set undofile
set noswapfile
" show line position
set ruler
" turn off netrw banner
let g:netrw_banner = 0
" turn plugins and indentation on (off for plugin setup)
filetype plugin indent on
syntax enable

" colors
set termguicolors
" let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
" let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
" let g:gruvbox_termcolors=16
" let g:gruvbox_italic=1
" let g:gruvbox_contrast_light="medium"
let g:gruvbox_contrast_dark="hard"
set background=dark
colorscheme gruvbox

augroup diff_ft
  au!
  autocmd BufNewFile,BufRead *.diff  set textwidth=0
augroup END

augroup yml_ft
  au!
  autocmd BufNewFile,BufRead *.yml set tabstop=2 shiftwidth=2
  autocmd BufNewFile,BufRead *.yaml set tabstop=2 shiftwidth=2
augroup END

"augroup pyerb_ft
"  au!
"  autocmd BufNewFile,BufRead *.py.erb  set filetype=python
"  autocmd BufNewFile,BufRead *.py.erb  let g:syntastic_python_checkers = [ ]
"augroup END

augroup onc_ft
  au!
  autocmd BufNewFile,BufRead *.onc  set filetype=json
augroup END

" ALE conf
let g:ale_fixers = {
\  '*': [],
\  'python': ['isort', 'black'],
\  'json': ['jq'],
\}
let g:airline#extensions#ale#enabled = 1
hi ALEStyleError guibg=yellow

augroup py_ft
  au!
  autocmd BufNewFile,BufRead *.py if !empty(findfile("\.\_\_py\_autoformat", ".;")) | let g:ale_fix_on_save = 1 | set textwidth=88 | endif
  autocmd BufNewFile,BufRead *.py set foldnestmax=1 foldlevel=1 foldmethod=indent
augroup END

" make <leader>n in normal mode jump to ALENext
" default leader=\
nmap <silent> <leader>n :ALENext<cr>
nmap <silent> <leader>f :ALEFix<cr>
