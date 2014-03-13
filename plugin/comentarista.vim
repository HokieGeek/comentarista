let g:comentarista_toggle_single_line = "<Tab>"
let g:comentarista_toggle_block = "<S-Tab>"

" if exists("g:slco") | unlet! slco | endif
if exists("g:slcoE") | unlet! slcoE | endif
" if exists("g:blkcoS") | unlet! blkcoS | endif
" if exists("g:blkcoE") | unlet! blkcoE | endif
augroup comment_symbols
    autocmd!
    autocmd FileType vim,vimrc let slco="\"" " vim
    autocmd FileType sql,haskell let slco="--"    " SQL and Haskell
    autocmd FileType ahk let slco=";"        " AutoHotkey
    " Java/C/C++
    autocmd FileType java,c,c++,cpp,h,h++,hpp
        \ let slco="//" |
        \ let blkcoS="/*" |
        \ let blkcoE="*/"
    " Shell/Scripts
    autocmd FileType sh,ksh,csh,tcsh,zsh,bash,dash,pl,python,make,gdb
        \ let slco="#"
    " XML
    autocmd FileType xml,html
        \ let slco="<![CDATA[-----" |
        \ let slcoE="-----]]>" |
        \ let blkcoS="<![CDATA[-------------------" |
        \ let blkcoE="-------------------]]>"
    " LaTeX
    autocmd FileType tex
        \ let slco="%" |
        \ let blkcoS="\begin{comment}" |
        \ let blkcoE="\end{comment}"
augroup END

augroup comment_mappings
    " All Code Files
    autocmd FileType java,c,c++,cpp,h,h++,hpp,xml
        \ execute "vnoremap <silent> ".g:comentarista_toggle_block." :call comentarista#BLKCOtoggle(1)<cr>" |
        \ execute "nnoremap <silent> ".g:comentarista_toggle_block." :call comentarista#BLKCOtoggle(0)<cr>"

    autocmd FileType java,c,c++,cpp,h,h++,hpp,sql,xml,sh,ksh,csh,tcsh,zsh,bash,dash,pl,python,vim,vimrc,ahk,tex,make,gdb
        \ execute "nnoremap <silent> ".g:comentarista_toggle_single_line." :call comentarista#SLCOtoggle()<cr>"
    autocmd FileType sh,ksh,csh,tcsh,zsh,bash,pl,python,sql,vim,vimrc,ahk,tex,make,gdb
        \ execute "nnoremap <silent> ".g:comentarista_toggle_block." :'k,.call comentarista#SLCOtoggle()<cr>"

    autocmd FileType java,c,c++,cpp,h,h++,hpp,sql,sh,ksh,csh,tcsh,zsh,bash,pl,vim,vimrc
        \ execute "nnoremap <silent> todo oTODO: <esc>".g:comentarista_toggle_single_line."==A"
    autocmd FileType java,c,c++,cpp,h,h++,hpp,sql,sh,ksh,csh,tcsh,zsh,bash,pl,vim,vimrc
        \ execute "nnoremap <silent> fixme oFIXME: <esc>".g:comentarista_toggle_single_line."==A"
augroup END

" vim: set foldmethod=marker number relativenumber formatoptions-=tc:
