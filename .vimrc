" source any local functions up front

if has('unix')
  source $HOME/.vim/local_functions.vim
else
  source $HOME\.vim\local_functions.vim
endif

" keep cursor in a reasonable place
set scrolloff=15

" sensible deaults for files
set encoding=utf-8
set ffs=unix " assume *nix line endings

" Converts tabs to spaces of width=2
set expandtab tabstop=2 shiftwidth=2

" cursor can of beyone end of line
set virtualedit=all

" save file when lose focus
set autowrite

" Search & display
set incsearch smartcase hlsearch showmatch

" page down like We're in `more`
"
nnoremap <Space> <C-f>

" move as if everything is a hard wrap
set wrap
nnoremap j gj
nnoremap k gk

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                 SPELLING
set spell spelllang=en_gb

" toggle spellcheck highlighting with F5
map <F5> :call ToggleSpell()<CR>

" next two blocks make sure spelling is initially _off_
hi clear SpellBad
hi clear Spellcap
hi clear SpellLocal
hi clear SpellRare

augroup SpellUnderline
  autocmd!
  autocmd ColorScheme * highlight SpellBad   ctermfg=NONE ctermbg=NONE
  autocmd ColorScheme * highlight SpellCap   ctermfg=NONE ctermbg=NONE
  autocmd ColorScheme * highlight SpellLocal ctermfg=NONE ctermbg=NONE
  autocmd ColorScheme * highlight SpellRare  ctermfg=NONE ctermbg=NONE
augroup END

" accept first match in spell check (insert mode)
inoremap <C-L> <esc>[s1z=`]<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                             FINDNG FILES
filetype plugin on
" tab completion on all files
set path+=**
set wildmenu wildmode=list:full
set autochdir

map <silent> <F8> :call ToggleVExplorer()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                               VIM-PANDOC
let g:pandoc#completion#bib#mode    = 'citeproc'
let g:pandoc#biblio#sources 		    = "ybcg"
let g:pandoc#formatting#textwidth   = 80
"let g:pandoc#formatting#mode 		    = "hA"
let g:pandoc#folding#level 		      = 2
let g:pandoc#folding#fdc		        = 0
let g:pandoc_auto_format            = 1
let g:pandoc_use_bibtool            = 1

" if a build script exists at this level call it using F8
" see: https://github.com/JasmineElm/reports
noremap <silent> <F8> :! ./build -p<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                LIMELIGHT
let g:limelight_conceal_ctermfg     = 'gray'
let g:limelight_conceal_guifg       = 'DarkGray'
let g:limelight_default_coefficient = 0.3
map <leader>w :Limelight<CR>

" turn-on distraction free writing mode for markdown files
au BufNewFile,BufRead *.{md,mdown,mkd,mkdn,markdown,mdwn} call DistractionFreeWriting()

function! DistractionFreeWriting()
    :Limelight
    call lexical#init()
    call litecorrect#init()
    set rulerformat=%#TabLineSel#\ %{WordCount()}%#Statement#\ %m\ %#VisualNOS#\ %l:%c
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                    WORDY
let g:wordy#ring = [
  \ 'weak',
  \ ['being', 'passive-voice', ],
  \ 'business-jargon',
  \ 'weasel',
  \ 'puffery',
  \ ['problematic', 'redundant', ],
  \ ['colloquial', 'idiomatic', 'similies', ],
  \ 'art-jargon',
  \ ['contractions', 'opinion', 'vague-time', 'said-synonyms', ],
  \ 'adjectives',
  \ 'adverbs',
  \ ]

noremap <silent> <F6> :<C-u>NextWordy<cr>
xnoremap <silent> <F6> :<C-u>NextWordy<cr>
inoremap <silent> <F6> <C-o>:NextWordy<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                 VIM-PLUG
if has('unix')
  " set up vimplug automatically on linux
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endif

call plug#begin()
Plug 'https://github.com/vim-pandoc/vim-pandoc'
Plug 'https://github.com/vim-pandoc/vim-pandoc-syntax'
Plug 'junegunn/limelight.vim'           " Distraction free writing
Plug 'ctrlpvim/ctrlp.vim'               " For sensible link insertion
Plug 'reedes/vim-lexical'               " Better spellcheck mappings
Plug 'reedes/vim-litecorrect'           " Better autocorrections
Plug 'reedes/vim-wordy'                 " Weasel words and passive voice
Plug 'tpope/vim-fireplace'              " For Wakatime...
Plug 'vim-pandoc/vim-markdownfootnotes' " proper footnotes using \f \r
Plug 'morhetz/gruvbox'                  " a pretty theme... 
Plug 'wakatime/vim-wakatime'            " quantify...
call plug#end()

" colourscheme mow it's loaded...
colo gruvbox
" explicitly set it to dark 
set bg=dark
