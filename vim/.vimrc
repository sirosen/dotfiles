set nomodeline "patch over a vuln
set nocompatible "Use vim mode

" turn off filetype during plugin setup
filetype off
filetype plugin indent off

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
  Plugin 'w0rp/ale'

  " Git plugins
  Plugin 'tpope/vim-fugitive'

  " Utility plugins
  Plugin 'vim-airline/vim-airline'
  Plugin 'vim-airline/vim-airline-themes'

  call vundle#end()
endif

" YouCompleteMe
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_global_ycm_extra_conf = $HOME.'/.ycm_global_extra_conf.py'

" airline settings
if isdirectory($HOME.'/.vim/bundle/vim-airline')
    " let g:airline_theme='solarized'
    set laststatus=2
endif

" vim-markdown settings
let g:vim_markdown_folding_disabled=1

" vim-json settings
let g:vim_json_syntax_conceal = 0

" Soft tabs, 4-ist mode
set tabstop=4 shiftwidth=4 expandtab
set wrap
set textwidth=79
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
let g:gruvbox_contrast_dark="hard"
set background=dark
colorscheme gruvbox

" ALE conf
let g:ale_fixers = {'*': [], 'python': ['isort', 'black'], 'json': ['jq']}
let g:airline#extensions#ale#enabled = 1
hi ALEStyleError guibg=yellow


function ApplyPythonSettings ()
  " search current dir for .__py_autoformat file which indicates that this project is
  " using autoformatting
  " - expand expands to the dir of the current file
  " - '.' is vimscript string concat
  " - paths ending in ';' get recursive upward search
  " - findfile searches for a file name against a path
  " - empty checks if something is empty (duh)
  " - ! to negate -- looking for a match
  if !empty(findfile("\.__py_autoformat", expand('%:p:h') . ";"))
    let g:ale_fix_on_save = 1
    set textwidth=88
  endif
  " disable isort fixer if the project doesn't use it
  " as many projects are starting to use 'black', but not 'isort', this is useful
  if !empty(findfile("\.__disable_isort", expand('%:p:h') . ";"))
    let b:ale_fixers = {'python': ['black']}
  endif
  " python folding
  set foldnestmax=1 foldlevel=1 foldmethod=indent
endfunction

augroup ag_filetype
  au!
  autocmd FileType python :call ApplyPythonSettings()
  autocmd FileType diff  set textwidth=0
  autocmd FileType ruby,json,yml,yaml setl sw=2 sts=2
  autocmd BufNewFile,BufRead *.onc set filetype=json
  autocmd FileType gitcommit set textwidth=70
augroup END

" always highlight trailing whitespace in red while editing
highlight TrailingWhitespace ctermbg=red guibg=red
match TrailingWhitespace /\s\+$/
augroup ag_colorscheme
  au!
  autocmd ColorScheme * highlight TrailingWhitespace ctermbg=red guibg=red
augroup END


" make <leader>n in normal mode jump to ALENext
" default leader=\
nmap <silent> <leader>n :ALENext<cr>
nmap <silent> <leader>f :ALEFix<cr>
