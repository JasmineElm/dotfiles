" get paths sorted
" see: https://bit.ly/3l2t4aI
let $VIMHOME=expand('<sfile>:p:h')
let $VIMTEMPLATES='$VIMHOME/templates'
let $VIMPLUG='$VIMHOME/autoload/plug.vim'

" new files with an extension of sh should use template
if has("autocmd")
  augroup templates
    autocmd BufNewFile *.sh 0r $VIMTEMPLATES/sh.skeleton
  augroup END
endif

" keep cursor broadly in the center of the screen
set scrolloff=15

" sensible deaults for files
set encoding=utf-8
set fileformats=unix " assume *nix line endings

"  TABS AND INDENTS
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set shiftround
set autoindent
set complete-=i


set list listchars=tab:»·,trail:·,nbsp:·
set listchars+=extends:»,precedes:«,eol:¬,space:·


" sensible backspace, questionable cursor
set virtualedit=onemore           " cursor can go beyond end of text
set backspace=indent,eol,start    " backspace works across lines

" DISPLAY
" assume non-markdown, see leader w
set textwidth=79
set colorcolumn=80
set number

" Read and write
set autoread                      " if file is modified elsewhere, reload it
set autowrite                     " save file on loss of focus
autocmd FocusLost * wa
autocmd CursorHold * wa

" Display
set incsearch                     " update searches as type
set hlsearch                      " show previous matches
set ignorecase                    " searches ignore case
set smartcase                     " don't ignore capitals in searches
set cursorline                    " highlight current line
set showmatch                     " show matching bracket etc.

augroup vimrc_autocmds
  autocmd BufEnter * highlight OverLength ctermbg=darkgrey guibg=#592929
  autocmd BufEnter * match OverLength /\%80v.*/
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                            REMAPPED KEYS
" (plugin-specific stuff in the relevant section)

" leader is now space
let mapleader=" "
" capslock  is now escape
inoremap <C-c> <Esc>

" leader z to call zotero cite function
noremap <leader>z "=local_functions#ZoteroCite()<CR>p


" remove highlights using leader space
nnoremap <leader><space> :nohls<CR>

" better yank and put
noremap <leader>y "+y
noremap <leader>p "+p

" split windows using - and =
nnoremap <leader>- <C-W>s
nnoremap <leader>= <C-W>v

" reflow paragraphs
nnoremap <leader>f gwip
vnoremap <leader>f gw

"write changes with `sudo`
command W :execute ':silent w !sudo tee % > /dev/null' <bar> :edit!

" move as if everything is a hard wrap
nnoremap j gj
nnoremap k gk

" source $MYvimrc reloads the saved $MYvimrc
:nmap <Leader>s :source $MYVIMRC <CR>

" opens $MYvimrc for editing
:nmap <Leader>v :e $MYVIMRC <CR>

:nmap <Leader>t :WakaTimeToday<CR>
" markdown folding

let g:markdown_folding = 1
set nofoldenable

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                 SPELLING
set spell spelllang=en_gb

" toggle spellcheck highlighting with 5
nnoremap <leader>5 :call local_functions#ToggleSpell()<CR>

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
imap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
nmap <C-l> [s1z=<c-o>
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

" NetRW
let g:netrw_liststyle = 1 " Detail View
let g:netrw_sizestyle = "H" " Human-readable file sizes
let g:netrw_banner = 0 " Turn off banner
" Explore in vertical split
nnoremap <Leader>e :Explore! <enter>

" if a build script exists at this level call it using \b
" see: https://github.com/JasmineElm/reports
noremap <leader>b :! ./build -w<cr>

" run shfmt on current file, force a redraw by jumping between marks
noremap <leader>k :execute 'silent !shfmt -i 2 -ci -bn -w %'<cr> ````

" paste a date
noremap <leader>d :put =strftime('%a %d-%b-%y %OH:%M')<CR>A<CR>

" SPLITS
"
noremap <leader>= <c-w>v
noremap <leader>- <c-w>s

" move between splits
noremap <leader>h <c-w>h
noremap <leader>j <c-w>j
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                LIMELIGHT
let g:limelight_conceal_ctermfg     = 'gray'
let g:limelight_default_coefficient = 0.3

map <leader>2 :call DistractionFreeWriting()<CR>

" turn-on distraction free writing mode for markdown files
au BufNewFile,BufRead *.{md,mdown,mkd,mkdn,markdown,mdwn} call DistractionFreeWriting()

" toggle listchars
function ToggleListChars()
  "unsets listchars if set, sets listchars if unset
  if &listchars == ""
    set listchars=tab:»·,trail:·,nbsp:·
    set listchars+=extends:»,precedes:«,eol:¬,space:·
  else
    set listchars=
  endif
endfunction

function ToggleSyntax()
  " turn syntax highlighting on/off
    if exists("g:syntax_on")
        syntax off
    else
        syntax enable
    endif
endfunction

function  ToggleCursorline()
  " toggle cursorline
    if exists("+cursorline")
        set nocursorline
    else
        set cursorline
    endif
endfunction

function ToggleRuler()
  " toggle ruler
    set ruler!
endfunction

function ToggleColorColumn()
  " if colorcolumn is set to 80 then set it to 110 and vice versa
  "
    if exists("+colorcolumn") && &colorcolumn == 80
        set colorcolumn=110
    else
        set colorcolumn=80
    endif
endfunction

function ToggleGutter()
  " toggle gutter
    " add a 4 char margin to the left if number is set
    if &number
        set foldcolumn=4
        " turn numbers off
        set nonumber
        " turn off margin color
        hi clear FoldColumn
    else
        set foldcolumn=0
        " turn numbers on
        set number
    endif
endfunction


function! DistractionFreeWriting()
  " toggle limelight
    :Limelight!!
    "call lexical#init()
    call litecorrect#init()
    " set rulerformat+=%{local_functions#WordCount()}
    " toggle line numbers
    call ToggleGutter()
    " toggle syntax highlighting
    call ToggleSyntax()
    " toggle ruler
    call ToggleRuler()
    " toggle colorcolumn
    call ToggleColorColumn()
    " toggle listchars
    call ToggleListChars()
    " toggle cursorline
    call ToggleCursorline()
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                      ALE
highlight ALEErrorSign ctermbg        =NONE ctermfg=red
highlight ALEWarningSign ctermbg      =NONE ctermfg=yellow
"let g:ale_linters_explicit            = 1
let g:ale_lint_on_text_changed        = 'never'
let g:ale_lint_on_save                = 1
let g:ale_fix_on_save                 = 1
let g:ale_fixers = {
\   '*':          ['remove_trailing_lines', 'trim_whitespace'],
\   'markdown':   ['pandoc'],
\   'shell':      ['shfmt'],
\}
let g:ale_linters = {'markdown':['vale']}

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
"                                                 VIM-WIKI
" new files should have names like <yyyy><mm><dd><hh><mm><name>.md
let g:vimwiki_auto_header = 0       "we'll use our own template
let g:vimwiki_auto_tags = 1
let g:vimwiki_auto_toc = 1
let g:vimwiki_global_ext = 1
"  template for new files
"
let g:vimwiki_template = {
\   'default': 'template',
\   'markdown': 'template',
\}
"  template for new files
let g:vimwiki_template_path = '$VIMTEMPLATES/vimwiki'

"  template for new files
let g:vimwiki_template_default_ext = '.md'

let g:vimwiki_date_format = '%d/%m/%Y'

function VimwikiHeader()
  " get date  and time from shell
  " declare variables
  let l:datenow = strftime("%d/%m/%Y")
  let l:filename = expand("%:t")
  " remove extension, replace underscores with spaces
  " and capitalize first letter of each word
  let l:filename = substitute(l:filename, '\.md$', '', '')
  let l:filename = substitute(l:filename, '_', ' ', 'g')
  let l:filename = substitute(l:filename, '\(\<\w\)\(\w*\)\>', '\u\1\2', 'g')
  let·l:filename·=·substitute(l:filename,·'^\d\{12}-',·'', '')
  " replace <DATE> with date
  execute "%s#<DATE>#" . l:datenow . "#g"
   execute "%s#<FILENAME>#" . l:filename . "#g"
endfunction

" new files with an extension of md should use template
if has("autocmd")
  augroup templates
    autocmd BufNewFile *.md 0r $VIMTEMPLATES/md.skeleton
    " call Vimwikiheader on the new file
    autocmd BufNewFile *.md :call VimwikiHeader()
  augroup END
endif

let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
" nested syntaxes: python, shellscript
let g:vimwiki_markdown_syntax_conceal = 0
let g:vimwiki_markdown_link_ext = 1
let g:vimwiki_markdown_link_target_type = 'md'
let g:vimwiki_markdown_link_target = 1
let nested_syntaxes = {'python': 'python', 'shellscript': 'sh'}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                 VIM-PLUG
if empty(glob($VIMPLUG))
  silent !curl -fLo $VIMPLUG --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYvimrc
endif


call plug#begin()
Plug 'junegunn/limelight.vim'           " Distraction free writing
Plug 'ctrlpvim/ctrlp.vim'               " For sensible link insertion
"Plug 'reedes/vim-lexical'               " Better spellcheck mappings
Plug 'reedes/vim-litecorrect'           " Better autocorrections
Plug 'reedes/vim-wordy'                 " Weasel words and passive voice
Plug 'morhetz/gruvbox'                  " a pretty theme...
Plug 'wakatime/vim-wakatime'            " quantify...
Plug 'ferrine/md-img-paste.vim'         " obsidian-style img paste
Plug 'dense-analysis/ale'               " ALE
Plug 'github/copilot.vim'               " AI codes better than me
Plug 'vimwiki/vimwiki'              " vimwiki
call plug#end()

" colourscheme now it's loaded...

colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_contrast_light='hard'
let g:gruvbox_improved_strings=1
let g:gruvbox_improved_warnings=1
let g:gruvbox_improved_visibility=1
let g:gruvbox_bold=1
let g:gruvbox_italic=1
let g:gruvbox_italicize_comments=1
let g:gruvbox_italicize_strings=1
let g:gruvbox_italicize_variables=1
let g:gruvbox_underline=1
let g:gruvbox_undercurl_term=1

" function - change background colour
function! ToggleTheme()
" if background is dark then set it to light and vice versa
    if &background == 'dark'
        set background=light
    else
        set background=dark
    endif
endfunction


map <leader>1 :call ToggleTheme()<CR>

highlight FoldColumn ctermbg=NONE guibg=NONE
" ruler to be colourless
highlight ruler ctermbg=NONE guibg=NONE
