module MiniLatex.RenderToLatex
    exposing
        ( quasiIdentity
        , quasiIdentityTest
        , quasiIdentityTestModSpace
        , render
        , renderLatexList
        , renderString
        )

import List.Extra
import MiniLatex.JoinStrings as JoinStrings
import MiniLatex.Parser exposing (LatexExpression(..), defaultLatexList, latexList)
import Parser
import String.Extra


{-| parse a stringg and render it back into Latex
-}
quasiIdentity : String -> String
quasiIdentity str =
    str |> MiniLatex.Parser.parse |> renderLatexList


quasiIdentityTest : String -> Bool
quasiIdentityTest str =
    str == quasiIdentity str


quasiIdentityTestModSpace : String -> Bool
quasiIdentityTestModSpace str =
    (str |> String.Extra.replace " " "") == (quasiIdentity str |> String.Extra.replace " " "")



-- |> \str -> "\n<p>" ++ str ++ "</p>\n"
{- FUNCTIONS FOR TESTING THINGS -}


getElement : Int -> List LatexExpression -> LatexExpression
getElement k list =
    List.Extra.getAt k list |> Maybe.withDefault (LXString "xxx")


parseString parser str =
    Parser.run parser str


renderString parser str =
    let
        parserOutput =
            Parser.run parser str

        renderOutput =
            case parserOutput of
                Ok latexExpression ->
                    render latexExpression

                Err error ->
                    "Error: " ++ toString error
    in
    renderOutput



{- TYPES AND DEFAULT VALJUES -}


extractList : LatexExpression -> List LatexExpression
extractList latexExpression =
    case latexExpression of
        LatexList a ->
            a

        _ ->
            []


{-| THE MAIN RENDERING FUNCTION
-}
render : LatexExpression -> String
render latexExpression =
    case latexExpression of
        Comment str ->
            renderComment str

        Macro name args ->
            renderMacro name args

        Item level latexExpression ->
            renderItem level latexExpression

        InlineMath str ->
            "$" ++ str ++ "$"

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



{- ENVIROMENTS -}


renderEnvironment : String -> LatexExpression -> String
renderEnvironment name body =
    "\\begin{" ++ name ++ "}\n" ++ render body ++ "\n\\end{" ++ name ++ "}\n\n"



{- MACROS: DISPATCHERS AND HELPERS -}


renderMacro : String -> List LatexExpression -> String
renderMacro name args =
    "\\" ++ name ++ renderArgList args
