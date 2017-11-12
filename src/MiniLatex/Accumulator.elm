module MiniLatex.Accumulator
    exposing
        ( parseParagraphs
        , renderParagraphs
          -- , renderParagraph
          --  , transformParagraphs
        )

import List.Extra
import String.Extra
import Regex
import Parser as P
import MiniLatex.Parser as Parser exposing (macro, parseParagraph, LatexExpression(..))
import MiniLatex.Differ as Differ exposing (EditRecord)
import MiniLatex.Render as Render exposing (renderLatexList)
import MiniLatex.LatexState
    exposing
        ( LatexState
        , CrossReferences
        , Counters
        , getCounter
        , incrementCounter
        , setCrossReference
        , updateCounter
        )
import MiniLatex.ParserTools as PT


{- Types -}


type alias LatexInfo =
    { typ : String, name : String, value : List LatexExpression }



{- EXPORTED FUNCTIONS -}
-- transformParagraphs : LatexState -> List String -> ( List String, LatexState )
-- transformParagraphs latexState paragraphs =
--     paragraphs
--         |> accumulator Parser.parseParagraph renderParagraph updateState latexState
--
--
-- renderParagraph : List LatexExpression -> LatexState -> String
-- renderParagraph parsedParagraph latexState =
--     renderLatexList latexState parsedParagraph
--         |> \paragraph -> "<p>" ++ paragraph ++ "</p>"


{-| parseParagraphs: Using a given LatexState, take a list of strings,
i.e., paragraphs, and compute a tuple consisting of the parsed
paragraohs and the upodated LatexState.
-}
parseParagraphs : LatexState -> List String -> ( List (List LatexExpression), LatexState )
parseParagraphs latexState paragraphs =
    paragraphs
        |> parseAccumulator Parser.parseParagraph updateState latexState


{-| renderParagraphs: take a list of (List LatexExpressions)
and a LatexState and rehder the list into a list of strings.
-}
renderParagraphs : LatexState -> List (List LatexExpression) -> ( List String, LatexState )
renderParagraphs latexState paragraphs =
    paragraphs
        |> renderAccumulator renderLatexList updateState latexState



{- ACCUMULATORS AND TRANSFORMERS -}


parseAccumulator :
    (String -> List LatexExpression) -- parse
    -> (List LatexExpression -> LatexState -> LatexState) -- updateState
    -> LatexState -- latexState
    -> List String
    -> ( List (List LatexExpression), LatexState )
parseAccumulator parse updateState latexState inputList =
    inputList
        |> List.foldl (parseTransformer parse updateState) ( [], latexState )


parseTransformer :
    (String -> List LatexExpression) -- parse
    -> (List LatexExpression -> LatexState -> LatexState) -- updateState
    -> String --input
    -> ( List (List LatexExpression), LatexState ) -- acc
    -> ( List (List LatexExpression), LatexState ) -- acc
parseTransformer parse updateState input acc =
    let
        ( outputList, state ) =
            acc

        parsedInput =
            parse input

        newState =
            updateState parsedInput state
    in
        ( outputList ++ [ parsedInput ], newState )


renderAccumulator :
    (LatexState -> List LatexExpression -> String) -- render
    -> (List LatexExpression -> LatexState -> LatexState) -- updateState
    -> LatexState -- latexState
    -> List (List LatexExpression)
    -> ( List String, LatexState )
renderAccumulator render updateState latexState inputList =
    inputList
        |> List.foldl (renderTransformer render updateState) ( [], latexState )


renderTransformer :
    (LatexState -> List LatexExpression -> String) -- render
    -> (List LatexExpression -> LatexState -> LatexState) -- updateState
    -> List LatexExpression --input
    -> ( List String, LatexState ) -- acc
    -> ( List String, LatexState ) -- acc
renderTransformer render updateState input acc =
    let
        ( outputList, state ) =
            acc

        newState =
            updateState input state

        renderedInput =
            render newState input
    in
        ( outputList ++ [ renderedInput ], newState )


info : LatexExpression -> LatexInfo
info latexExpression =
    case latexExpression of
        Macro name args ->
            { typ = "macro", name = name, value = args }

        Environment name body ->
            { typ = "env", name = name, value = [ body ] }

        _ ->
            { typ = "null", name = "null", value = [] }



{- UPDATERS -}


