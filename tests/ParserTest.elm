module ParserTest exposing (..)

import MiniLatex.Parser exposing (..)
import Parser exposing (run)


-- http://package.elm-lang.org/packages/elm-community/elm-test/latest

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, list, int, string)
import Test exposing (..)


suite : Test
suite =
    describe "MiniLatex Parser"
        -- Nest as many descriptions as you like.
        [ test "(1) Comment" <|
            \_ ->
                let
                    parsedInput =
                        run parse "% This is a comment\n"

                    expectedOutput =
                        Ok (Comment "% This is a comment\n")
                in
                    Expect.equal parsedInput expectedOutput
        , test "(2) InlineMath" <|
            \_ ->
                let
                    parsedInput =
                        run parse "$a^2 = 7$"

                    expectedOutput =
                        Ok (InlineMath "a^2 = 7")
                in
                    Expect.equal parsedInput expectedOutput
        , test "(3) DisplayMath" <|
            \_ ->
                let
                    parsedInput =
                        run parse "$$b^2 = 3$$"

                    expectedOutput =
                        Ok (DisplayMath "b^2 = 3")
                in
                    Expect.equal parsedInput expectedOutput
        , test "(4) DisplayMath (Brackets)" <|
            \_ ->
                let
                    parsedInput =
                        run parse "\\[b^2 = 3\\]"

                    expectedOutput =
                        Ok (DisplayMath "b^2 = 3")
                in
                    Expect.equal parsedInput expectedOutput
        , test "(5) latexList words and macros" <|
            \_ ->
                let
                    parsedInput =
                        run latexList "a b \\foo \\bar{1} \\baz{1}{2}"

                    expectedOutput =
                        -- Ok (LatexList ([ LXString "a b", Macro "foo" [], Macro "bar" [ "1" ], Macro "baz" [ "1", "2" ] ]))
                        Ok
                            (LatexList
                                ([ LXString "a b"
                                 , Macro "foo" []
                                 , Macro "bar"
                                    ([ LatexList ([ LXString "1" ]) ])
                                 , Macro "baz"
                                    ([ LatexList ([ LXString "1" ]), LatexList ([ LXString "2" ]) ])
                                 ]
                                )
                            )
                in
                    Expect.equal parsedInput expectedOutput
        , test "(6) Environment" <|
            \_ ->
                let
                    parsedInput =
                        run parse "\\begin{theorem}\nInfinity is \\emph{very} large: $\\infinity^2 = \\infinity$. \\end{theorem}"

                    expectedOutput =
                        Ok
                            (Environment "theorem"
                                (LatexList
                                    ([ LXString "Infinity is"
                                     , Macro "emph" ([ LatexList ([ LXString "very" ]) ])
                                     , LXString "large:"
                                     , InlineMath "\\infinity^2 = \\infinity"
                                     , LXString "."
                                     ]
                                    )
                                )
                            )
                in
                    Expect.equal parsedInput expectedOutput
        , test "(7) Nested Environment" <|
            \_ ->
                let
                    parsedInput =
                        run parse " \\begin{th}  \\begin{a}$$hahah$$\\begin{x}yy\\end{x}\\end{a}\\begin{a} a{1}{2} b c yoko{1} $foo$ yada $$bar$$ a b c \\begin{u}yy\\end{u} \\end{a}\n\\end{th}"

                    expectedOutput =
                        Ok
                            (Environment "th"
                                (LatexList
                                    ([ Environment "a" (LatexList ([ DisplayMath "hahah", Environment "x" (LatexList ([ LXString "yy" ])) ]))
                                     , Environment "a"
                                        (LatexList
                                            ([ LXString "a{1}{2} b c yoko{1}"
                                             , InlineMath "foo"
                                             , LXString "yada"
                                             , DisplayMath "bar"
                                             , LXString "a b c"
                                             , Environment "u" (LatexList ([ LXString "yy" ]))
                                             ]
                                            )
                                        )
                                     ]
                                    )
                                )
                            )
                in
                    Expect.equal parsedInput expectedOutput
        , test "(8) Itemized List" <|
            \_ ->
                let
                    parsedInput =
                        run latexList "\\begin{itemize} \\item aaa.\n \\item bbb.\n \\itemitem xx\n\\end{itemize}"

                    expectedOutput =
                        Ok
                            (LatexList
                                ([ Environment "itemize"
                                    (LatexList
                                        ([ Item 1 (LatexList ([ LXString "aaa." ]))
                                         , Item 1 (LatexList ([ LXString "bbb." ]))
                                         , Item 2 (LatexList ([ LXString "xx" ]))
                                         ]
                                        )
                                    )
                                 ]
                                )
                            )
                in
                    Expect.equal parsedInput expectedOutput
        , test "(T.1) tablerow" <|
            \_ ->
                let
                    parsedInput =
                        run tableRow "1 & 2 & 3\n"

                    expectedOutput =
                        Ok (LatexList ([ LXString "1", LXString "2", LXString "3" ]))
                in
                    Expect.equal parsedInput expectedOutput
        , test "(T.1a) tablerow" <|
            \_ ->
                let
                    parsedInput =
                        run tableRow "Hydrogen & H & 1 & 1.008 \\\\\n"

                    expectedOutput =
                        Ok (LatexList ([ LXString "Hydrogen", LXString "H", LXString "1", LXString "1.008" ]))
                in
                    Expect.equal parsedInput expectedOutput
        , test "(T.2) table" <|
            \_ ->
                let
                    parsedInput =
                        run parse "\\begin{tabular}\n1 & 2 \\\\\n 3 & 4 \\\\\n\\end{tabular}"

                    expectedOutput =
                        Ok
                            (Environment "tabular"
                                (LatexList
                                    ([ LatexList
                                        ([ LXString "1"
                                         , LXString "2"
                                         ]
                                        )
                                     , LatexList
                                        ([ LXString "3"
                                         , LXString "4"
                                         ]
                                        )
                                     ]
                                    )
                                )
                            )
                in
                    Expect.equal parsedInput expectedOutput
        , test "(T.3) table" <|
            \_ ->
                let
                    input =
                        "\\begin{tabular}{l l l l}\nHydrogen & H & 1 & 1.008 \\\\\nHelium & He & 2 & 4.003 \\\\\nLithium & Li & 3 &  6.94 \\\\\nBeryllium & Be & 4 & 9.012 \\\\\n\\end{tabular}"

                    parsedInput =
                        run parse input

                    expectedOutput =
                        Ok
                            (Environment "tabular"
                                (LatexList
                                    ([ LatexList
                                        ([ LXString "Hydrogen", LXString "H", LXString "1", LXString "1.008" ])
                                     , LatexList ([ LXString "Helium", LXString "He", LXString "2", LXString "4.003" ])
                                     , LatexList ([ LXString "Lithium", LXString "Li", LXString "3", LXString "6.94" ])
                                     , LatexList ([ LXString "Beryllium", LXString "Be", LXString "4", LXString "9.012" ])
                                     ]
                                    )
                                )
                            )
                in
                    Expect.equal parsedInput expectedOutput
        , test "(T.3a) table" <|
            \_ ->
                let
                    input =
                        """\\begin{tabular}
Hydrogen & H & 1 & 1.008 \\\\
Helium & He & 2 & 4.003 \\\\
Lithium & Li & 3 &  6.94 \\\\
Beryllium & Be & 4 & 9.012 \\\\
\\end{tabular}
"""

                    parsedInput =
                        run parse input

                    expectedOutput =
                        Ok
                            (Environment "tabular"
                                (LatexList
                                    ([ LatexList
                                        ([ LXString "Hydrogen", LXString "H", LXString "1", LXString "1.008" ])
                                     , LatexList ([ LXString "Helium", LXString "He", LXString "2", LXString "4.003" ])
                                     , LatexList ([ LXString "Lithium", LXString "Li", LXString "3", LXString "6.94" ])
                                     , LatexList ([ LXString "Beryllium", LXString "Be", LXString "4", LXString "9.012" ])
                                     ]
                                    )
                                )
                            )
                in
                    Expect.equal parsedInput expectedOutput
        , test "(L.1) label" <|
            \_ ->
                let
                    parsedInput =
                        run parse "\\begin{equation}\n\\label{uncertaintyPrinciple}\n\\left[ \\hat p, x\\right] = -i \\hbar\n\\end{equation}"

                    expectedOutput =
                        Ok (Environment "equation" (LXString "\n\\label{uncertaintyPrinciple}\n\\left[ \\hat p, x\\right] = -i \\hbar\n"))
                in
                    Expect.equal parsedInput expectedOutput
        , test "(P.1) punctuation" <|
            \_ ->
                let
                    parsedInput =
                        run latexList "test \\code{foo}."

                    expectedOutput =
                        Ok (LatexList ([ LXString "test", Macro "code" ([ LatexList ([ LXString "foo" ]) ]), LXString "." ]))
                in
                    Expect.equal parsedInput expectedOutput
        ]
