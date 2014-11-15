" Vim plugin to conditionally expand abbreviations on a matching prefix.
" Maintainer:	GI <gi1242@nospam.com> (replace nospam with gmail)
" Created:	Sat 05 Jul 2014 08:46:04 PM WEST
" Last Changed:	Fri 14 Nov 2014 12:02:47 AM EST
" Version:	0.1
"
" Description:
"   Various TeX abbreviations and mappings in insert mode.

"
" Non math mode, standard abbreviations.
"
iab <buffer> Calderon	Calder\'on
iab <buffer> Cordoba	C\'ordoba
iab <buffer> Cesaro	Ces\`aro
iab <buffer> Fejer	Fej\'er
iab <buffer> Holder	H\<c-v>"older
iab <buffer> Hormander	H\<c-v>"ormander
iab <buffer> Ito	It\^o
iab <buffer> Jenee	Jen\'ee
iab <buffer> Levy	L\'evy
iab <buffer> Poincare	Poincar\'e
iab <buffer> Peclet	P\'eclet
iab <buffer> Rozovskii	Rozovski{\u\i}
iab <buffer> Szego	Szeg\<c-v>"o
iab <buffer> Sverak	\v Sver\'ak
iab <buffer> cadlag	c\`adl\`ag

" Conditional abbreviations
if exists( 'g:loaded_ab_prefix' ) "{{{
    command! -nargs=+ Bab	:AbDef  <buffer> \\\\ <args>

    function! s:new_env( fold, star, ab, envname ) "{{{
	" No suffix expansions
	let begin = 'begin{'.a:envname.'}' . ( a:fold == 1 ? '%{{{' : '' )
	let end = '\n\end{'.a:envname.'}'  . ( a:fold == 1 ? '%}}}' : '' )
	call AbDefineExpansion( '<buffer>', '\\', a:ab,
		    \ begin, end, "[ \t]" )
	call AbDefineExpansion( '<buffer>', '\v\\(begin|end)\{', a:ab[1:],
		    \ a:envname, '', "[[:space:]{]" )

	" Star version
	if a:star
	    let begin = 'begin{'.a:envname.'*}' . ( a:fold == 1 ? '%{{{' : '' )
	    let end = '\n\end{'.a:envname.'*}'  . ( a:fold == 1 ? '%}}}' : '' )
	    call AbDefineExpansion( '<buffer>', '\\', a:ab,
			\ begin, end, 1, 0, '*' )
	endif

	" Do the optional argument version
	let begin = 'begin{'.a:envname.'}'
	let end = ( a:fold == 1 ? ']%{{{' : ']' )
	    \ . '\n\end{'.a:envname.'}'
	    \ . ( (a:fold == 1) ? '%}}}' : '' )
	call AbDefineExpansion( '<buffer>', '\\', a:ab,
		    \ begin, end, 0, 0, '[' )

	" Do the argument version
	let begin = 'begin{'.a:envname.'}'
	let end = ( a:fold == 1 ? '}%{{{' : '}' )
	    \ . '\n\end{'.a:envname.'}'
	    \ . ( (a:fold == 1) ? '%}}}' : '' )
	call AbDefineExpansion( '<buffer>', '\\', a:ab,
		    \ begin, end, 0, 0, '{' )
	
	" Do the label version
	let begin = 'begin{'.a:envname.'}\label{'
	let end = ( a:fold == 1 ? '}%{{{' : '}' )
	    \ . '\n\end{'.a:envname.'}'
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
    Cenvfs	bth	theorem
    Cenvfs	ble     lemma
    Cenvfs	bprop   proposition
    Cenvfs	bco     corollary
    Cenvfs	bconj   conjecture
    "Cenvf	bqu	question
    Cenvfs	bde     definition
    Cenvfs	bre     remark
    Cenvfs	bex	example
    Cenvf	bpr     proof

    " Misc environments
    Cenv	bdo     document
    Cenv	bce     center
    Cenv	brl     raggedleft
    Cenv	brr     raggedright
    Cenv	ben     enumerate
    Cenv	bit     itemize
    Cenv	bcen    compactenum
    Cenv	bcit    compactitem
    Cenvf	bab     abstract
    Cenv	bmp     minipage
    Cenv	bmi     minipage
    Cenv	bquo	quote
    Cenv	bqu	questions
    Cenv	bpa	parts

    " Automatically close environments
    function! CloseEnv()
	let [env, fold] = exists( '*TexGetEnvName' ) ? TexGetEnvName() : ['', '']
	if env == ''
	    return 'end{'
	else
	    normal <<
	    return 'end{'.env.'}'. tr( fold, '{', '}' )
	endif
    endfunction
    Bab	en	CloseEnv() NONE [\ \t] 1

    " Misc commands that take an argument.
    " (Insert trailing { forcibly, and ignore next typed char)
    "Bab	beg	begin{			NONE [[:space:]{] 
    Bab	beg	begin{		    	NONE .
    Bab	sec	section{            	NONE .
    Bab	ss	subsection{	    	NONE .
    Bab	sss	subsubsection{      	NONE .
    Bab	para	paragraph{          	NONE .
    Bab	sp	subparagraph{       	NONE .

    Bab	tc	textcolor{		NONE .
    Bab	mb	mathbb
    Bab	mc	mathcal
    Bab	ms	mathscr
    Bab	li	linewidth	    	NONE [\ \t]
    Bab	inc	includegraphics[width=	NONE [\ \t]
    Bab	dis	displaystyle
    Bab tb	textbf{			NONE .
    Bab em	emph{			NONE .
    "Bab tit	textit{			NONE .
    Bab it	item

    Bab	lab	label 	    	    	NONE [\ \t]
    Bab nn	nonumber

    "AbDef  <buffer> begin{[a-z]\\+\\*\\?}\\\\ la label NONE [\ \t]

    Bab	xr	xrightarrow{   	    	NONE .
    Bab	xr	xrightarrow   	    	NONE 0 0 [
    Bab	xl	xleftarrow{    	    	NONE .
    Bab	xl	xleftarrow    	    	NONE 0 0 [
    Bab ov	overline{ 		NONE .
    Bab un	underline{ 		NONE .
    Bab ul	underline{ 		NONE .
    Bab fr	frac{			NONE .
    Bab sq	sqrt			NONE 0 0 [
    Bab sq	sqrt{			NONE .
    Bab tsub	textsubscript{		NONE .
    Bab tsup	textsuperscript{	NONE .
    Bab ti	tilde
    Bab ba	bar
    Bab do	dot

    " References
    Bab eq	eqref{eqn		NONE .
    Bab cre	cref{	    		NONE .
    Bab crr	crefrange{  		NONE .
    Bab ci	cite{bbl    		NONE .
    Bab ci	cite	    		NONE 0 0 [
    Bab cl	citelist{\cite{bbl	NONE .


    Bab	del	partial
    Bab	di	partial_i
    Bab	dj	partial_j
    Bab	dk	partial_k
    Bab	dr	partial_r
    Bab	ds	partial_s
    Bab	dt	partial_t
    Bab	dx	partial_x
    Bab	dy	partial_y
    Bab	dz	partial_z
    Bab	d0	partial_0
    Bab	d1	partial_1
    Bab	d2	partial_2
    Bab	d3	partial_3
    Bab	d4	partial_4
    Bab	d5	partial_5
    Bab	d6	partial_6
    Bab	d7	partial_7
    Bab	d8	partial_8
    Bab	d9	partial_9
    Bab	dth	partial_\theta
    Bab cd	cdot

    Bab qu	question
    Bab pa	part

    Bab	oo	infty

    Bab ha	frac{1}{2}
    Bab ot	frac{1}{3}
    Bab of	frac{1}{4}

    if 1 " Greek letters %{{{
	" Lower case (ordered as in "texdoc symbols")
	Bab al	alpha
	Bab be	beta
	Bab ga	gamma
	Bab de	delta
	Bab ep	epsilon
	Bab ve	varepsilon
	Bab ze	zeta
	Bab et	eta
	Bab th	theta
	Bab vt	vartheta
	Bab io	iota
	Bab ka	kappa
	Bab la	lambda
	"Bab mu	mu
	"Bab nu	nu
	"Bab xi	xi
	"ab  o  o
	"Bab pi	pi
	Bab vpi	varpi
	Bab rh	rho
	Bab vr	varrho
	Bab si	sigma
	Bab vs	varsigma
	Bab ta	tau
	Bab up	upsilon
	Bab ph	phi
	Bab vp	varphi
	Bab ch	chi
	Bab ps	psi
	Bab om	omega

	" Upper case
	Bab Ga	Gamma
	Bab De	Delta
	Bab Th	Theta
	Bab La	Lambda
	"Bab Xi	Xi
	"Bab Pi	Pi
	Bab Si	Sigma
	Bab Up	Upsilon
	Bab Ph	Phi
	Bab Ps	Psi
	Bab Om	Omega
    endif " }}}

    " Abbreviations for spaces (Lp, Rd, etc.)
    function! s:define_space( abbrv, rep )
	call AbDefineExpansion( '<buffer>', '\v([^_^]|^)', a:abbrv, a:rep )
	call AbDefineExpansion( '<buffer>', '[_^]', a:abbrv, '{'.a:rep.'}' )
	call AbDefineExpansion( '<buffer>', '[_^]', a:abbrv, '{'.a:rep, ')}',
		    \ 0, 0, '(' )
    endfunction
    command! -nargs=+ Sab :call s:define_space( <f-args> )

    Sab Lp	L^p
    Sab Lq	L^q
    Sab Lr	L^r
    Sab L1	L^1
    Sab L2	L^2
    Sab Loo	L^\infty

    Sab lp	\ell^p
    Sab lq	\ell^q
    Sab lr	\ell^r
    Sab l1	\ell^1
    Sab l2	\ell^2
    Sab loo	\ell^\infty

    " Requires \newcommand{\R}{\mathbb{R}}
    Sab Rd	\R^d
    Sab Rn	\R^n
    Sab R2	\R^2
    Sab R3	\R^3
    Sab R4	\R^4

    Sab H1	H^1
    Sab H2	H^2
    Sab Hm1	H^{-1}

    AbDef <buffer> . Lpp	{L^{	}}	[\ \t]
    AbDef <buffer> . lpp	{\ell^{ }}	[\ \t]
    AbDef <buffer> . rd		{\R^{	}}	[\ \t]
    AbDef <buffer> . rn		{\R^{	}}	[\ \t]

    " Parenthesis and norms. Requires \DeclarePairedDelimiter{\paren}{(}{)}
    Bab pa	    paren	    NONE [\ \t]
    Bab pab	    paren[\big]{    NONE [{\ \t]
    Bab paB	    paren[\Big]{    NONE [{\ \t]
    Bab se	    set		    NONE [\ \t]
    Bab seb	    set[\big]{	    NONE [{\ \t]
    Bab seB	    set[\Big]{	    NONE [{\ \t]
    Bab br	    brak	    NONE [\ \t]
    Bab brb	    brak[\big]{	    NONE [{\ \t]
    Bab brB	    brak[\Big]{	    NONE [{\ \t]
    Bab ab	    abs		    NONE [\ \t]
    Bab abb	    abs[\big]{	    NONE [{\ \t]
    Bab abB	    abs[\Big]{	    NONE [{\ \t]
    Bab no	    norm	    NONE [\ \t]
    Bab nob	    norm[\big]{	    NONE [{\ \t]
    Bab noB	    norm[\Big]{	    NONE [{\ \t]

    " Referencing equations, lemmas etc.
    " {{{
    function! s:define_reference( ab, rep )
	call AbDefineExpansion( '<buffer>', '.\?', a:ab, a:rep, '', 1, 0, '~' )
    endfunction
    command! -nargs=+ Dref :call s:define_reference( <f-args> )

    Dref th	theorem~\ref{thm
    Dref Th	Theorem~\ref{thm
    Dref ths    theorems~\ref{thm
    Dref Ths    Theorems~\ref{thm
    Dref le	lemma~\ref{lma
    Dref Le	Lemma~\ref{lma
    Dref les    lemmas~\ref{lma
    Dref Les    Lemmas~\ref{lma
    Dref pr	proposition~\ref{ppn
    Dref Pr	Proposition~\ref{ppn
    Dref eq	equation~\eqref{eqn
    Dref Eq	Equation~\eqref{eqn
    Dref eqs    equations~\eqref{eqn
    Dref Eqs    Equations~\eqref{eqn
    Dref ieq    inequality~\eqref{eqn
    Dref Ieq	Inequality~\eqref{eqn
    Dref ieqs  	inequalities~\eqref{eqn
    Dref ieqs  	inequalities~\eqref{eqn
    Dref sy     system~\eqref{eqn
    Dref se	section~\ref{sxn
    Dref ses	sections~\ref{sxn
    " }}}
endif "}}}

" Depreciated constructs
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
