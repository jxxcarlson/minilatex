module MiniLatex.ParserTools exposing (..)

{- Some of these functoins are used by MiniLatex.Accumulator -}

import MiniLatex.Parser exposing (LatexExpression(..))


isMacro : String -> LatexExpression -> Bool
isMacro macroName latexExpression =
    case latexExpression of
        Macro name _ ->
            name
                == macroName

        _ ->
            False


getMacroArgs macroName latexExpression =
    case latexExpression of
        Macro name args ->
            if name == macroName then
                args
                    |> List.map latexList2List
            else
                []

        _ ->
            []


getSimpleMacroArgs macroName latexExpression =
    latexExpression |> getMacroArgs macroName |> List.map list2LeadingString


getFirstMacroArg macroName latexExpression =
    let
        arg =
            getSimpleMacroArgs macroName latexExpression |> List.head
    in
    case arg of
        Just value ->
            value

        _ ->
            ""


list2LeadingString list =
    let
        head_ =
            list |> List.head

        value =
            case head_ of
                Just value_ ->
                    value_

                Nothing ->
                    LXString ""
    in
    case value of
        LXString str ->
            str

        _ ->
            ""


latexList2List latexExpression =
    case latexExpression of
        LatexList list ->
            list

        _ ->
            []


getString : LatexExpression -> String
getString latexString =
    case latexString of
        LXString str ->
            str

        _ ->
            ""


getMacros : String -> List LatexExpression -> List LatexExpression
getMacros macroName expressionList =
    expressionList
        |> List.filter (\expr -> isMacro macroName expr)



-- unpack : List LatexExpression -> LatexExpression


headLatexExpression : List LatexExpression -> LatexExpression
headLatexExpression list =
    let
        he =
            case List.head list of
                Just expr ->
                    expr

                Nothing ->
                    LatexList []
    in
    he


valueOfLatexList : LatexExpression -> List LatexExpression
valueOfLatexList latexList =
    case latexList of
        LatexList value ->
            value

        _ ->
            [ LXString "Error getting value of LatexList" ]


valueOfLXString : LatexExpression -> String
valueOfLXString expr =
    case expr of
        LXString str ->
            str

        _ ->
            "Error getting value of LatexString"


unpackString : List LatexExpression -> String
unpackString expr =
    expr |> headLatexExpression |> valueOfLatexList |> headLatexExpression |> valueOfLXString
