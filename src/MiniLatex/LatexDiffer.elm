module MiniLatex.LatexDiffer exposing (initialize, prepareContentForLatex, safeUpdate)

import MiniLatex.Accumulator as Accumulator
import MiniLatex.Differ as Differ exposing (EditRecord)
import MiniLatex.LatexState exposing (LatexState, emptyLatexState)
import MiniLatex.Paragraph as Paragraph
import MiniLatex.Render as Render exposing (render, renderLatexList)
import String.Extra


initialize : LatexState -> String -> EditRecord
initialize latexState text =
    let
        paragraphs =
            text
                |> prepareContentForLatex
                |> Paragraph.logicalParagraphify

        ( latexExpressionList, latexState1 ) =
            paragraphs
                |> Accumulator.parseParagraphs emptyLatexState

        latexState2 =
            Debug.log "latexState2"
                { emptyLatexState
                    | crossReferences = latexState1.crossReferences
                    , tableOfContents = latexState1.tableOfContents
                    , dictionary = latexState1.dictionary
                }

        ( renderedParagraphs, latexState3 ) =
            latexExpressionList
                |> Accumulator.renderParagraphs latexState2

        renderedParagraphs2 =
            renderedParagraphs

        n =
            List.length paragraphs

        idList =
            Debug.log "idList in initialize"
                (List.range 1 n |> List.map (Differ.prefixer 0))
    in
    EditRecord paragraphs renderedParagraphs2 latexState2 idList Nothing Nothing


update : Int -> EditRecord -> String -> EditRecord
update seed editorRecord text =
    text
        |> prepareContentForLatex
        |> Differ.update seed (Render.transformText editorRecord.latexState) editorRecord


safeUpdate : Int -> EditRecord -> String -> EditRecord
safeUpdate seed editRecord content =
    if Differ.isEmpty editRecord then
        initialize emptyLatexState content
    else
        update seed editRecord content


{-| replaceStrings is used by the document prepreprocessor
to normalize input to parseDocument.
-}
replaceStrings : String -> String
replaceStrings text =
    text
        |> String.Extra.replace "---" "\\mdash{}"
        |> String.Extra.replace "--" "\\ndash{}"


prepareContentForLatex : String -> String
prepareContentForLatex content =
    content
        |> replaceStrings
