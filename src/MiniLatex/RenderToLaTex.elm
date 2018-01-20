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
    args |> List.map render |> joinList



{- joinList : List String -> String
   join a list of strings to make a single string.
   Adjacent strings l and r are joined by either an empty
   string or a spaxel depending on the terminal character
   of l and the leading character of r.  This is operation
   is a matter of style, but it is important.
-}


joinList : List String -> String
joinList stringList =
    let
        start =
            List.head stringList |> Maybe.withDefault ""
    in
    List.foldl joinDatum2String ( "", "" ) stringList |> Tuple.first


joinDatum2String : String -> ( String, String ) -> ( String, String )
joinDatum2String current datum =
    let
        ( acc, previous ) =
            datum
    in
    case joinType previous current of
        NoSpace ->
            ( acc ++ current, current )

        Space ->
            ( acc ++ " " ++ current, current )


type JoinType
    = Space
    | NoSpace


lastChar =
    String.right 1


firstChar =
    String.left 1


joinType : String -> String -> JoinType
joinType l r =
    let
        lastCharLeft =
            lastChar l

        firstCharRight =
            firstChar r
    in
    if l == "" then
        NoSpace
    else if List.member lastCharLeft [ "(" ] then
        NoSpace
    else if List.member firstCharRight [ ")", ".", ",", "?", "!", ";", ":" ] then
        NoSpace
    else
        Space



{- End new code -}


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
