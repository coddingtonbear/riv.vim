"=============================================
"    Name: rstin.vim
"    File: rstin.vim
" Summary: ReST file plugin
"  Author: Rykka G.Forest
"  Update: 2012-06-09
" Version: 0.5
"=============================================

let g:riv_force = exists("g:riv_force") ? g:riv_force : 0
if exists("b:did_rstftplugin") && g:riv_force == 0 | finish | endif
let b:did_rstftplugin = 1
let s:cpo_save = &cpo
set cpo-=C
" settings {{{
setl foldmethod=expr foldexpr=riv#fold#expr(v:lnum) foldtext=riv#fold#text()
setl comments=fb:.. commentstring=..\ %s expandtab
setl formatoptions+=tcroql
let b:undo_ftplugin = "setl fdm< fde< fdt< com< cms< et< fo<"
        \ "| unlet! b:dyn_sec_list b:foldlevel b:fdl_before_exp b:fdl_cur_list"
        \ "| unlet! b:fdl_before_list b:riv"
        \ "| mapc <buffer>"
        \ "| menu disable RIV.*"
        \ "| menu enable RIV.Index"
" for table init
let b:riv={}
"}}}
if !exists("*s:map") "{{{
fun! s:imap(map_dic) "{{{
    for [name, act] in items(a:map_dic)
        exe "ino <buffer><expr><silent> ".name." ".act
    endfor
endfun "}}}
fun! s:map(map_dic) "{{{
    let leader = g:riv_buf_leader
    for [name, act] in items(a:map_dic)
        let [nmap,mode,lmap] = act
        if type(nmap) == type([])
            for m in nmap
                exe "map <silent><buffer> ".m." <Plug>".name
            endfor
        elseif nmap!=''
            exe "map <silent><buffer> ".nmap." <Plug>".name
        endif
        if mode =~ 'm'
            exe "map <silent><buffer> ". leader . lmap ." <Plug>".name
        endif
        if mode =~ 'n'
            exe "nma <silent><buffer> ". leader . lmap ." <Plug>".name
        endif
        if mode =~ 'i'
            exe "ima <silent><buffer> ". leader . lmap ." <C-O><Plug>".name
        endif

        unlet! nmap
    endfor
endfun "}}}
endif "}}}

call s:imap(g:riv_options.buf_imaps)
call s:map(g:riv_options.buf_maps)
menu enable RIV.*


if exists("g:riv_auto_format_table") "{{{
    au! InsertLeave <buffer> call riv#table#format_pos()
endif "}}}
if exists("g:riv_hover_link_hl") "{{{
    " cursor_link_highlight
    au! CursorMoved,CursorMovedI <buffer>  call riv#link#hi_hover()
    " clear the highlight before bufwin/winleave
    au! WinLeave,BufWinLeave     <buffer>  2match none
endif "}}}

" tests 
"}}}
let &cpo = s:cpo_save
unlet s:cpo_save