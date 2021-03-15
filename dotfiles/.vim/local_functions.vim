if has("autocmd")
  augroup templates
    autocmd BufNewFile *.sh 0r ~/.vim/templates/sh.skeleton
  augroup END
endif

" set header title for journal & enter writing mode
function! JournalMode()
    execute 'normal gg'
    let filename = '##' . ' ' . expand('%:r')
    call setline(1, filename)
    execute ':4'
    execute 'normal zR o'
endfunction

augroup journal
    autocmd!

" populate journal template
autocmd VimEnter */Journal/**   0r ~/.vim/templates/journal.skeleton

" set header for the particular journal
autocmd VimEnter */Journal/**   :call JournalMode()

" https://stackoverflow.com/questions/12094708/include-a-directory-recursively-for-vim-autocompletion
autocmd VimEnter */Journal/**   set complete=k~/Documents/Journal/**/*
 

"==========================================================
"   TOGGLE EXPLORER WINDOW 
"==========================================================
"
" see https://stackoverflow.com/a/5636941 
"
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore
      let t:expl_buf_num = bufnr("%")
  endif
endfunction

"==========================================================
"   TOGGLE SPELLCHECK HIGHLIGHTING 
"==========================================================
"
" see ????
"
function! ToggleSpell()
  if !exists("g:showingSpell")
    let g:showingSpell=0
  endif

  if g:showingSpell==0
    execute "hi SpellBad    cterm=underline ctermbg=red"
    execute "hi SpellCap    ctermbg=blue"
    execute "hi SpellLocal  ctermbg=green"
    execute "hi SpellRare   ctermbg=blue"

    let g:showingSpell=1
  else
    execute "hi clear SpellBad"
    execute "hi clear Spellcap"
    execute "hi clear SpellLocal"
    execute "hi clear SpellRare"
    let g:showingSpell=0
  endif
endfunction

"==========================================================
"    WORD COUNT
"==========================================================
"
" see https://stackoverflow.com/a/4588161
"
function! WordCount()
   let s:old_status = v:statusmsg
   let position = getpos(".")
   exe ":silent normal g\<c-g>"
   let stat = v:statusmsg
   let s:word_count = 0
   if stat != '--No lines in buffer--'
     let s:word_count = str2nr(split(v:statusmsg)[11])
     let v:statusmsg = s:old_status
   end
   call setpos('.', position)
   return s:word_count
endfunction



"==========================================================
"    Zettelkasten
"==========================================================
"
" see https://www.edwinwenink.xyz/posts/48-vim_fast_creating_and_linking_notes/
"

let g:zettelkasten = "~/Dropbox/Zettelkasten/"
command! -nargs=1 NewZettel :execute ":e" zettelkasten . strftime("%Y%m%d%H%M") . "-<args>.md" | execute put <args>
nnoremap <leader>nz :NewZettel 

"autocmd VimEnter */Zettelkasten/**   0r ~/.vim/templates/zettelkasten.skeleton


" CtrlP function for inserting a markdown link with Ctrl-X
function! CtrlPOpenFunc(action, line)
   if a:action =~ '^h$'    
      " Get the filename
      let filename = fnameescape(fnamemodify(a:line, ':t'))
	  let filename_wo_timestamp = fnameescape(fnamemodify(a:line, ':t:s/\d+-//'))

      " Close CtrlP
      call ctrlp#exit()
      call ctrlp#mrufiles#add(filename)

      " Insert the markdown link to the file in the current buffer
	  let mdlink = "[ ".filename_wo_timestamp." ]( ".filename." )"
      put=mdlink
  else    
      " Use CtrlP's default file opening function
      call call('ctrlp#acceptfile', [a:action, a:line])
   endif
endfunction

let g:ctrlp_open_func = { 
         \ 'files': 'CtrlPOpenFunc',
         \ 'mru files': 'CtrlPOpenFunc' 
         \ }

