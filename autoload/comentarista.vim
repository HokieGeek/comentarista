if exists("g:autoloaded_comentarista") || v:version < 700
    finish
endif
let g:autoloaded_comentarista = 1

function! comentarista#single_toggle() "{{{
    if !exists("b:comentarista_single")
        return
    endif

    let l:symbol_len = strlen(b:comentarista_single)
    let l:col_pos = col(".")
    let l:line = getline(".")

    " Beginning tag
    if l:line =~ '^\s*'.b:comentarista_single " Remove the comment tag it contains
        " let l:line_modified = substitute(l:line, "^\\(\\s*\\)".b:comentarista_single." \\(.\\)", "\\1\\2", "")
        let l:pat = "^\\(\\s*\\)".b:comentarista_single." \\(.\\)"
        let l:sub = "\\1\\2"
        let l:cursor_offset = l:col_pos-l:symbol_len-1
    else
        let l:pat = "^\\(\\s*\\)\\(.\\)"
        let l:sub = "\\1".b:comentarista_single." \\2"
        let l:cursor_offset = l:col_pos+l:symbol_len+1
    endif
    let l:line_modified = substitute(l:line, l:pat, l:sub, "")

    " Ending tag
    if exists("b:comentarista_single_closing")
        if getline(".") =~ b:comentarista_single_closing.'\s*$'  " Remove the end comment tag it contains
            let l:pat = "\\(.\\) ".b:comentarista_single_closing."\\(\\s*\\)$"
            let l:sub = "\\1\\2"
        else
            let l:pat = "\\(.\\)\\(\\s*\\)$"
            let l:sub = "\\1 ".b:comentarista_single_closing."\\2"
        endif
        let l:line_modified = substitute(l:line_modified, l:pat, l:sub, "")
    endif

    " Write the line and move the cursor
    call setline(".", l:line_modified)
    call cursor(".", l:cursor_offset)
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


" vim: set foldmethod=marker formatoptions-=tc:
