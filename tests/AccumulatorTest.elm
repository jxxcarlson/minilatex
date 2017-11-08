module AccumulatorTest exposing (..)

import MiniLatex.Accumulator exposing (..)
import MiniLatex.Render as Render
import MiniLatex.Parser as Parser exposing (LatexExpression(..))
import MiniLatex.LatexState exposing (emptyLatexState)
import MiniLatex.Differ as Differ
import Data
import Dict


-- http://package.elm-lang.org/packages/elm-community/elm-test/latest

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, list, int, string)
import Test exposing (..)


suite : Test
suite =
    describe "XXX"
        -- Nest as many descriptions as you like.
        [ test "(1) lngth of input" <|
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
                    data =
                        Data.qftIntroText
                            |> Differ.paragraphify
                            |> accumulator Parser.parseParagraph renderParagraph updateState emptyLatexState

                    expectedOutput =
                        { counters = Dict.fromList [ ( "eqno", 21 ), ( "s1", 4 ), ( "s2", 4 ), ( "s3", 0 ), ( "tno", 0 ) ], crossReferences = Dict.fromList [ ( "foo", "2.1" ) ] }
                in
                    Expect.equal (Tuple.second data) expectedOutput
        , test "(4) check that accumulator produces a list of the correct length" <|
            \_ ->
                let
                    data =
                        Data.qftIntroText
                            |> Differ.paragraphify
                            |> accumulator Parser.parseParagraph renderParagraph updateState emptyLatexState

                    -- accumulator Parser.parseParagraph renderParagraph updateState latexState
                in
                    Expect.equal (Tuple.first data |> List.length) 93
        , test "(5) transformText" <|
            \_ ->
                let
                    data =
                        Data.qftIntroText
                            |> Differ.paragraphify
                            |> transformParagraphs emptyLatexState
                            |> Tuple.first
                in
                    Expect.equal (data |> List.length) 93
        , test "(6) check that '1 Introduction' exists as first section in output" <|
            \_ ->
                let
                    data =
                        Data.qftIntroText
                            |> Differ.paragraphify
                            |> transformParagraphs emptyLatexState
                            |> Tuple.first
                in
                    let
                        firstString =
                            data |> List.head |> Maybe.withDefault ""
                    in
                        Expect.equal (String.contains "1 Introduction" firstString) True
        , test "(7) test transformParagraphs1" <|
            \_ ->
                let
                    result =
                        "Test: $a^2 = 3$\n\n\\begin{equation}\n\\label{foo}\na^ = 7\\end{equation}\n\n"
                            |> Differ.paragraphify
                            |> parseParagraphs emptyLatexState
                in
                    Expect.equal result
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
