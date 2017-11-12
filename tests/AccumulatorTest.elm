module AccumulatorTest exposing (..)

import MiniLatex.Accumulator as Accumulator
import MiniLatex.Render as Render
import MiniLatex.Parser as Parser exposing (LatexExpression(..))
import MiniLatex.LatexState exposing (emptyLatexState)
import MiniLatex.Differ as Differ
import MiniLatex.LatexDiffer as LatexDiffer
import Data
import Dict


-- http://package.elm-lang.org/packages/elm-community/elm-test/latest

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, list, int, string)
import Test exposing (..)


suite : Test
suite =
    describe "Accumulator"
        -- Nest as many descriptions as you like.
        [ test "(1) length of input" <|
            \_ ->
                Expect.equal (Data.qftIntroText |> String.length) 18828
        , test "(2) parse into a list of Latex elements" <|
            \_ ->
                let
                    parseData1 =
                        Data.qftIntroText
                            |> Differ.paragraphify
                            |> List.map Parser.parseParagraph
                in
                    Expect.equal (List.length parseData1) 93
        , test "(3) parse and render paragraphs, verify final LatexState" <|
            \_ ->
                let
                    output =
                        Data.qftIntroText
                            |> Differ.paragraphify
                            |> Accumulator.parseParagraphs emptyLatexState
                            |> Tuple.second

                    expectedOutput =
                        { counters = Dict.fromList [ ( "eqno", 21 ), ( "s1", 4 ), ( "s2", 4 ), ( "s3", 0 ), ( "tno", 0 ) ], crossReferences = Dict.fromList [ ( "foo", "2.1" ) ] }
                in
                    Expect.equal output expectedOutput
        , test "(4) check that accumulator produces a list of the correct length" <|
            \_ ->
                let
                    output =
                        Data.qftIntroText
                            |> Differ.paragraphify
                            |> Accumulator.parseParagraphs emptyLatexState
                            |> Tuple.first

                    -- accumulator Parser.parseParagraph renderParagraph updateState latexState
                in
                    Expect.equal (output |> List.length) 93
        , test "(5) check that '1 Introduction' exists as first section in output" <|
            \_ ->
                let
                    output =
                        LatexDiffer.initialize2
                            emptyLatexState
                            Data.qftIntroText
                            |> .paragraphs
                            |> List.head
                            |> Maybe.withDefault ""
                in
                    Expect.equal output "\\section{Introduction}\n\n"
        , test "(7) test transformParagraphs1" <|
            \_ ->
                let
                    output =
                        "Test: $a^2 = 3$\n\n\\begin{equation}\n\\label{foo}\na^ = 7\\end{equation}\n\n"
                            |> Differ.paragraphify
                            |> Accumulator.parseParagraphs emptyLatexState
                in
                    Expect.equal output
                        ( [ [ LXString "Test:", InlineMath "a^2 = 3" ]
                          , [ Environment "equation" (LXString "\n\\label{foo}\na^ = 7") ]
                          ]
                        , { counters =
                                Dict.fromList
                                    [ ( "eqno", 1 )
                                    , ( "s1", 0 )
                                    , ( "s2", 0 )
                                    , ( "s3", 0 )
                                    , ( "tno", 0 )
                                    ]
                          , crossReferences = Dict.fromList [ ( "foo", "0.1" ) ]
                          }
                        )
        ]
