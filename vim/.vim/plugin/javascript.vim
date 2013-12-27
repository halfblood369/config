"
" Javascript filetype plugin for running node-jslint
" Language:     Javascript (ft=javasript)
" Maintainer:   KS Chan <mrkschan@gmail.com>
" Version:      Vim 7 (may work with lower Vim versions, but not tested)
" URL:          https://github.com/mrkschan/vim-node-jslint
" NOTICE:       The implementation of this js linter is referencing
"               http://github.com/nvie/vim-pyflakes
"
" Only do this when not done yet for this buffer
if exists("b:loaded_jslint_ftplugin")
    finish
endif
let b:loaded_jslint_ftplugin=1

let s:jslint_cmd="jslint"

if !exists("*JSLint()")
    function JSLint()
        if !executable(s:jslint_cmd)
            echoerr "node-jslint (" . s:jslint_cmd . ") not found." .
                    \" Do `npm install jslint -g`"
            return
        endif

        set lazyredraw   " delay redrawing
        cclose           " close any existing cwindows

        " store old make settings (to restore later)
        let l:old_efm=&errorformat
        let l:old_mp=&makeprg
        let l:old_sp=&shellpipe

        " write any changes before continuing
        if &readonly == 0
            update
        endif

        " perform the make itself
        setlocal efm=%-P%f,
                     \%E%>\ %##%n\ %m,%Z%.%#Line\ %l\\,\ Pos\ %c,
                     \%-G%f\ is\ OK.,%-Q
        let &makeprg=s:jslint_cmd
        let &shellpipe=">"
        silent! make! %

        " restore make settings
        let &errorformat=l:old_efm
        let &makeprg=l:old_mp
        let &shellpipe=l:old_sp

        " open cwindow
        let has_results=getqflist() != []
        if has_results
            execute 'belowright copen'
            nnoremap <buffer> <silent> c :cclose<CR>
            nnoremap <buffer> <silent> q :cclose<CR>
        endif

        set nolazyredraw
        redraw!

        if has_results == 0
            " Show OK status
            hi Green ctermfg=green
            echohl Green
            echon "Static analysis OK"
            echohl
        endif
    endfunction
endif

" Add mappings, unless the user didn't want this.
" The default mapping is registered under to <F7> by default, unless the user
" remapped it already (or a mapping exists already for <F7>)
if !exists("no_plugin_maps") && !exists("no_jslint_maps")
    if !hasmapto('JSLint()')
        noremap <buffer> <F7> :call JSLint()<CR>
        noremap! <buffer> <F7> :call JSLint()<CR>
    endif
endif
