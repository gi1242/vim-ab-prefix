" Vim plugin to conditionally expand abbreviations on a matching prefix.
" Maintainor:	GI <gi1242@nospam.com> (replace nospam with gmail)
" Created:	Sat 05 Jul 2014 08:46:04 PM WEST
" Last Changed:	Mon 07 Jul 2014 10:30:14 AM CEST
" Version:	0.1
"
" Description:
"   Various abbreviations and mappings in insert mode.

" provide load control
if exists('g:loaded_ab_prefix')
    finish
endif
let g:loaded_ab_prefix = 1

" NOTE: This doesn't seem to work for one letter macros. Directly use iab
" for those.
"
let s:expansions = {}

function! s:prefix_expand( prefix, ab )
    if !has_key( s:expansions, a:prefix ) 
		\ || !has_key( s:expansions[a:prefix], a:ab )
	let rep = a:ab
	let rrep = ''
	let gobble = ''
    else
	let line = getline( '.' )[ :col('.')-1 ]
	"echomsg 'prefix='.a:prefix 'ab='.a:ab 'line='.line.'.'
	if match( line, a:prefix . 'x$' ) >= 0
	    " Matched; replace text.
	    let rep = s:expansions[a:prefix][a:ab]['rep']
	    let rrep = s:expansions[a:prefix][a:ab]['rrep']
	    let gobble = s:expansions[a:prefix][a:ab]['gobble']
	else
	    let rep = a:ab
	    let rrep = ''
	    let gobble = ''
	endif
    endif

    " Gobble spaces if necessary
    let c = nr2char( getchar(0))
    if gobble != '' && c =~ gobble
	let c = ''
    endif

    " Do the replacement.
    "exec 'normal! "_s' . rep . 'x'
    let p = getpos( '.' )
    exec 'normal! "_s' . rrep
    call setpos( '.', p )

    return rep . c
endfunction

function! AbDefineExpansion( iabargs, prefix, ab, rep, ... )
    let iabargs = (a:iabargs == 'NONE') ? '' : a:rep
    let rep = (a:rep == 'NONE') ? '' : a:rep

    let rrep = (a:0 >= 1) ? a:1 : ''
    let gobble = (a:0 >= 2) ? a:2 : ''

    if rrep == 'NONE' | let rrep = '' | endif
    if gobble == 'NONE' | let gobble = '' | endif

    if !has_key( s:expansions, a:prefix )
	let s:expansions[a:prefix] = {}
    endif
    let s:expansions[a:prefix][a:ab] =
	    \ { 
		\ 'rep': rep,
		\ 'rrep': substitute( rrep, '\\n', '\r', 'g' ),
		\ 'gobble': gobble
	    \ }
    exec 'iab' iabargs a:ab 
	    \ "x<left><c-r>=<SID>prefix_expand('".a:prefix."',"
	    \	   "'".a:ab."')<cr>"
endfunction

" Command to define more expansions
command! -nargs=+ AbDef	:call AbDefineExpansion( <f-args> )
"command! -nargs=+ Bab	:call AbDefineExpansion( '\\', <f-args>)
"}}}
