function! TagGo()
	exec 'tjump ' . expand('<cword>')
endfunction

function! TagCallers()
	exec 'cscope find c ' . expand('<cword>')
endfunction

function! TagDepends()
	exec 'cscope find d ' . expand('<cword>')
endfunction
