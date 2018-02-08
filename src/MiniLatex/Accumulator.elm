module MiniLatex.Accumulator
    exposing
        ( parseParagraphs
        , renderParagraphs
        )

import Dict
import MiniLatex.LatexState
    exposing
        ( Counters
        , CrossReferences
        , LatexState
        , addSection
        , getCounter
        , incrementCounter
        , setCrossReference
        , setDictionaryItem
        , updateCounter
        )
import MiniLatex.Parser as Parser exposing (LatexExpression(..), macro, parse)
import MiniLatex.Render as Render exposing (renderLatexList)
import MiniLatex.StateReducerHelpers as SRH


{- Types -}


{-| Given an initial state and list of inputs of type a,
produce a list of outputs of type b and a new state
-}
type alias Accumulator state a b =
    state -> List a -> ( List b, state )


type alias Reducer a b =
    a -> b -> b


type alias ParserReducer =
    Reducer (List LatexExpression) LatexState


type alias RenderReducer =
    Reducer (List LatexExpression) ( List String, LatexState )


{-| Transform a reducer using (a -> b)
-}
type alias ParserReducerTransformer a b c =
    (a -> b)
    -> Reducer b c
    -> Reducer a ( List b, c )


{-| Transform a reducer using (a -> b -> c)
-}
type alias RenderReducerTransformer a b c =
    (a -> b -> c)
    -> Reducer b a
    -> Reducer b ( List c, a )


type alias LatexInfo =
    { typ : String, name : String, value : List LatexExpression }



{- EXPORTED FUNCTIONS -}
-- transformParagraphs : LatexState -> List String -> ( List String, LatexState )
-- transformParagraphs latexState paragraphs =
--     paragraphs
--         |> accumulator Parser.parse renderParagraph latexStateReducer latexState
--
--
-- renderParagraph : List LatexExpression -> LatexState -> String
-- renderParagraph parsedParagraph latexState =
--     renderLatexList latexState parsedParagraph
--         |> \paragraph -> "<p>" ++ paragraph ++ "</p>"


{-| parseParagraphs: Using a given LatexState, take a list of strings,
i.e., paragraphs, and compute a tuple consisting of the parsed
paragraphs and the upodated LatexState.

parseParagraphs : LatexState -> List String -> ( List (List LatexExpression), LatexState )

-}
parseParagraphs : Accumulator LatexState String (List LatexExpression)
parseParagraphs latexState paragraphs =
    parseAccumulator latexState paragraphs


{-| renderParagraphs: take a list of (List LatexExpressions)
and a LatexState and rehder the list into a list of strings.

renderParagraphs : LatexState -> List (List LatexExpression) -> ( List String, LatexState )

-}
renderParagraphs : Accumulator LatexState (List LatexExpression) String
renderParagraphs latexState paragraphs =
    renderAccumulator latexState paragraphs



{- ACCUMULATORS AND TRANSFORMERS -}
-- parseAccumulator : LatexState -> List String -> ( List (List LatexExpression), LatexState )


parseAccumulator : Accumulator LatexState String (List LatexExpression)
parseAccumulator latexState inputList =
    inputList
        |> List.foldl parserAccumulatorReducer ( [], latexState )


parserAccumulatorReducer : Reducer String ( List (List LatexExpression), LatexState )
parserAccumulatorReducer =
    parserReducerTransformer Parser.parse latexStateReducer


{-| parserReducerTransformer parse latexStateReducer is a Reducer input acc
-}
parserReducerTransformer : ParserReducerTransformer String (List LatexExpression) LatexState
parserReducerTransformer parse latexStateReducer input acc =
    let
        ( outputList, state ) =
            acc

        parsedInput =
            parse input

        newState =
            latexStateReducer parsedInput state
    in
    ( outputList ++ [ parsedInput ], newState )


renderAccumulatorReducer : Reducer (List LatexExpression) ( List String, LatexState )
renderAccumulatorReducer =
    renderTransformer renderLatexList latexStateReducer


renderAccumulator : Accumulator LatexState (List LatexExpression) String
renderAccumulator latexState inputList =
    inputList
        |> List.foldl renderAccumulatorReducer ( [], latexState )


{-| renderTransformer render latexStateReducer is a Reducer input acc
-}
renderTransformer : RenderReducerTransformer LatexState (List LatexExpression) String
renderTransformer render latexStateReducer input acc =
    let
        ( outputList, state ) =
            acc

        newState =
            latexStateReducer input state

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


latexStateReducerDict : Dict.Dict ( String, String ) (LatexInfo -> LatexState -> LatexState)
latexStateReducerDict =
    Dict.fromList
        [ ( ( "macro", "setcounter" ), \x y -> SRH.setSectionCounters x y )
        , ( ( "macro", "section" ), \x y -> SRH.updateSectionNumber x y )
        , ( ( "macro", "subsection" ), \x y -> SRH.updateSubsectionNumber x y )
        , ( ( "macro", "subsubsection" ), \x y -> SRH.updateSubsubsectionNumber x y )
        , ( ( "macro", "title" ), \x y -> SRH.setDictionaryItemForMacro x y )
        , ( ( "macro", "author" ), \x y -> SRH.setDictionaryItemForMacro x y )
        , ( ( "macro", "date" ), \x y -> SRH.setDictionaryItemForMacro x y )
        , ( ( "macro", "email" ), \x y -> SRH.setDictionaryItemForMacro x y )
        , ( ( "macro", "revision" ), \x y -> SRH.setDictionaryItemForMacro x y )
        , ( ( "env", "theorem" ), \x y -> SRH.setTheoremNumber x y )
        , ( ( "env", "proposition" ), \x y -> SRH.setTheoremNumber x y )
        , ( ( "env", "lemma" ), \x y -> SRH.setTheoremNumber x y )
        , ( ( "env", "definition" ), \x y -> SRH.setTheoremNumber x y )
        , ( ( "env", "corollary" ), \x y -> SRH.setTheoremNumber x y )
        , ( ( "env", "equation" ), \x y -> SRH.setEquationNumber x y )
        , ( ( "env", "align" ), \x y -> SRH.setEquationNumber x y )
        ]


latexStateReducerDispatcher : ( String, String ) -> (LatexInfo -> LatexState -> LatexState)
latexStateReducerDispatcher ( typ_, name ) =
    case Dict.get ( typ_, name ) latexStateReducerDict of
        Just f ->
            f

        Nothing ->
            \latexInfo latexState -> latexState


latexStateReducer : Reducer (List LatexExpression) LatexState
latexStateReducer parsedParagraph latexState =
    let
        headElement =
            parsedParagraph
                |> List.head
                |> Maybe.map info
                |> Maybe.withDefault (LatexInfo "null" "null" [ Macro "null" [] ])

        he =
            { typ = "macro", name = "setcounter", value = [ LatexList [ LXString "section" ], LatexList [ LXString "7" ] ] }
    in
    latexStateReducerDispatcher ( headElement.typ, headElement.name ) headElement latexState
