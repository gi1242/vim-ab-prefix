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
    $$

produces

    By Fourier inversion (theorem~\ref{thmFinv}),
    \begin{equation*}
        \varphi(x) = \int_{\R^2} e^{-2\pi i x \cdot \xi} \hat \vp(\xi) \, d\xi.
    \end{equation*}
