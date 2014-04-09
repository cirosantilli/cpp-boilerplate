function! b:RedirStdoutNewTabSingle(cmd)
	tabnext
	if expand('%:p') != ""
		tabprevious
		execute "tabnew"
		setlocal buftype=nofile
		setlocal bufhidden=wipe
		setlocal noswapfile
	endif
	%delete
	execute "silent read !" . a:cmd
	set nomodified
endfunction

function! b:MapAllBuff(keys, rhs)
    execute 'noremap <buffer>' a:keys a:rhs
    execute 'noremap! <buffer>' a:keys '<ESC>'.a:rhs
endfunction

call MapAllBuff('<F5>', ':w<CR>:make<CR>')
call MapAllBuff('<F6>', ':call RedirStdoutNewTabSingle("make run")<CR>')
call MapAllBuff('<F7>', ':w<CR>:call RedirStdoutNewTabSingle("make asm")<CR>')
call MapAllBuff('<F8>', ':w<CR>:call RedirStdoutNewTabSingle("make profile")<CR>')
