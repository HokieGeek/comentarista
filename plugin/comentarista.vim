let g:comentarista_toggle_single_line = "<Tab>"
let g:comentarista_toggle_block = "<S-Tab>"

augroup comment_symbols
    autocmd!
    autocmd FileType vim,vimrc let b:comentarista_single="\"" " vim
    autocmd FileType sql,haskell let b:comentarista_single="--"    " SQL and Haskell
    autocmd FileType ahk let b:comentarista_single=";"        " AutoHotkey
    " Java/C/C++
    autocmd FileType java,c,c++,cpp,h,h++,hpp
        \ let b:comentarista_single="//" |
        \ let b:comentarista_block_start="/*" |
        \ let b:comentarista_block_end="*/"
    " Shell/Scripts
    autocmd FileType sh,ksh,csh,tcsh,zsh,bash,dash,pl,python,make,gdb
        \ let b:comentarista_single="#"
    " XML
    autocmd FileType xml,html
        \ let b:comentarista_single="<![CDATA[-----" |
        \ let b:comentarista_single_closing="-----]]>" |
        \ let b:comentarista_block_start="<![CDATA[-------------------" |
        \ let b:comentarista_block_end="-------------------]]>"
    " LaTeX
    autocmd FileType tex
        \ let b:comentarista_single="%" |
        \ let b:comentarista_block_start="\begin{comment}" |
        \ let b:comentarista_block_end="\end{comment}"
augroup END

augroup comment_mappings
    " All Code Files
    autocmd FileType java,c,c++,cpp,h,h++,hpp,xml
        \ execute "vnoremap <silent> ".g:comentarista_toggle_block." :call comentarista#block_toggle(1)<cr>" |
        \ execute "nnoremap <silent> ".g:comentarista_toggle_block." :call comentarista#block_toggle(0)<cr>"

    autocmd FileType java,c,c++,cpp,h,h++,hpp,sql,xml,sh,ksh,csh,tcsh,zsh,bash,dash,pl,python,vim,vimrc,ahk,tex,make,gdb
        \ execute "nnoremap <silent> ".g:comentarista_toggle_single_line." :call comentarista#single_toggle()<cr>"
    autocmd FileType sh,ksh,csh,tcsh,zsh,bash,pl,python,sql,vim,vimrc,ahk,tex,make,gdb
        \ execute "nnoremap <silent> ".g:comentarista_toggle_block." :'k,.call comentarista#single_toggle()<cr>"

    autocmd FileType java,c,c++,cpp,h,h++,hpp,sql,sh,ksh,csh,tcsh,zsh,bash,pl,vim,vimrc
        \ execute "nnoremap <silent> todo oTODO: <esc>".g:comentarista_toggle_single_line."==A"
    autocmd FileType java,c,c++,cpp,h,h++,hpp,sql,sh,ksh,csh,tcsh,zsh,bash,pl,vim,vimrc
        \ execute "nnoremap <silent> fixme oFIXME: <esc>".g:comentarista_toggle_single_line."==A"
augroup END

" vim: set foldmethod=marker formatoptions-=tc:
