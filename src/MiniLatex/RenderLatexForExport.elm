module MiniLatex.RenderLatexForExport
    exposing
        ( renderLatexForExport
        )

import Dict
import List.Extra
import MiniLatex.Image as Image
import MiniLatex.JoinStrings as JoinStrings
import MiniLatex.Paragraph
import MiniLatex.Parser exposing (LatexExpression(..), defaultLatexList, latexList)
import MiniLatex.Utility as Utility


{-| parse a string and render it back into Latex
-}
renderLatexForExport : String -> String
renderLatexForExport str =
    str
        |> MiniLatex.Paragraph.logicalParagraphify
        |> List.map MiniLatex.Parser.parse
        |> List.map renderLatexList
        |> List.foldl (\par acc -> acc ++ par ++ "\n\n") ""


render : LatexExpression -> String
render latexExpression =
    case latexExpression of
        Comment str ->
            renderComment str

        Macro name args ->
            renderMacro name args

        SMacro name args le ->
            renderSMacro name args le

        Item level latexExpression ->
            renderItem level latexExpression

        InlineMath str ->
            " $" ++ str ++ "$ "

        DisplayMath str ->
            "$$" ++ str ++ "$$"

        Environment name args ->
            renderEnvironment name args

        LatexList args ->
            renderLatexList args

        LXString str ->
            str


renderLatexList : List LatexExpression -> String
renderLatexList args =
    args |> List.map render |> JoinStrings.joinList


renderArgList : List LatexExpression -> String
renderArgList args =
    args |> List.map render |> List.map (\x -> "{" ++ x ++ "}") |> String.join ""


renderItem : Int -> LatexExpression -> String
renderItem level latexExpression =
    "\\item " ++ render latexExpression ++ "\n\n"


renderComment : String -> String
renderComment str =
    "% " ++ str ++ "\n"


renderEnvironment : String -> LatexExpression -> String
renderEnvironment name body =
    case Dict.get name renderEnvironmentDict of
        Just f ->
            f body

        Nothing ->
            renderDefaultEnvironment name body


renderDefaultEnvironment : String -> LatexExpression -> String
renderDefaultEnvironment name body =
    let
        slimBody =
            String.trim <| render body
    in
    "\\begin{" ++ name ++ "}\n" ++ slimBody ++ "\n\\end{" ++ name ++ "}\n"


renderEnvironmentDict : Dict.Dict String (LatexExpression -> String)
renderEnvironmentDict =
    Dict.fromList
        [ ( "listing", \x -> renderListing x )
        , ( "useforweb", \x -> renderUseForWeb x )
        ]


renderListing body =
    let
        text =
            render body
    in
    "\n\\begin{verbatim}\n" ++ Utility.addLineNumbers text ++ "\n\\end{verbatim}\n"


renderUseForWeb body =
    ""


renderMacroDict : Dict.Dict String (List LatexExpression -> String)
renderMacroDict =
    Dict.fromList
        [ ( "image", \x -> renderImage x )
        ]


renderMacro : String -> List LatexExpression -> String
renderMacro name args =
    macroRenderer name args


renderSMacro : String -> List LatexExpression -> LatexExpression -> String
renderSMacro name args le =
    " \\" ++ name ++ renderArgList args ++ " " ++ render le ++ "\n\n"


macroRenderer : String -> (List LatexExpression -> String)
macroRenderer name =
    case Dict.get name renderMacroDict of
        Just f ->
            f

        Nothing ->
            reproduceMacro name


reproduceMacro : String -> List LatexExpression -> String
reproduceMacro name args =
    " \\" ++ name ++ renderArgList args


getExportUrl url =
    let
        parts =
            String.split "/" url

        n =
            List.length parts

        lastPart =
            parts |> List.drop (n - 1) |> List.head |> Maybe.withDefault "xxx"
    in
    "image/" ++ lastPart


renderImage : List LatexExpression -> String
renderImage args =
    let
        url =
            renderArg 0 args

        exportUrl =
            getExportUrl url

        label =
            renderArg 1 args

        attributeString =
            renderArg 2 args

        imageAttrs =
            Image.parseImageAttributes attributeString

        width =
            toString imageAttrs.width ++ "px"
    in
    case ( imageAttrs.float, imageAttrs.align ) of
        ( "left", _ ) ->
            imageFloatLeft exportUrl label width

        ( "right", _ ) ->
            imageFloatRight exportUrl label width

        ( _, "center" ) ->
            imageAlignCenter exportUrl label width

        ( _, _ ) ->
            imageAlignCenter exportUrl label width


imageFloatLeft exportUrl label width =
    "\\imagefloatleft{" ++ exportUrl ++ "}{" ++ label ++ "}{" ++ width ++ "}"


imageFloatRight exportUrl label width =
    "\\imagefloatright{" ++ exportUrl ++ "}{" ++ label ++ "}{" ++ width ++ "}"


imageAlignCenter exportUrl label width =
    "\\imagecenter{" ++ exportUrl ++ "}{" ++ label ++ "}{" ++ width ++ "}"


renderArg : Int -> List LatexExpression -> String
renderArg k args =
    render (getElement k args) |> String.trim


getElement : Int -> List LatexExpression -> LatexExpression
getElement k list =
    List.Extra.getAt k list |> Maybe.withDefault (LXString "xxx")
