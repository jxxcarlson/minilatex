module MiniLatex.LatexState exposing (..)

import Dict


{- TYPES AND DEFAULT VALJUES -}


type alias CrossReferences =
    Dict.Dict String String


type alias Counters =
    Dict.Dict String Int


emptyDict =
    Dict.empty


type alias LatexState =
    { counters : Counters, crossReferences : CrossReferences }


getCounter name latexState =
    case Dict.get name latexState.counters of
        Just k ->
            k

        Nothing ->
            0


getCrossReference label latexState =
    case Dict.get label latexState.crossReferences of
        Just ref ->
            ref

        Nothing ->
            "??"


incrementCounter name latexState =
    let
        maybeInc =
            Maybe.map (\x -> x + 1)

        newCounters =
            Dict.update name maybeInc latexState.counters
    in
        { latexState | counters = newCounters }


updateCounter name value latexState =
    let
        maybeSet =
            Maybe.map (\x -> value)

        newCounters =
            Dict.update name maybeSet latexState.counters
    in
        { latexState | counters = newCounters }


setCrossReference label value latexState =
    let
        crossReferences =
            latexState.crossReferences

        newCrossReferences =
            Dict.insert label value crossReferences
    in
        { latexState | crossReferences = newCrossReferences }


initialCounters =
    Dict.fromList [ ( "s1", 0 ), ( "s2", 0 ), ( "s3", 0 ), ( "tno", 0 ), ( "eqno", 0 ) ]


emptyLatexState =
    { counters = initialCounters, crossReferences = Dict.empty }
