" Vim plugin to conditionally expand abbreviations on a matching prefix.
" Maintainer:	GI <gi1242@nospam.com> (replace nospam with gmail)
" Created:	Sat 05 Jul 2014 08:46:04 PM WEST
" Last Changed:	Mon 04 Dec 2017 09:04:54 PM EST
" Version:	0.1
"
" Description:
"   Various TeX abbreviations and mappings in insert mode.

" Don't do anything if the ab-prefix plugin hasn't been loaded.
if !exists( 'g:loaded_ab_prefix' ) || exists( 'b:loaded_tex_ab_prefix' )
    finish
endif
    
" Commands
" {{{
" Usage: Bab ab rep rrep gobble eval suffix
command! -nargs=* Bab	:AbDef  <buffer> \\\\ <args>

" Commands with arguments
function! s:new_command( ab, cmd, opt )
    call AbDefineExpansion( '<buffer>', '\\',
		\ a:ab, a:cmd.'{', '', '[ \t{]' )
    if a:opt
	call AbDefineExpansion( '<buffer>', '\\',
		\ a:ab, a:cmd, '', 0, 0, '[' )
    endif
    
    " Star form
    call AbDefineExpansion( '<buffer>', '\\',
	    \ a:ab, a:cmd.(a:opt ? '' : '{'), '', 0, 0, '*' )
endfunction

command! -nargs=+ Baba	:call s:new_command( <f-args>, 0 )
command! -nargs=+ Babo	:call s:new_command( <f-args>, 1 )

" Misc commands that take an argument.
" (Insert trailing { forcibly, and ignore next typed char)
Babo sec	section
Babo ss	subsection
Babo sss	subsubsection
Babo para	paragraph
Babo sp	subparagraph

