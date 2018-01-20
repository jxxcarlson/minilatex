module MiniLatex.Driver
    exposing
        ( emptyEditRecord
        , getRenderedText
        , parse
        , render
        , setup
        , update
        )

{-| This library exposes functions for rendering MiniLaTeX text into HTML.


# API

@docs render, setup, getRenderedText, parse, update, emptyEditRecord

-}

import MiniLatex.Differ as Differ exposing (EditRecord)
import MiniLatex.LatexDiffer as MiniLatexDiffer
import MiniLatex.LatexState exposing (emptyLatexState)
import MiniLatex.Paragraph as Paragraph
import MiniLatex.Parser as MiniLatexParser exposing (LatexExpression)


{-| The function call `render macros sourceTest` produces
an HTML string corresponding to the MiniLatex source text
`sourceText`. The macro definitions in `macros`
are appended to this string and are used by MathJax
to render purely mathematical text. The `macros` string
may be empty. Thus, if

macros = ""
source = "\italic{Test:}\n\n$$a^2 + b^2 = c^2$$\n\n\strong{Q.E.D.}"

then `render macros source` yields the HTML text

    <p>
    <span class=italic>Test:</span></p>
      <p>
        $$a^2 + b^2 = c^2$$
      </p>
    <p>

    <span class="strong">Q.E.D.</span>
    </p>

-}
render : String -> String -> String
render macroDefinitions text =
    MiniLatexDiffer.createEditRecord emptyLatexState text |> getRenderedText macroDefinitions


{-| Parse the given text and return an AST represeting it.
-}
parse : String -> List (List LatexExpression)
parse text =
    text
        |> MiniLatexDiffer.prepareContentForLatex
        |> Paragraph.logicalParagraphify
        |> List.map MiniLatexParser.parse


pTags : EditRecord -> List String
pTags editRecord =
    editRecord.idList |> List.map (\x -> "<p id=\"" ++ x ++ "\">")


{-| Using the renderedParagraph list of the editRecord,
return a string representing the HTML of the paragraph list
of the editRecord. Append the macroDefinitions for use
by MathJax.
-}
getRenderedText : String -> EditRecord -> String
getRenderedText macroDefinitions editRecord =
    let
        paragraphs =
            editRecord.renderedParagraphs

        pTagList =
            pTags editRecord
    in
    List.map2 (\para pTag -> pTag ++ "\n" ++ para ++ "\n</p>") paragraphs pTagList
        |> String.join "\n\n"
        |> (\x -> x ++ "\n\n" ++ macroDefinitions)


{-| This version of getRenderedText ignores the idList.
This give better mathJax performance. ??? NEED TO TEST THIS ASSERTION
-}
getRenderedText2 : String -> EditRecord -> String
getRenderedText2 macroDefinitions editRecord =
    let
        paragraphs =
            editRecord.renderedParagraphs
    in
    List.map (\para -> "<p>\n" ++ para ++ "\n</p>") paragraphs
        |> String.join "\n\n"
        |> (\x -> macroDefinitions ++ "\n\n" ++ x)


{-| Create an EditRecord from a string of MiniLaTeX text:

> editRecord = setup 0 source

        { paragraphs =
            [ "\\italic{Test:}\n\n"
            , "$$a^2 + b^2 = c^2$$\n\n"
            , "\\strong{Q.E.D.}\n\n"
            ]
        , renderedParagraphs =
            [ "  <span class=italic>Test:</span>"
            , " $$a^2 + b^2 = c^2$$"
            , "  <span class=\"strong\">Q.E.D.</span> "
            ]
        , latexState =
            { counters =
                Dict.fromList
                    [ ( "eqno", 0 )
                    , ( "s1", 0 )
                    , ( "s2", 0 )
                    , ( "s3", 0 )
                    , ( "tno", 0 )
                    ]
            , crossReferences = Dict.fromList []
            }
        , idList = []
        , idListStart = 0
        } : MiniLatex.Differ.EditRecord

-}
setup : Int -> String -> EditRecord
setup seed text =
    MiniLatexDiffer.safeUpdate seed Differ.emptyEditRecord text


{-| Return an empty EditRecord

        { paragraphs = []
        , renderedParagraphs = []
        , latexState =
            { counters =
                Dict.fromList
                    [ ( "eqno", 0 )
                    , ( "s1", 0 )
                    , ( "s2", 0 )
                    , ( "s3", 0 )
                    , ( "tno", 0 )
                    ]
            , crossReferences = Dict.fromList []
            }
        , idList = []
        , idListStart = 0
        }

-}
emptyEditRecord : EditRecord
emptyEditRecord =
    Differ.emptyEditRecord


{-| Update the given edit record with modified text.
Thus, if

    source2 = "\italic{Test:}\n\n$$a^3 + b^3 = c^3$$\n\n\strong{Q.E.D.}"

then we can say

editRecord2 = update 0 source2 editRecord

The `update` function attempts to re-render only the paragraph
which have been changed. It will always update the text correctly,
but its efficiency depends on the nature of the edit. This is
because the "differ" used to detect changes is rather crude.

-}
update : Int -> EditRecord -> String -> EditRecord
update seed editRecord text =
    MiniLatexDiffer.safeUpdate seed editRecord text
