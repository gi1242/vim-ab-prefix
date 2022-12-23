" Vim plugin to conditionally expand abbreviations on a matching prefix.
" Maintainer:	GI <gi1242@nospam.com> (replace nospam with gmail)
" Created:	Sat 05 Jul 2014 08:46:04 PM WEST
" Last Changed:	Thu 22 Dec 2022 08:46:35 PM EST
" Version:	0.1

" provide load control
if exists('g:loaded_ab_prefix')
    finish
endif

" NOTE: This doesn't seem to work for one letter macros. Directly use iab
" for those.
"
let s:expansions = {}

function! s:prefix_expand( ab ) "{{{1
    " Grab next char to match suffixes
    let c = nr2char( getchar(0))

    "echomsg 'ab='.a:ab
    if !has_key( s:expansions, a:ab ) 
	let rep = a:ab
	let rrep = ''
    else
	let line = getline( '.' )[ :col('.')-1 ]
	let matched = 0
	for prefix in keys( s:expansions[a:ab])
	    "echomsg 'prefix='.prefix 'ab='.a:ab 'line='.line.'.'
	    if match( line, prefix . 'x$' ) >= 0
		" Matched prefix. Check suffixes.
		if has_key( s:expansions[a:ab][prefix], c )
		    " Suffix matched.
		    let expn = s:expansions[a:ab][prefix][c]

		    " Gobble is now interpreted as boolean.
		    if expn['gobble']
			let c = ''
		    endif
		elseif has_key( s:expansions[a:ab][prefix], 'NONE' )
		    " No suffix matched.
		    let expn = s:expansions[a:ab][prefix]['NONE']

		    " Gobble spaces if necessary
		    let gobble = expn['gobble']
		    if gobble != '' && c =~ gobble
			let c = ''
		    endif
		else
		    " Prefix matches, but not suffix. Break out. No match.
		    break
		endif

		if expn['eval']
		    let rep = (expn['rep'] != '') ?  eval( expn['rep'] ) : ''
		    let rrep = (expn['rrep'] != '') ? eval( expn['rrep'] ) : ''
		else
		    let rep = expn['rep']
		    let rrep = expn['rrep']
		endif

		let matched = 1
		break
	    endif
	endfor

	if !matched
	    let rep = a:ab
	    let rrep = ''
	endif
    endif

    " Do the replacement.
    "exec 'normal! "_s' . rep . 'x'
    let p = getpos( '.' )
    exec 'normal! "_s' . rrep
    call setpos( '.', p )

    return rep . c
endfunction

function! s:prefix_expand_expr( ab ) "{{{1
    " Grab next char to match suffixes
    let c = nr2char( getchar(0))

    "echomsg 'ab='.a:ab
    if !has_key( s:expansions, a:ab ) 
	let rep = a:ab
	let rrep = ''
    else
	let line = getline( '.' )[ :col('.')-len(a:ab)-2]
	let matched = 0
	for prefix in keys( s:expansions[a:ab])
	    "echomsg 'prefix='..prefix 'ab='..a:ab 'line='..line..'.'
	    if match( line, prefix..'$' ) >= 0
		" Matched prefix. Check suffixes.
		if has_key( s:expansions[a:ab][prefix], c )
		    " Suffix matched.
		    let expn = s:expansions[a:ab][prefix][c]

		    " Gobble is now interpreted as boolean.
		    if expn['gobble']
			let c = ''
		    endif
		elseif has_key( s:expansions[a:ab][prefix], 'NONE' )
		    " No suffix matched.
		    let expn = s:expansions[a:ab][prefix]['NONE']

		    " Gobble spaces if necessary
		    let gobble = expn['gobble']
		    if gobble != '' && c =~ gobble
			let c = ''
		    endif
		else
		    " Prefix matches, but not suffix. Break out. No match.
		    break
		endif

		if expn['eval']
		    let rep = (expn['rep'] != '') ?  eval( expn['rep'] ) : ''
		    let rrep = (expn['rrep'] != '') ? eval( expn['rrep'] ) : ''
		else
		    let rep = expn['rep']
		    let rrep = expn['rrep']
		endif

		let matched = 1
		break
	    endif
	endfor

	if !matched
	    let rep = a:ab
	    let rrep = ''
	endif
    endif

    " Do the replacement.
    " 2022-12-21 GI: Note -- expr mapping doesn't allow "normal" commands. So
    " no right replacements are honored by this method. Given snippets, I'm
    " not bothered by this.
    return rep..c
endfunction

function! AbDefineExpansion( iabargs, prefix, ab, ... ) "{{{1
    "echomsg 'iabargs='.a:iabargs 'prefix='.a:prefix 'ab='.a:ab

    let iabargs = (a:iabargs == 'NONE') ? '' : a:iabargs

    let rep	= (a:0 >= 1) ? a:1 : ''
    let rrep	= (a:0 >= 2) ? a:2 : ''
    let gobble	= (a:0 >= 3) ? a:3 : ''
    let eval	= (a:0 >= 4) ? a:4 : 0
    let suffix	= (a:0 >= 5) ? a:5 : ''

    if rep	== 'NONE' | let rep	= '' | endif
    if rrep	== 'NONE' | let rrep	= '' | endif
    if gobble	== 'NONE' | let gobble	= '' | endif
    if eval	== 'NONE' | let eval	= 0  | endif

    if suffix == '' | let suffix = 'NONE' | endif

    if rep == '' && rrep == ''
	" Delete the expansion instead
	if has_key( s:expansions, a:ab ) 
		    \ && has_key( s:expansions[a:ab], a:prefix )
	    unlet s:expansions[a:ab][a:prefix]
	    if empty( s:expansions[a:ab] )
		unlet s:expansions[a:ab]
		exec 'iunab' iabargs a:ab 
	    endif
	endif
    else
	if !has_key( s:expansions, a:ab )
	    let s:expansions[a:ab] = {}
	endif
	if !has_key( s:expansions[a:ab], a:prefix )
	    let s:expansions[a:ab][a:prefix] = {}
	endif

	let s:expansions[a:ab][a:prefix][suffix] =
		\ { 
		    \ 'rep': substitute( rep, '<cr>', '\n', 'g' ),
		    \ 'rrep': substitute( rrep, '\\n', '\r', 'g' ),
		    \ 'gobble': gobble,
		    \ 'eval': eval
		\ }
	let iab_ab = substitute( a:ab, '|', '\\|', 'g' )
	"exec 'iab' iabargs a:ab 
	"	\ "x<left><c-r>=<SID>prefix_expand('".iab_ab."')<cr>"
	exec "iab <expr>" iabargs a:ab "<SID>prefix_expand_expr('"..iab_ab.."')"
    endif
endfunction

" {{{1 Debugging stuff
if exists('g:ab_prefix_debug')
    function! DumpExpansions()
	return s:expansions
    endfunction
endif
"}}}1

" Command to define more expansions
command! -nargs=+ AbDef	:call AbDefineExpansion( <f-args> )

let g:loaded_ab_prefix = 1