updateState : List LatexExpression -> LatexState -> LatexState
updateState parsedParagraph latexState =
    let
        headElement =
            parsedParagraph
                |> List.head
                |> Maybe.map info
                |> Maybe.withDefault (LatexInfo "null" "null" [ (Macro "null" []) ])

        he =
            { typ = "macro", name = "setcounter", value = [ LatexList ([ LXString "section" ]), LatexList ([ LXString "7" ]) ] }

        newLatexState =
            case ( headElement.typ, headElement.name ) of
                ( "macro", "setcounter" ) ->
                    let
                        argList =
                            headElement.value |> List.map PT.latexList2List |> List.map PT.list2LeadingString

                        arg1 =
                            getAt 0 argList

                        arg2 =
                            getAt 1 argList

                        initialSectionNumber =
                            if arg1 == "section" then
                                arg2 |> String.toInt |> Result.withDefault 0
                            else
                                -1
                    in
                        if initialSectionNumber > -1 then
                            latexState
                                |> updateCounter "s1" (initialSectionNumber - 1)
                                |> updateCounter "s2" 0
                                |> updateCounter "s3" 0
                        else
                            latexState

                ( "macro", "section" ) ->
                    latexState
                        |> incrementCounter "s1"
                        |> updateCounter "s2" 0
                        |> updateCounter "s3" 0

                ( "macro", "subsection" ) ->
                    latexState
                        |> incrementCounter "s2"
                        |> updateCounter "s3" 0

                ( "macro", "subsubsection" ) ->
                    latexState
                        |> incrementCounter "s3"

                ( "env", "theorem" ) ->
                    handleTheoremNumbers latexState headElement

                ( "env", "proposition" ) ->
                    handleTheoremNumbers latexState headElement

                ( "env", "lemma" ) ->
                    handleTheoremNumbers latexState headElement

                ( "env", "definition" ) ->
                    handleTheoremNumbers latexState headElement

                ( "env", "corollary" ) ->
                    handleTheoremNumbers latexState headElement

                ( "env", "equation" ) ->
                    handleEquationNumbers latexState headElement

                ( "env", "align" ) ->
                    handleEquationNumbers latexState headElement

                _ ->
                    latexState
    in
        newLatexState


updateSection : LatexState -> String -> String
updateSection latexState paragraph =
    let
        s1 =
            getCounter "s1" latexState

        s2 =
            getCounter "s2" latexState

        s3 =
            getCounter "s3" latexState
    in
        if String.contains "\\section" paragraph then
            paragraph
                |> String.Extra.replace "\\section{" ("\\section{" ++ (toString (s1 + 1)) ++ " ")
        else if String.contains "\\subsection" paragraph then
            paragraph
                |> String.Extra.replace "\\subsection{" ("\\subsection{" ++ (toString s1) ++ "." ++ (toString (s2 + 1)) ++ " ")
        else if String.contains "\\subsubsection" paragraph then
            paragraph
                |> String.Extra.replace "\\subsubsection{" ("\\subsubsection{" ++ (toString s1) ++ "." ++ (toString s2) ++ "." ++ (toString (s3 + 1)) ++ " ")
        else
            paragraph



{- HANDLERS -}


handleEquationNumbers : LatexState -> LatexInfo -> LatexState
handleEquationNumbers latexState info =
    let
        {- label =
           info.value
               |> List.head
               |> Maybe.withDefault (Macro "NULL" [])
               |> PT.getFirstMacroArg "label"
        -}
        data =
            info.value
                |> List.head
                |> Maybe.withDefault (Macro "NULL" [])

        label =
            case data of
                LXString str ->
                    getLabel str

                _ ->
                    ""

        latexState1 =
            incrementCounter "eqno" latexState

        eqno =
            getCounter "eqno" latexState1

        s1 =
            getCounter "s1" latexState1

        latexState2 =
            if label /= "" then
                setCrossReference label ((toString s1) ++ "." ++ (toString eqno)) latexState1
            else
                latexState1
    in
        latexState2


handleTheoremNumbers : LatexState -> LatexInfo -> LatexState
handleTheoremNumbers latexState info =
    let
        label =
            info.value
                |> List.head
                |> Maybe.withDefault (Macro "NULL" [])
                |> PT.getFirstMacroArg "label"

        latexState1 =
            incrementCounter "tno" latexState

        tno =
            getCounter "tno" latexState1

        s1 =
            getCounter "s1" latexState1

        latexState2 =
            if label /= "" then
                setCrossReference label ((toString s1) ++ "." ++ (toString tno)) latexState1
            else
                latexState1
    in
        latexState2



{- HELPERS -}


getAt : Int -> List String -> String
getAt k list_ =
    List.Extra.getAt k list_ |> Maybe.withDefault "xxx"


getElement : Int -> List LatexExpression -> String
getElement k list =
    let
        lxString =
            List.Extra.getAt k list |> Maybe.withDefault (LXString "xxx")
    in
        case lxString of
            LXString str ->
                str

            _ ->
                "yyy"


getLabel str =
    let
        maybeMacro =
            str
                |> String.trim
                |> P.run Parser.macro
    in
        case maybeMacro of
            Ok macro ->
                macro |> PT.getFirstMacroArg "label"

            _ ->
                ""
