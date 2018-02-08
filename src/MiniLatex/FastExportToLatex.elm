module MiniLatex.FastExportToLatex exposing (..)

import MiniLatex.JoinStrings as JoinStrings
import MiniLatex.Paragraph as Paragraph
import MiniLatex.RenderLatexForExport as RLE



export : String -> String
export sourceText =
    sourceText
        |> Paragraph.logicalParagraphify
        |> List.map processParagraph
        |> List.map (\par -> par ++ "\n\n")
        |> JoinStrings.joinList


processParagraph : String -> String
processParagraph par =
    let
        prefix =
            String.left 14 par

        signature =
            if String.left 6 prefix == "\\begin" then
                String.dropLeft 7 prefix |> String.dropRight 1
            else
                String.left 6 prefix
    in
    case signature of
        "\\image" ->
            RLE.renderLatexForExport par

        "listin" ->
            RLE.renderLatexForExport par

        "usefor" ->
            RLE.renderLatexForExport par

        _ ->
            par
