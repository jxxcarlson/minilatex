module MiniLatex.LatexDiffer exposing (initialize, initialize2, safeUpdate, prepareContentForLatex)

import MiniLatex.Accumulator as Accumulator
import MiniLatex.Differ as Differ exposing (EditRecord)
import MiniLatex.LatexState exposing (LatexState, emptyLatexState)
import MiniLatex.Render as Render exposing (render, renderLatexList)
import String.Extra


initialize : String -> EditRecord
initialize text =
    text
        |> prepareContentForLatex
        |> Differ.initialize (Render.transformText emptyLatexState)


initialize2 : LatexState -> String -> EditRecord
initialize2 latexState text =
    let
        paragraphs =
            text
                |> prepareContentForLatex
                |> Differ.logicalParagraphify

        ( latexExpressionList, latexState1 ) =
            paragraphs
                |> Accumulator.parseParagraphs emptyLatexState

        latexState2 =
            { emptyLatexState | crossReferences = latexState1.crossReferences }

        ( renderedParagraphs, latexState3 ) =
            latexExpressionList
                |> Accumulator.renderParagraphs latexState2

        renderedParagraphs2 =
            renderedParagraphs

        --|> List.map (\x -> "\n<p>\n" ++ x ++ "</p>")
    in
        EditRecord paragraphs renderedParagraphs2 latexState2 [] 0



-- initialize2a : LatexState -> String -> EditRecord
-- initialize2a latexState text =
--     let
--         paragraphs =
--             text
--                 |> prepareContentForLatex
--                 |> Differ.paragraphify
--
--         ( latexExpressionList, latexState ) =
--             paragraphs
--                 |> Accumulator.parseParagraphs emptyLatexState
--
--         renderedParagraphs =
--             latexExpressionList |> List.map (renderLatexList latexState)
--     in
--         EditRecord paragraphs renderedParagraphs latexState


update : Int -> EditRecord -> String -> EditRecord
update seed editorRecord text =
    text
        |> prepareContentForLatex
        |> Differ.update seed (Render.transformText editorRecord.latexState) editorRecord


safeUpdate : Int -> EditRecord -> String -> EditRecord
safeUpdate seed editRecord content =
    if Differ.isEmpty editRecord then
        initialize2 emptyLatexState content
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
