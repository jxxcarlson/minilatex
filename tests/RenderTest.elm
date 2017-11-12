module RenderTest exposing (..)

import MiniLatex.Parser exposing (..)
import MiniLatex.Render exposing (..)
import MiniLatex.LatexState
import Parser exposing (run)


-- http://package.elm-lang.org/packages/elm-community/elm-test/latest

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, list, int, string)
import Test exposing (..)


renderString2 parser str =
    renderString parser MiniLatex.LatexState.emptyLatexState str


suite : Test
suite =
    describe "MiniLatex Render"
        -- Nest as many descriptions as you like.
        [ test "(1) Words (plain text)" <|
            \_ ->
                let
                    renderOutput =
                        renderString2 parse "This is a test."

                    expectedOutput =
                        "This is a test."
                in
                    Expect.equal renderOutput expectedOutput
        , test "(2) Comment" <|
            \_ ->
                let
                    renderOutput =
                        renderString2 parse "% This is a comment\n"

                    expectedOutput =
                        ""
                in
                    Expect.equal renderOutput expectedOutput
        , test "(3.1) InlineMath" <|
            \_ ->
                let
                    renderOutput =
                        renderString2 parse "$a^2 = 7$"

                    expectedOutput =
                        " $a^2 = 7$ "
                in
                    Expect.equal renderOutput expectedOutput
        , test "(3.2) DisplayMath" <|
            \_ ->
                let
                    renderOutput =
                        renderString2 parse "$$b^2 = 3$$"

                    expectedOutput =
                        "$$b^2 = 3$$"
                in
                    Expect.equal renderOutput expectedOutput
        , test "(3.3) DisplayMath (Brackets)" <|
            \_ ->
                let
                    renderOutput =
                        renderString2 parse "\\[b^2 = 3\\]"

                    expectedOutput =
                        "$$b^2 = 3$$"
                in
                    Expect.equal renderOutput expectedOutput
        , test "(4.1) parse words and unimplemented macros" <|
            \_ ->
                let
                    renderOutput =
                        renderString2
                            parse
                            "a b c \\foo \\bar{1} \\baz{1}{2}"

                    expectedOutput =
                        "a b c"
                in
                    Expect.equal renderOutput expectedOutput
        , test "(4.2) parse \\italic{a b c}" <|
            \_ ->
                let
                    renderOutput =
                        renderString2
                            parse
                            "\\italic{a b c}"

                    expectedOutput =
                        " <span class=italic>a b c</span>"
                in
                    Expect.equal renderOutput expectedOutput
        , test "(4.3) parse \\italic{a b $c==d$}" <|
            \_ ->
                let
                    renderOutput =
                        renderString2
                            parse
                            "\\italic{a b $c==d$}"

                    expectedOutput =
                        " <span class=italic>a b  $c==d$</span>"
                in
                    Expect.equal renderOutput expectedOutput
        , test "(5.1) Environment" <|
            \_ ->
                let
                    renderOutput =
                        renderString2
                            parse
                            "\\begin{theorem}\nInfinity is \\emph{very} large: $\\infinity^2 = \\infinity$. \\end{theorem}"

                    expectedOutput =
                        "\n<div class=\"environment\">\n<strong>Theorem 0</strong>\n<div class=\"italic\">\n Infinity is  <span class=italic>very</span> large:  $\\infinity^2 = \\infinity$ .\n</div>\n</div>\n"
                in
                    Expect.equal renderOutput expectedOutput
        , test "(5.2) Nested Environment" <|
            \_ ->
                let
                    renderOutput =
                        renderString2
                            parse
                            "\\begin{theorem}\n\\begin{a}x y z\\end{a}\\end{theorem}"

                    expectedOutput =
                        "\n<div class=\"environment\">\n<strong>Theorem 0</strong>\n<div class=\"italic\">\n \n<div class=\"environment\">\n<strong>A</strong>\n<div class=\"italic\">\n x y z\n</div>\n</div>\n\n</div>\n</div>\n"
                in
                    Expect.equal renderOutput expectedOutput
        , test "(5.3) Equation Environment" <|
            \_ ->
                let
                    renderOutput =
                        renderString2
                            parse
                            "\\begin{equation}\n\\int_0^1 x^n dx = \\frac{1}{n+1}\n\\end{equation}"

                    expectedOutput =
                        "\n$$\n\\begin{equation}\n\\int_0^1 x^n dx = \\frac{1}{n+1}\n\\end{equation}\n$$\n"
                in
                    Expect.equal renderOutput expectedOutput
        , test "(6.1) Itemize" <|
            \_ ->
                let
                    renderOutput =
                        renderString2
                            latexList
                            "\\begin{itemize} \\item aaa.\n \\item bbb.\n \\itemitem xx\n\\end{itemize}"

                    expectedOutput =
                        " \n<ul>\n <li class=\"item1\"> aaa.</li>\n <li class=\"item1\"> bbb.</li>\n <li class=\"item2\"> xx</li>\n\n</ul>\n"
                in
                    Expect.equal renderOutput expectedOutput
        , test "(6.2) Tablular" <|
            \_ ->
                let
                    renderOutput =
                        renderString2
                            parse
                            "\\begin{tabular}\n1 & 2 \\\\\n 3 & 4 \\\\\n\\end{tabular}"

                    expectedOutput =
                        "<table>\n <tr>  <td>1</td> <td>2</td> </tr>\n <tr>  <td>3</td> <td>4</td> </tr>\n</table>\n"
                in
                    Expect.equal renderOutput expectedOutput
        , test "(7.1) Equation Label" <|
            \_ ->
                let
                    renderOutput =
                        renderString2
                            parse
                            "\\begin{equation}\n\\label{uncertaintyPrinciple}\n\\left[\\hat p, x\\right] = -i \\hbar\n\\end{equation}"

                    expectedOutput =
                        "\n$$\n\\begin{equation}\n\\label{uncertaintyPrinciple}\n\\left[\\hat p, x\\right] = -i \\hbar\n\\end{equation}\n$$\n"
                in
                    Expect.equal renderOutput expectedOutput
        , test "(X.1) Yada" <|
            \_ ->
                let
                    renderOutput =
                        renderString2
                            latexList
                            "This is MiniLaTeX:\n\\begin{theorem}\nThis is a test: $\\alpha^2 = 7$ \\foo{1}\n\\begin{a}\nla di dah\n\\end{a}\n\\end{theorem}"

                    expectedOutput =
                        " This is MiniLaTeX: \n<div class=\"environment\">\n<strong>Theorem 0</strong>\n<div class=\"italic\">\n This is a test:  $\\alpha^2 = 7$  \\foo{ 1} \n<div class=\"environment\">\n<strong>A</strong>\n<div class=\"italic\">\n la di dah\n</div>\n</div>\n\n</div>\n</div>\n"
                in
                    Expect.equal renderOutput expectedOutput
        , test "(M.1) ellie" <|
            \_ ->
                let
                    renderOutput =
                        renderString2
                            latexList
                            "\\ellie{8tsqnpLx7a1/1}{foo}"

                    expectedOutput =
                        " <iframe src =\"https://ellie-app.com/embed/8tsqnpLx7a1/1\" style = \"width:100%; height:400px; border:0; border-radius: 3px; overflow:hidden;\" sandbox=\"allow-modals allow-forms allow-popups allow-scripts allow-same-origin\" ></iframe>\n<center style=\"margin-top: -10px;\"><a href=\"https://ellie-app.com/8tsqnpLx7a1/1\" target=_blank>foo</a></center>"
                in
                    Expect.equal renderOutput expectedOutput
        , test "(M.2) bozo" <|
            \_ ->
                let
                    renderOutput =
                        renderString2
                            latexList
                            "\\bozo{1}{2}"

                    expectedOutput =
                        " bozo{1}{2}"
                in
                    Expect.equal renderOutput expectedOutput
        ]
