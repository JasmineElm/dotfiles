" source any local functions up front

if has('unix')
  source $HOME/.vim/local_functions.vim
else
  source $HOME\.vim\local_functions.vim
endif

" keep cursor broadly in the center of the screen
set scrolloff=15

" sensible deaults for files
set encoding=utf-8
set ffs=unix " assume *nix line endings

"  TABS AND INDENTS
"
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set shiftround
set autoindent
set complete-=i

set list listchars=tab:»·,trail:·,nbsp:·

" sensible backspace, questionable cursor
set virtualedit=onemore           " cursor can go beyond end of text
set backspace=indent,eol,start    " backspace works across lines

" DISPLAY
set background=dark


" Read and write
set autowrite                     " save file on loss of focus
set autoread                      " if file is modified elsewhere, reload it

" Search & display
set incsearch                     " update searches as type
set hlsearch                      " show previous matches
set ignorecase                    " searches ignore case
set smartcase                     " don't ignore capitals in searches
nnoremap <leader>/ :nohls <enter> "remove highlights 




" page down like We're in `more`
"
nnoremap <Space> <C-f>


set textwidth=79
set colorcolumn=80

" move as if everything is a hard wrap

nnoremap j gj
nnoremap k gk

" markdown folding

let g:markdown_folding = 1
set nofoldenable


set wildmenu                      " tab completion in command mode can override the ruler 

set showmatch "show matching bracket etc.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                 SPELLING
set spell spelllang=en_gb

" toggle spellcheck highlighting with F5
nnoremap <leader>5 :call ToggleSpell()<CR>

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
"                                             MD-IMG-PASTE
autocmd FileType markdown nmap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>
let g:mdip_imgdir = 'attachments'
let g:mdip_imgname = 'image'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                             FINDNG FILES
filetype plugin on
" tab completion on all files
set path+=**
set wildmenu wildmode=list:full
set autochdir

""" NetRW
let g:netrw_liststyle = 1 " Detail View
let g:netrw_sizestyle = "H" " Human-readable file sizes
let g:netrw_banner = 0 " Turn off banner
" Explore in vertical split
nnoremap <Leader>e :Explore! <enter>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                               VIM-PANDOC
let g:pandoc#completion#bib#mode    = 'citeproc'
" let g:pandoc#biblio#sources 		    = "ybcg"
" let g:pandoc#formatting#textwidth   = 80
"let g:pandoc#formatting#mode 		    = "A"
" let g:pandoc#folding#level 		      = 3
" let g:pandoc#folding#mode           = 'stacked'
" let g:pandoc#folding#fdc		        = 0
" let g:pandoc_auto_format            = 1
let g:pandoc_use_bibtool            = 1

" if a build script exists at this level call it using F8
" see: https://github.com/JasmineElm/reports
noremap <leader>b :! ./build -p<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                LIMELIGHT
let g:limelight_conceal_ctermfg     = 'gray'
let g:limelight_conceal_guifg       = 'DarkGray'
let g:limelight_default_coefficient = 0.3
map <leader>w :Limelight!!<CR>

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
noremap <leader>g :<C-u>NextWordy<cr>
xnoremap <leader>g :<C-u>NextWordy<cr>
inoremap <leader>g :<C-o>:NextWordy<cr>

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



noremap <leader>z "=ZoteroCite()<CR>p
inoremap <C-z> <C-r>=ZoteroCite()<CR>

call plug#begin()
"Plug 'https://github.com/vim-pandoc/vim-pandoc'
" Plug 'https://github.com/vim-pandoc/vim-pandoc-syntax'
Plug 'junegunn/limelight.vim'           " Distraction free writing
Plug 'ctrlpvim/ctrlp.vim'               " For sensible link insertion
Plug 'reedes/vim-lexical'               " Better spellcheck mappings
Plug 'reedes/vim-litecorrect'           " Better autocorrections
Plug 'reedes/vim-wordy'                 " Weasel words and passive voice
Plug 'morhetz/gruvbox'                  " a pretty theme... 
Plug 'wakatime/vim-wakatime'            " quantify...
Plug 'ferrine/md-img-paste.vim'         " obsidian-style img paste
call plug#end()

" colourscheme mow it's loaded...
colo gruvbox
" explicitly set it to dark 
set bg=dark