"Bab beg	begin{			NONE [[:space:]{] 
Bab  be	begin		    	NONE 0 0 {
Baba beg	begin
Bab  bg		begingroup
Bab  eg		endgroup

Bab  mb  mathbb
Bab  mc  mathcal
Bab  ms  mathscr
Bab  li  linewidth	    	NONE [\ \t]
Bab  li  lim	    	NONE 0 0 _
Bab  inc includegraphics[width=	NONE [\ \t]
Bab  in  includegraphics[width=	NONE 1 0 [
Bab  in  includegraphics		NONE 0 0 {
Bab  in  int			NONE 0 0 _
Bab  dis displaystyle
Baba tb  textbf
Baba em  emph
Baba on  operatorname
Baba te  text
Baba tt  texttt
Baba tit textit
Bab  it  item
Bab  qd  quad
Bab  qq  qquad

Baba lab	label
Bab  la	label 	    	    	NONE 0 0 {
Bab  nn	nonumber

"AbDef  <buffer> begin{[a-z]\\+\\*\\?}\\\\ la label NONE [\ \t]

Babo xr	xrightarrow
Babo xl	xleftarrow

Baba ov	overline
Baba ol	overline
Baba un	underline
Baba ul	underline
Baba ob	overbrace
Baba ub	underbrace

Bab  su		sum
Bab  pr		prod
Bab  sb		subseteq
Bab  subs	subseteq
Bab  sp		supseteq
Bab  sups	supseteq
Bab  bcu	bigcup
Bab  bcup	bigcup
Bab  bca	bigcap
Bab  bcap	bigcap
Bab  cu		cup
Bab  ca		cap
Bab  es		emptyset
Bab  co		colon
Bab  co		color 	    	    	NONE 0 0 {
Bab  sm		setminus
Bab  we		wedge

Baba fr		frac
Babo sq		sqrt
Baba tsub	textsubscript
Baba tsup	textsuperscript

Bab ti	tilde
Baba wt	widetilde
Bab ba	bar
Bab ha	hat
Baba wh	widehat
Bab do	dot
Bab dd	ddot

Babo pb	parbox
Baba rb	raisebox

" References
Bab  eq	eqref{e:		NONE .
Bab  cr	cref			NONE 0 0 {
Baba crr	crefrange
Babo ci	cite
Bab  cl	citelist{\cite{		NONE .


" Bab	par	partial
Bab pa	partial NONE 0 0 _
Bab pa	partial NONE 0 0 ^
Bab pa	partial NONE 0 0 \ 
Bab pa	partial NONE 0 0 \\

unlet! s
for s in  [['ai','i'], 'j', 'k', ['ah', 'h'],
	    \ 'r', 's', 't', 'x', 'y', 'z', '0', '1', '2', '3' ]
    let [v, vx] = (type(s) == type('') ? [s, s] : s )
    exe 'Bab' 'p'.v 'partial_'.vx
    exe 'Bab' 'p'.v.'2' 'partial_'.vx.'^2'
    exe 'Bab' 'p'.v.'3' 'partial_'.vx.'^3'
    unlet s
endfor

Bab ir    int_\R
Bab ir2   int_{\R^2}
Bab ir3   int_{\R^3}
Bab ird   int_{\R^d}
Bab irn   int_{\R^n}
Bab irp   int_{\R^+}
Bab ir    int_{\R	    NONE 0 0 ^
Bab iz    int_0^	    NONE [\ \t^]
Bab iz1   int_0^1
Bab izt   int_0^t
Bab izT   int_0^T
Bab izi   int_0^\infty
"Bab int	    int_{	    NONE 0 0 -

Bab qu	question
Bab pa	part

Bab	oo	infty
Bab st	star
Bab cd	cdot

Bab fr12	frac{1}{2}
Bab fr13	frac{1}{3}
Bab fr14	frac{1}{4}
Bab fr15	frac{1}{5}
Bab fr16	frac{1}{6}
Bab fr17	frac{1}{7}
Bab fr18	frac{1}{8}
Bab fr19	frac{1}{9}

Bab fr1	frac{1}{    		NONE [\ \t{]
Bab fr2	frac{2}{    		NONE [\ \t{]
Bab fr3	frac{3}{    		NONE [\ \t{]
Bab fr4	frac{4}{    		NONE [\ \t{]
Bab fr5	frac{5}{    		NONE [\ \t{]
Bab fr6	frac{6}{    		NONE [\ \t{]
Bab fr7	frac{7}{    		NONE [\ \t{]
Bab fr8	frac{8}{    		NONE [\ \t{]
Bab fr9	frac{9}{    		NONE [\ \t{]
" }}}

" Limits of sums and integrals
" {{{
command! -nargs=+ Lab	:AbDef  <buffer> _ <args>
command! -nargs=+ Sbab	:AbDef  <buffer> [_^] <args>

" Sums
for s in ['0', '1']
    unlet! en
    for en in [ 'n', 'N', 'd', ['oo','\infty'], ]
	let [e, ex] = (type(en) == type('') ? [en, en] : en )
	exe 'Lab' s.e s.'^{'.ex.'}'
	for v in ['i', 'j', 'k']
	    exe 'Lab' v.s.e '{'.v.'='.s.'}^{'.ex.'}'
	endfor
	unlet en
    endfor
endfor
unlet s

" Integrals
for sn in [ ['mi', '-\infty'], ['moo','-\infty'],
	    \ ['mp', '-\pi'], ['m1','-1'], '0' ]
    let [s, sx] = (type(sn) == type('') ? [sn, sn] : sn )
    for en in [ 't', 'T', ['p','\pi'], '0', '1',
		\ ['oo', '\infty'], ['i', '\infty'] ]
	let [e, ex] = (type(en) == type('') ? [en, en] : en )
	exe 'Lab' s.e '{'.sx.'}^{'.ex.'}'
	unlet en
    endfor
    unlet sn
endfor

" Limits
for v in [ 'x', 'y', 'z', 't', 's' ]
    for ln in [ '0', '1', ['moo','-\infty'], ['mp', '-\pi'], ['m1','-1'],
	    \ ['p','\pi'], ['oo', '\infty'], 'a']
	let [l, lx] = (type(ln) == type('') ? [ln, ln] : ln )
	exe 'Lab' v.l '{'.v.'\to\ '.lx.'}'
	unlet ln
    endfor
endfor
Lab e0 {\\epsilon\\to\ 0}
unlet v l lx

unlet! s sx sn
for s in ['i', 'j', 'k', 'm', 'n']
    exe 'Sbab' s.'p1' '{'.s.'+1}'
    exe 'Sbab' s.'m1' '{'.s.'-1}'
endfor
" }}}


" Environments
" {{{
function! s:new_env( fold, star, ab, envname ) "{{{
    " No suffix expansions
    let begin = 'begin{'.a:envname.'}' . ( a:fold == 1 ? '%{{{' : '' )
    let end = "\n\\end{".a:envname.'}'
		\ . ( a:fold == 1 ? '%}}}' : '' )
    call AbDefineExpansion( '<buffer>', '\\', a:ab,
		\ begin, end, "[ \t]" )
    call AbDefineExpansion( '<buffer>', '\v\\(begin|end)\{', a:ab[1:],
		\ a:envname, '', "[[:space:]{]" )

    " Star version
    if a:star
	let begin = 'begin{'.a:envname.'*}' . ( a:fold == 1 ? '%{{{' : '' )
	let end = "\n\\end{".a:envname.'*}'
		    \ . ( a:fold == 1 ? '%}}}' : '' )
	call AbDefineExpansion( '<buffer>', '\\', a:ab,
		    \ begin, end, 1, 0, '*' )
    endif

    " Do the optional argument version
    let begin = 'begin{'.a:envname.'}'
    let end = ( a:fold == 1 ? ']%{{{' : '' )
		\ . "\n\\end{".a:envname.'}'
		\ . ( (a:fold == 1) ? '%}}}' : '' )
    call AbDefineExpansion( '<buffer>', '\\', a:ab,
		\ begin, end, 0, 0, '[' )

    " Do the argument version
    let begin = 'begin{'.a:envname.'}'
    let end = ( a:fold == 1 ? '}%{{{' : '' )
		\ . "\n\\end{".a:envname.'}'
		\ . ( (a:fold == 1) ? '%}}}' : '' )
    call AbDefineExpansion( '<buffer>', '\\', a:ab,
		\ begin, end, 0, 0, '{' )
    
    " Do the label version
    let begin = 'begin{'.a:envname.'}\label{'
    let end = ( a:fold == 1 ? '}%{{{' : '}' )
		\ . "\n\\end{".a:envname.'}'
		\ . ( (a:fold == 1) ? '%}}}' : '' )
    call AbDefineExpansion( '<buffer>', '\\', a:ab,
		\ begin, end, 1, 0, '\' )
endfunction"}}}

" Complete environment
command! -nargs=+ Cenv :call s:new_env( 0, 0, <f-args> )
"
" Complete environment with starred version
command! -nargs=+ Cenvs :call s:new_env( 0, 1, <f-args> )

" Complete environment with fold markers.
command! -nargs=+ Cenvf :call s:new_env( 1, 0, <f-args> )

" Complete environment with fold markers and starred version
command! -nargs=+ Cenvfs :call s:new_env( 1, 1, <f-args> )

" Math equation environments
Cenvs	beq	equation
Cenvs	bal	align
Cenvs	bali	align
Cenvs	bga	gather
Cenvs	bfl	flalign
Cenvs	bml	multline
Cenvs	bmu	multline
Cenvs	bala	alignat
Cenvs	balat	alignat

" Math alignment building blocks
Cenv	bsp	split
Cenv	bald	aligned
Cenv	bgad	gathered
Cenvs	bca	cases
Cenvs	bdc	dcases
Cenvs	bdca	dcases
Cenv	bmld	multlined
Cenv	bmud	multlined

" Math environments
Cenv	bpm	pmatrix
Cenv	bma	matrix

" Theorems, etc.
Cenvs	bth	theorem
Cenvs	ble     lemma
Cenvs	bpp	proposition
Cenvs	bco     corollary
Cenvs	bconj   conjecture
Cenvs	bcj	conjecture
"Cenv	bqu	question
Cenvs	bde     definition
Cenvs	bre     remark
Cenvs	bex	example
Cenv	bpr     proof
Cenvs	bpb     problem

" Misc environments
Cenv	bdo     document
Cenv	bce     center
Cenv	brl     raggedleft
Cenv	brr     raggedright
Cenv	ben     enumerate
Cenv	bit     itemize
Cenv	bcen    compactenum
Cenv	bcit    compactitem
Cenv	bab     abstract
Cenv	bmp     minipage
Cenv	bmi     minipage
Cenv	bquo	quote
Cenv	bque	questions
Cenv	bqu	quote
Cenv	bpa	parts
Cenv	bfi     figure

" Automatically close environments
function! CloseEnv()
    let [env, fold] = exists( '*TexACGetEnvName' ) ? TexACGetEnvName() : ['', '']
    if env == ''
	return 'end{'
    else
	normal <<
	return 'end{'.env.'}'. tr( fold, '{', '}' )
    endif
endfunction
Bab	en	CloseEnv() NONE [\ \t] 1
" }}}

" Greek letters
" {{{
function! s:greek( ab, exp )
    if a:ab != a:exp
	call AbDefineExpansion( '<buffer>', '\\',
		    \ a:ab, a:exp )
    endif

    " Suffixes
    call AbDefineExpansion( '<buffer>', '\\',
		\ a:ab.'t', 'tilde \'.a:exp )
    call AbDefineExpansion( '<buffer>', '\\',
		\ a:ab.'h', 'hat \'.a:exp )
    call AbDefineExpansion( '<buffer>', '\\',
		\ a:ab.'w', 'widehat{\'.a:exp.'}')
    call AbDefineExpansion( '<buffer>', '\\',
		\ a:ab.'b', 'bar \'.a:exp )
    call AbDefineExpansion( '<buffer>', '\\',
		\ a:ab.'d', 'dot \'.a:exp )
    call AbDefineExpansion( '<buffer>', '\\',
		\ a:ab.'dd', 'ddot \'.a:exp )

    " Prefixes.
    call AbDefineExpansion( '<buffer>', '\\',
		\ 'ti'.a:ab, 'tilde \'.a:exp )
    call AbDefineExpansion( '<buffer>', '\\',
		\ 'ha'.a:ab, 'hat \'.a:exp )
    call AbDefineExpansion( '<buffer>', '\\',
		\ 'wh'.a:ab, 'widehat{\'.a:exp.'}' )
    call AbDefineExpansion( '<buffer>', '\\',
		\ 'ba'.a:ab, 'bar \'.a:exp )
    call AbDefineExpansion( '<buffer>', '\\',
		\ 'do'.a:ab, 'dot \'.a:exp )
    call AbDefineExpansion( '<buffer>', '\\',
		\ 'dd'.a:ab, 'ddot \'.a:exp )

    call AbDefineExpansion( '<buffer>', '\\',
		\ 'd'.a:ab, ', d\'.a:exp )
    call AbDefineExpansion( '<buffer>', '\\',
		\ 'p'.a:ab, 'partial_\'.a:exp )

    " Suffixing 2--9 gets an automatic superscript
    for i in range(2, 9)
	call AbDefineExpansion( '<buffer>', '\\',
		\ a:ab.i, a:exp.'^'.i )
    endfor

    " Suffixing 0--1 gets an automatic subscript
    for i in [0, 1]
	call AbDefineExpansion( '<buffer>', '\\',
		\ a:ab.i, a:exp.'_'.i )
    endfor
endfunction
command! -nargs=+ Gab	:call s:greek( <f-args> )

" Lower case (ordered as in "texdoc symbols")
Gab al	alpha
Gab be	beta
Gab ga	gamma
Gab de	delta
Gab ep	epsilon
Gab ve	varepsilon
Gab ze	zeta
Gab et	eta
Gab th	theta
Gab vt	vartheta
Gab io	iota
Gab ka	kappa
Gab la	lambda
Gab mu	mu
Gab nu	nu
Gab xi	xi
"Gab o   o
Gab pi	pi
Gab vpi	varpi
Gab rh	rho
Gab vr	varrho
Gab si	sigma
Gab vs	varsigma
Gab ta	tau
Gab up	upsilon
Gab ph	phi
Gab vp	varphi
Gab ch	chi
Gab ps	psi
Gab om	omega

" Upper case
Gab Ga	Gamma
Gab De	Delta
Gab Th	Theta
Gab La	Lambda
Gab Xi	Xi
Gab Pi	Pi
Gab Si	Sigma
Gab Up	Upsilon
Gab Ph	Phi
Gab Ps	Psi
Gab Om	Omega

" Clear out common conflicts
Bab psi NONE
Bab det NONE

" }}}

" Abbreviations for spaces (Lp, Rd, etc.)
" {{{
function! s:define_space( abbrv, rep, ... )
    call AbDefineExpansion( '<buffer>', '\v([^_^]|^)', a:abbrv, a:rep )
    call AbDefineExpansion( '<buffer>', '[_^]', a:abbrv, '{'.a:rep.'}' )
    call AbDefineExpansion( '<buffer>', '[_^]', a:abbrv, '{'.a:rep, '',
		\ 0, 0, '(' )

    if a:0 > 0
	let l:rep = a:1
	call AbDefineExpansion( '<buffer>', '\v([^_^]|^)', a:abbrv, l:rep,
		    \ '', 0, 0, '{' )
	call AbDefineExpansion( '<buffer>', '[_^]', a:abbrv, '{'.l:rep,
		    \ '', 0, 0, '{' )
    endif
endfunction

command! -nargs=+ Sab :call s:define_space( <f-args> )

Sab Lp	L^p L^
Sab Lq	L^q
Sab Lr	L^r
Sab L1	L^1
Sab L2	L^2
Sab Loo	L^\infty

Sab lp	\ell^p \ell^
Sab lq	\ell^q
Sab lr	\ell^r
Sab l1	\ell^1
Sab l2	\ell^2
Sab loo	\ell^\infty

Sab Ck	C^k C^
Sab C1	C^1
Sab C2	C^2
Sab Coo	C^\infty

" Requires \newcommand{\R}{\mathbb{R}}
Sab Rd	\R^d \R^
Sab Rm	\R^m \R^
Sab Rn	\R^n \R^
Sab R2	\R^2
Sab R3	\R^3
Sab R4	\R^4

" Requires \newcommand{\T}{\mathbb{T}}
Sab Td	\T^d \T^
Sab Tm	\T^m \T^
Sab Tn	\T^n \T^
Sab T2	\T^2
Sab T3	\T^3
"Sab T4	\T^4

Sab Hs	H^s H^
Sab H1	H^1
Sab H2	H^2
Sab Hm1	H^{-1}

" }}}

" Parenthesis and norms. Requires \DeclarePairedDelimiter{\paren}{(}{)}
" {{{
function! s:new_delim( ab, name )
    call AbDefineExpansion( '<buffer>', '\\', a:ab, a:name.'{', '', '[ \t{]' )
    call AbDefineExpansion( '<buffer>', '\\', a:ab, a:name.'[\', '', 1, 0, '[' )
    call AbDefineExpansion( '<buffer>', '\\', a:ab.'b',
		\ a:name.'[\big]{', '', '[ \t{]' )
    call AbDefineExpansion( '<buffer>', '\\', a:ab.'B',
		\ a:name.'[\Big]{', '', '[ \t{]' )
endfunction
command! -nargs=+ Dab	:call s:new_delim( <f-args> )
    
Dab pa	    paren
Dab se	    set
Dab br	    brak
Dab fl	    floor
Dab ab	    abs
Dab no	    norm
" }}}

" Referencing equations, lemmas etc.
" {{{
function! s:define_reference( ab, rep )
    call AbDefineExpansion( '<buffer>', '\v\\@<!', a:ab, a:rep, '', 1, 0, '~' )
endfunction
command! -nargs=+ Dref :call s:define_reference( <f-args> )

Dref aps    appendices~\ref{s:
Dref Aps    Appendices~\ref{s:
Dref ap	    appendix~\ref{s:
Dref Ap	    Appendix~\ref{s:
Dref cos    corollaries~\ref{c:
Dref Cos    Corollaries~\ref{c:
Dref co	    corollary~\ref{c:
Dref Co	    Corollary~\ref{c:
Dref de	    definition~\ref{d:
Dref De	    Definition~\ref{d:
Dref des    definitions~\ref{d:
Dref Des    Definitions~\ref{d:
Dref eq	    equation~\eqref{e:
Dref Eq	    Equation~\eqref{e:
Dref eqs    equations~\eqref{e:
Dref Eqs    Equations~\eqref{e:
Dref fi	    figure~\ref{f:
Dref Fi	    Figure~\ref{f:
Dref fis    figures~\ref{f:
Dref Fis    Figures~\ref{f:
Dref ie	    inequality~\eqref{e:
Dref Ie	    Inequality~\eqref{e:
Dref ies    inequalities~\eqref{e:
Dref Ies    Inequalities~\eqref{e:
Dref le	    lemma~\ref{l:
Dref Le	    Lemma~\ref{l:
Dref les    lemmas~\ref{l:
Dref Les    Lemmas~\ref{l:
Dref pb	    problem~\ref{p:
Dref Pb	    Problem~\ref{p:
Dref pbs    problems~\ref{p:
Dref Pbs    Problems~\ref{p:
Dref pr	    proposition~\ref{p:
Dref Pr	    Proposition~\ref{p:
Dref prs    propositions~\ref{p:
Dref Prs    Propositions~\ref{p:
Dref re	    remark~\ref{r:
Dref Re	    Remark~\ref{r:
Dref res    remarks~\ref{r:
Dref Res    Remarks~\ref{r:
Dref se	    section~\ref{s:
Dref Se	    Section~\ref{s:
Dref ses    sections~\ref{s:
Dref Ses    Sections~\ref{s:
Dref sy     system~\eqref{e:
Dref th	    theorem~\ref{t:
Dref Th	    Theorem~\ref{t:
Dref ths    theorems~\ref{t:
Dref Ths    Theorems~\ref{t:

" }}}

" Colors
" {{{
function! s:new_color( color, sab, ab ) "{{{
    call AbDefineExpansion( '<buffer>', '\\', 'co'.a:sab,
		\ 'color{'.a:color.'}', '', '[ \t]' )
    call AbDefineExpansion( '<buffer>', '\\', 'tc'.a:sab,
		\ 'textcolor{'.a:color.'}{', '', '[ \t{]' )
    if len( a:sab ) > 1
	call AbDefineExpansion( '<buffer>', '\v\\%(text)?color\{', a:sab,
		    \ a:color, '', '[ \t]' )
    endif
    call AbDefineExpansion( '<buffer>', '\v\\%(text)?color\{', a:ab,
		\ a:color, '', '[ \t]' )
endfunction " }}}

command! -nargs=+ ColDef :call s:new_color( <f-args> )

Bab	    tc	textcolor{		NONE [\ t{]

ColDef  blue    b bl
ColDef  red	    r re
ColDef  orange  o or
ColDef  green   g gr
ColDef  black   k bk
"}}}

" Depreciated constructs
" {{{
"iab <buffer> $$	\begin{equation*}

" function! DollarDollar()
"     if synIDattr( synID( line('.'), col('.'), 0 ), 'name' ) =~ '\C^texMathZone'
" 	normal <<
" 	return '\end{equation*}'
"     else
" 	return '\begin{equation*}'
"     fi
" endfunction
" AbDef <buffer> .\? $$ DollarDollar() NONE [\ \t] 1

AbDef <buffer> .\? $$ \begin{equation*} \n\end{equation*} [\ \t] 0

" }}}

" Greek letters
" Disabled for now. The \al notation is more intuitive (even though it
" involves more typing).
if 0 "{{{
    inoremap <buffer> "a	\alpha
    inoremap <buffer> "b	\beta
    inoremap <buffer> "c	\chi
    inoremap <buffer> "d	\delta
    inoremap <buffer> "e	\varepsilon
    inoremap <buffer> "f	\varphi
    inoremap <buffer> "g	\gamma
    inoremap <buffer> "i	\iota
    inoremap <buffer> "k	\kappa
    inoremap <buffer> "l	\lambda
    inoremap <buffer> "m	\mu
    inoremap <buffer> "n	\nu
    inoremap <buffer> "o	\omega
    inoremap <buffer> "p	\psi
    inoremap <buffer> "r	\rho
    inoremap <buffer> "s	\sigma
    inoremap <buffer> "t	\theta
    inoremap <buffer> "u	\upsilon
    inoremap <buffer> "x	\xi
    inoremap <buffer> "z	\zeta

    inoremap <buffer> "ve	\epsilon
    inoremap <buffer> "vf	\phi
    inoremap <buffer> "vp	\varpi
    inoremap <buffer> "vr	\varrho
    inoremap <buffer> "vs	\varsigma
    inoremap <buffer> "vt	\vartheta

    " Unmapped
    "inoremap <buffer> "e	\eta
    "inoremap <buffer> "p	\pi
    "inoremap <buffer> "t	\tau
endif "}}}

let b:loaded_tex_ab_prefix = 1
