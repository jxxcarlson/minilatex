module MiniLatex.Driver
    exposing
        ( getRenderedText
        , render
        , setup
        , update
        )

{-| This library exposes functions for rendering MiniLaTeX text into HTML.


# API

@docs render, setup, getRenderedText, update

-}

import MiniLatex.LatexDiffer as MiniLatexDiffer
import MiniLatex.Differ as Differ exposing (EditRecord)
import MiniLatex.LatexState exposing (emptyLatexState)


{-| The function call render sourceTest produces
an HTML string corresponding to the MiniLatex source text.
Thus, if

str = "\italic{Test:}\n\n$$a^2 + b^2 = c^2$$\n\n\strong{Q.E.D.}"

then `render str` yields the HTML text

    <p>
    <span class=italic>Test:</span></p>
    <p>
    $$a^2 + b^2 = c^2$$</p>
    <p>

<span class="strong">Q.E.D.</span> </p>

-}
render : String -> String
render text =
    MiniLatexDiffer.initialize2 emptyLatexState text |> getRenderedText


{-| getRenderedText extrats the rendred text as a string
from an EditRecord, e.g.,

getRenderedText editRecord

-}
getRenderedText : EditRecord -> String
getRenderedText editRecord =
    editRecord.renderedParagraphs |> String.join ""


{-| Create an EditRecord from a string of MiniLaTeX text:

> editRecord = setup str
> { paragraphs =

        [ "\\italic{Test:}\n\n"
        , "$$a^2 + b^2 = c^2$$\n\n"
        , "\\strong{Q.E.D.}\n\n"
        ]
    , renderedParagraphs =
        [ "\n<p>\n  <span class=italic>Test:</span></p>"
        , "\n<p>\n $$a^2 + b^2 = c^2$$</p>"
        , "\n<p>\n  <span class=\"strong\">Q.E.D.</span> </p>"
        ]
    , latexState =
        { counters = Dict.fromList [ ( "eqno", 0 ), ( "s1", 0 ), ( "s2", 0 ), ( "s3", 0 ), ( "tno", 0 ) ]
        , crossReferences = Dict.fromList []
        }
    }

    : MiniLatex.Differ.EditRecord

-}
setup : String -> EditRecord
setup text =
    MiniLatexDiffer.safeUpdate Differ.emptyEditRecord text


{-| Update the given edit record with modified text.
Thus, if

str2 = "\italic{Test:}\n\n$$a^3 + b^3 = c^3$$\n\n\strong{Q.E.D.}"

then we can say

editRecord2 = update str2 editRecord

The `update` function attempts to re-render only the paragraph
which have been changed. It will always update the text correctly,
but its efficiency depends on the nature of the edit. This is
because the "differ" used to detect changes is rather crude.

-}
update : EditRecord -> String -> EditRecord
update editRecord text =
    MiniLatexDiffer.safeUpdate editRecord text
