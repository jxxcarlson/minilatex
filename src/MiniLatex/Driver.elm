module MiniLatex.Driver
    exposing
        ( getRenderedText
        , render
        , setup
        , update
        )

import MiniLatex.LatexDiffer as LatexDiffer
import MiniLatex.Differ as Differ
import MiniLatex.LatexState exposing (emptyLatexState)


{-| The function call render sourceTest produces
an HTML string corresponding to the MiniLatex source text.
-}
render : String -> String
render text =
    LatexDiffer.initialize2 emptyLatexState text |> getRenderedText


getRenderedText : EditRecord -> String
getRenderedText editRecord =
    editRecord.renderedParagraphs |> String.join "\n\n"


setup : String -> EditRecord
setup text =
    MiniLatexDiffer.safeUpdate Differ.emptyEditRecord text


update : EditRecord -> String -> EditRecord
update editRecord text =
    MiniLatexDiffer.safeUpdate editRecord text
