function! comentarista#single_toggle() "{{{
    normal ma
    if getline(".") =~ '^\s*'.b:comentarista_single " Remove the comment tag it contains
        silent execute ":.s;".escape(b:comentarista_single, "[]")." *;;"
        normal `a
        execute "silent normal ".eval(strlen(b:comentarista_single)+1)."h"
    else " Comment line
        execute "normal I".b:comentarista_single." "
        normal `a
        execute "normal ".eval(strlen(b:comentarista_single)+1)."l"
    endif

    if exists("b:comentarista_single_closing")
        if getline(".") =~ b:comentarista_single_closing.'\s*$'  " Remove the end comment tag it contains
            silent execute ":.s; *".escape(b:comentarista_single_closing, "[]").";;"
            normal `a
            " normal 3h
            execute "silent normal ".eval(strlen(b:comentarista_single_closing)+1)."h"
        else " Comment line (end)
            execute "normal ^A ".b:comentarista_single_closing." "
            normal `a
        endif
    endif
    nohlsearch
endfunction "}}}

function! comentarista#block_toggle(isVisual) "{{{
    "" Define a few variables
    let l:curl = line(".")
    let l:curc = col(".")
    let l:startpat = escape(b:comentarista_block_start, "*[]\{}")
    let l:endpat = escape(b:comentarista_block_end, "*[]\{}").'\s*$'

    " Search entire file 'upwards' for either a S or an E. if E or no S, then do comment
    if match(getline("."), '^\s*'.l:startpat) > -1
        let l:found = l:curl
    else
        if match(getline("."), l:endpat) > -1
            call cursor(l:curl-1, 0)
        endif
        let l:found = search(l:startpat."\\|".l:endpat, "bW")
    endif
    " echo "found #".found.": ".getline(found)

    if l:found > 0 && match(getline(l:found), l:endpat) == -1 " Delete existing comments
        if a:isVisual == 0 && searchpair(l:startpat, '', l:endpat, 'W') > 0
            normal dd
            call cursor(l:found, 0)
            normal dd
        endif
    else " Create new comment block
        if a:isVisual > 0
            call cursor(line("'<"), 0)
            let l:mark=">"
        else
            call cursor(l:curl, l:curc)
            let l:mark="a"
        endif

        let l:marked=line("'".l:mark)
        if l:marked > 0
            if l:marked > l:curl
                execute "normal O".b:comentarista_block_start."'".l:mark."o".b:comentarista_block_end.""
            else
                execute "normal o".b:comentarista_block_end."'".l:mark."O".b:comentarista_block_start.""
            endif
        else
            execute "normal o".b:comentarista_block_end."kO".b:comentarista_block_start.""
        endif
    endif
    call cursor(l:curl, l:curc)
endfunction "}}}


" vim: set foldmethod=marker number relativenumber formatoptions-=tc:
