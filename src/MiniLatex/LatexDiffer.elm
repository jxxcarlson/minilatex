module MiniLatex.LatexDiffer exposing (createEditRecord, update)

import MiniLatex.Accumulator as Accumulator
import MiniLatex.Differ as Differ exposing (EditRecord)
import MiniLatex.LatexState exposing (LatexState, emptyLatexState)
import MiniLatex.Paragraph as Paragraph
import MiniLatex.Render as Render exposing (render, renderLatexList)


createEditRecord : LatexState -> String -> EditRecord
createEditRecord latexState text =
    let
        paragraphs =
            text
                |> Paragraph.logicalParagraphify

        ( latexExpressionList, latexState1 ) =
            paragraphs
                |> Accumulator.parseParagraphs emptyLatexState

        latexState2 =
            { emptyLatexState
                | crossReferences = latexState1.crossReferences
                , tableOfContents = latexState1.tableOfContents
                , dictionary = latexState1.dictionary
            }

        ( renderedParagraphs, _ ) =
            latexExpressionList
                |> Accumulator.renderParagraphs latexState2

        idList =
            makeIdList paragraphs
    in
    EditRecord paragraphs renderedParagraphs latexState2 idList Nothing Nothing


makeIdList : List String -> List String
makeIdList paragraphs =
    List.range 1 (List.length paragraphs) |> List.map (Differ.prefixer 0)


update_ : Int -> EditRecord -> String -> EditRecord
update_ seed editorRecord text =
    text
        |> Differ.update seed (Render.transformText editorRecord.latexState) editorRecord


update : Int -> EditRecord -> String -> EditRecord
update seed editRecord content =
    if Differ.isEmpty editRecord then
        createEditRecord emptyLatexState content
    else
        update_ seed editRecord content
