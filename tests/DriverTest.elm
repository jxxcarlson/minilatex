module DriverTest exposing (..)

-- http://package.elm-lang.org/packages/elm-community/elm-test/latest

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import MiniLatex.Driver exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "MiniLatex Driver"
        -- Nest as many descriptions as you like.
        [ test "(E.1) Render equation" <|
            \_ ->
                let
                    input =
                        """
\\begin{equation}
\\label{integral}
\\int_0^1 x^n dx = \\frac{1}{n+1}
\\end{equation}
"""

                    output =
                        render "" input

                    expectedOutput =
                        "<p>\n \n$$\n\\begin{equation}\\tag{1}\n\\label{integral}\n\\int_0^1 x^n dx = \\frac{1}{n+1}\n\\end{equation}\n$$\n\n</p>\n\n"
                in
                Expect.equal output expectedOutput
        , test "(VB.1) Verbatm" <|
            \_ ->
                let
                    input =
                        """
\\begin{verbatim}
a
b

c
d
\\end{verbatim}
"""

                    output =
                        render "" input

                    expectedOutput =
                        "<p>YADA</p>\n\n"
                in
                Expect.equal output expectedOutput
        ]
