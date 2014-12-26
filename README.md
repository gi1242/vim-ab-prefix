# vim-ab-prefix

This plugin provides the ability to define abbreviations that expand only if a
particular prefix is matched.

The main reason for writing this plugin was to make typing text into TeX
easier. Many default abbreviations for TeX are provided.

## Example.

Typing

    By Fourier inversion (th~Finv}),
    $$
      \vp(x) = \int_R2 e^{-2\pi i x \cdot \xi} \hat \vp(\xi) dxi.

produces

    By Fourier inversion (theorem~\ref{thmFinv}),
    \begin{equation*}
      \varphi(x) = \int_{\R^2} e^{-2\pi i x \cdot \xi} \hat \vp(\xi) \, d\xi.
    \end{equation*}

If you also have the [tex_autoclose](http://www.vim.org/scripts/script.php?script_id=920) plugin installed, then you can type `\en` to close any open environment.

## Notes:

* The default TeX abbreviations don't play nice with the default `indentkeys`.
  Explicitly, you have to remove `]`, `}`, `=\end` and probably `)` from your
  `indentkeys`.
  Here's what I use in `~/.vim/after/indent/tex.vim`:

        setlocal indentexpr=LatexBox_TexIndent()
        setlocal indentkeys=o,O,=\\item,0\\

        setl ai si

  This is assuming you have [LaTeX Box] installed. (If not, comment out the
  `indentexpr` setting.)

## Links.

* [Github page](https://github.com/gi1242/vim-ab-prefix)

* [Vim script page](http://www.vim.org/scripts/script.php?script_id=5049)

[LaTeX Box]: http://www.vim.org/scripts/script.php?script_id=3109
