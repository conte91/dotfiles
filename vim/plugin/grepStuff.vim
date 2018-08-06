function! CMGetLine()
   let l:currentLine=getline('.')
   let l:tID=substitute(l:currentLine, '^.\{-}0*\([0-9a-f]\{,12}\)-[0-9a-f#]\{8,9}-[0-9a-f#]\{3}.*', '\1', '')
   return l:tID
endfunction

function! GrrGrep(pattern, dirname)
   silent exec "grep -RnIHe '" . a:pattern . "' " . a:dirname . '/**'
   cw
   let w:quickfix_title = 'Matches for ' . a:pattern . ' in ' . a:dirname
endfunction

function! GrrAll(pattern)
   call GrrGrep(a:pattern, ".")
endfunction

function! GrrHere(pattern)
   call GrrGrep(a:pattern, expand("%:p:h") )
endfunction

function! GrrCWAll()
   call GrrGrep(expand("<cword>"), ".")
endfunction

function! GrrCWHere()
   let cwd = expand("%:p:h")
   call GrrGrep(expand("<cword>"), cwd )
endfunction

function! GrrFunction()
   call inputsave()
   let pattern = input('What? ', expand("<cword>"))
   let dirname = input('Where? ', expand("%:p:h"), "file")
   call inputrestore()
   call GrrGrep(pattern, dirname)
endfunction

command! Grr call GrrFunction()

" vim: et sw=3 ts=3:
