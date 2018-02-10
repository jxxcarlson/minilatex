module MiniLatex.RenderToLatex
    exposing
        ( render
        , renderBackToLatex
        , renderBackToLatexTest
        , renderBackToLatexTestModSpace
        , renderLatexList
        )

import List.Extra
import MiniLatex.ErrorMessages as ErrorMessages
import MiniLatex.JoinStrings as JoinStrings
import MiniLatex.Paragraph
import MiniLatex.Parser exposing (LatexExpression(..), defaultLatexList, latexList)
import Parser
import String.Extra


{-| parse a stringg and render it back into Latex
-}
renderBackToLatex : String -> String
renderBackToLatex str =
    str
        |> MiniLatex.Paragraph.logicalParagraphify
        |> List.map MiniLatex.Parser.parse
        |> List.map renderLatexList
        |> List.foldl (\par acc -> acc ++ par ++ "\n\n") ""


renderBackToLatexTest : String -> Bool
renderBackToLatexTest str =
    str == renderBackToLatex str


renderBackToLatexTestModSpace : String -> Bool
renderBackToLatexTestModSpace str =
    (str |> String.Extra.replace " " "") == (renderBackToLatex str |> String.Extra.replace " " "")


render : LatexExpression -> String
render latexExpression =
    case latexExpression of
        Comment str ->
            renderComment str

        Macro name optArgs args ->
            renderMacro name optArgs args

        SMacro name optArgs args le ->
            renderSMacro name optArgs args le

        Item level latexExpression ->
            renderItem level latexExpression

        InlineMath str ->
            " $" ++ str ++ "$"

        DisplayMath str ->
            "$$" ++ str ++ "$$"

        Environment name args body ->
            renderEnvironment name args body

        LatexList args ->
            renderLatexList args

        LXString str ->
            str

        LXError error ->
            ErrorMessages.renderError error


renderLatexList : List LatexExpression -> String
renderLatexList args =
    args |> List.map render |> List.foldl (\item acc -> acc ++ item) ""



-- JoinStrings.joinList


renderArgList : List LatexExpression -> String
renderArgList args =
    args |> List.map render |> List.map (\x -> "{" ++ x ++ "}") |> String.join ""


renderOptArgList : List LatexExpression -> String
renderOptArgList args =
    args |> List.map render |> List.map (\x -> "[" ++ x ++ "]") |> String.join ""


renderItem : Int -> LatexExpression -> String
renderItem level latexExpression =
    "\\item " ++ render latexExpression ++ "\n\n"


renderComment : String -> String
renderComment str =
    "% " ++ str ++ "\n"


renderEnvironment : String -> List LatexExpression -> LatexExpression -> String
renderEnvironment name args body =
    "\\begin{" ++ name ++ "}" ++ renderArgList args ++ "\n" ++ render body ++ "\n\\end{" ++ name ++ "}\n"


renderMacro : String -> List LatexExpression -> List LatexExpression -> String
renderMacro name optArgs args =
    " \\" ++ name ++ renderOptArgList optArgs ++ renderArgList args


renderSMacro : String -> List LatexExpression -> List LatexExpression -> LatexExpression -> String
renderSMacro name optArgs args le =
    " \\" ++ name ++ renderOptArgList optArgs ++ renderArgList args ++ " " ++ render le ++ "\n\n"
