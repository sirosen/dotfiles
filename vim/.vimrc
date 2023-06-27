set nomodeline "patch over a vuln
set nocompatible "Use vim mode

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
" always show status bar
set laststatus=2
" turn off netrw banner
let g:netrw_banner = 0

if isdirectory($HOME.'/.vim/bundle/vundle')
  " turn off filetype during plugin setup
  filetype off
  filetype plugin indent off
  " Use Vundle Plugins
  set rtp+=~/.vim/bundle/vundle/
  call vundle#rc()

  " let Vundle manage Vundle, required
  Plugin 'gmarik/vundle'

  " Colorizing plugins
  Plugin 'morhetz/gruvbox'

  " Python project plugins and completion
  if v:version >= 900
    Plugin 'github/copilot.vim'
  else
    Plugin 'ycm-core/YouCompleteMe'
  endif

  " File-Type Plugins
  Plugin 'plasticboy/vim-markdown'
  Plugin 'elzr/vim-json'
  Plugin 'chrisbra/csv.vim'
  Plugin 'cespare/vim-toml'
  Plugin 'rdolgushin/groovy.vim'
  Plugin 'Glench/Vim-Jinja2-Syntax'
  Plugin 'habamax/vim-rst'

  " Linting pluins
  Plugin 'w0rp/ale'

  " Editorconfig
  Plugin 'editorconfig/editorconfig-vim'
  " Git plugins
  Plugin 'tpope/vim-fugitive'

  " Utility plugins
  Plugin 'vim-airline/vim-airline'
  Plugin 'vim-airline/vim-airline-themes'

  call vundle#end()
  " turn plugins and indentation on (off for plugin setup)
  filetype plugin indent on
  syntax enable
endif

" plugin settings
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_global_ycm_extra_conf = $HOME.'/.ycm_global_extra_conf.py'
let g:vim_markdown_folding_disabled=1
let g:vim_json_syntax_conceal = 0
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" colors
set termguicolors
" let g:gruvbox_contrast_dark="hard"
set background=dark
colorscheme gruvbox
hi Normal guibg=NONE ctermbg=NONE

" ALE conf
let g:ale_fixers = {'*': [], 'python': ['isort', 'black'], 'json': ['jq'], 'rust': ['rustfmt']}
" isort fails to load pyproject conf when handling stdin without this
"   https://github.com/dense-analysis/ale/issues/2885
let g:ale_python_isort_options = '--settings-path .'
let g:ale_linters = {'*': [], 'python': ['flake8'], 'json': ['jsonlint'], 'rust': ['analyzer']}

" airline config, including  use of ALE
let g:airline#extensions#ale#enabled = 1
let g:airline_left_sep = '»'
let g:airline_right_sep = '«'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.whitespace = 'Ξ'
hi ALEStyleError guibg=yellow


function UseRuffInALE ()
  let b:ale_linters = {'python': ['ruff']}
endfunction

function DisablePyIsort ()
  let b:ale_fixers = {'python': ['black']}
endfunction

function EnableAutoformat ()
  let b:ale_fix_on_save = 1
endfunction

function DisableAutoformat ()
  let b:ale_fixers = {}
endfunction


" allow project-specific 'vimrc'-like config, but without dangerous exrc usage
" inspired a little by vim-IniParser, but reduced to only essentials
function StripWhitespace (string)
  let l:whitespace = " \t\r\n"
  if strlen(a:string) == 0
      return ''
  endif
  let l:startgood = 0
  let l:endgood = strlen(a:string)
  for i in range(strlen(a:string))
    let l:startgood = i
    if match(l:whitespace, a:string[i]) == -1
      break
    endif
  endfor
  for i in range(strlen(a:string) - 1, 0, -1)
    let l:endgood = i
    if match(l:whitespace, a:string[i]) == -1
      break
    endif
  endfor
  return strpart(a:string, l:startgood, l:endgood - l:startgood + 1)
endfunction

function LoadMyVimConfig ()
  let l:confpath = findfile("\.myvim-config", expand('%:p:h') . ";")
  if !empty(l:confpath) && filereadable(l:confpath)
    let l:confdata = readfile(l:confpath)
    for line in l:confdata
        let line = StripWhitespace(line)
        let l:linelen = strlen(line)
        if l:linelen != 0
          let l:eq_index = match(line, "=")
          let l:var = StripWhitespace(strpart(line, 0, l:eq_index))
          let l:val = StripWhitespace(strpart(line, l:eq_index + 1, l:linelen - l:eq_index - 1))

          if l:var == "autoformat"
            if l:val == "on"
              call EnableAutoformat()
            endif
            if l:val == "off"
              call DisableAutoformat()
            endif
          endif
          if l:var == "py_isort"
            if l:val == "off"
              call DisablePyIsort()
            endif
          endif
          if l:var == "py_ruff"
            if l:val == "on"
              call UseRuffInALE()
            endif
          endif
        endif
    endfor
  endif
endfunction


augroup ag_filetype
  au!
  autocmd FileType diff set tw=0
  autocmd FileType ruby,json,yml,yaml,bash,sh setl sw=2 sts=2 tw=0
  autocmd FileType python setl tw=0
  autocmd BufNewFile,BufRead *.onc set filetype=json
  autocmd BufNewFile,BufRead *.painless set filetype=groovy
  autocmd FileType gitcommit set textwidth=70
augroup END


" always highlight trailing whitespace in red while editing
highlight TrailingWhitespace ctermbg=red guibg=red
match TrailingWhitespace /\s\+$/
augroup ag_colorscheme
  au!
  autocmd ColorScheme * highlight TrailingWhitespace ctermbg=red guibg=red
augroup END

augroup ag_bufnew
  au!
  autocmd BufNewFile,BufRead * :call LoadMyVimConfig()
augroup END


" make <leader>n in normal mode jump to ALENext
" default leader=\
nmap <silent> <leader>n :ALENext<cr>
nmap <silent> <leader>f :ALEFix<cr>

if v:version >= 900
  " copilot keybindings
  inoremap <C-l> <Plug>(copilot-next)
  inoremap <C-h> <Plug>(copilot-previous)
else
  " YCM keybindings
  nmap <leader>cl :YcmCompleter GoToDeclaration<cr>
  nmap <leader>cf :YcmCompleter GoToDefinition<cr>
  nmap <leader>cc :YcmCompleter GoToDefinitionElseDeclaration<cr>
endif

" define a nice way to run shfmt
command ShFmt %!shfmt -ci -sr -i 2
