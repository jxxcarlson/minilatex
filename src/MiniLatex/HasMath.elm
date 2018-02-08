module MiniLatex.HasMath exposing (hasMath, listHasMath)

import MiniLatex.Parser exposing (LatexExpression(..))


{- Has Math code -}


{-| Determine whether a (List LatexExpression) has math text in it
-}
listHasMath : List LatexExpression -> Bool
listHasMath list =
    list |> List.foldr (\x acc -> hasMath x || acc) False


{-| Determine whether a LatexExpression has math text in it
-}
hasMath : LatexExpression -> Bool
hasMath expr =
    case expr of
        LXString str ->
            False

        Comment str ->
            False

        Item k expr ->
            hasMath expr

        InlineMath str ->
            True

        DisplayMath str ->
            True

        Macro str expr ->
            expr |> List.foldr (\x acc -> hasMath x || acc) False

        SMacro str expr str2 ->
            expr |> List.foldr (\x acc -> hasMath x || acc) False

        Environment str expr ->
            envHasMath str expr

        LatexList list ->
            list |> List.foldr (\x acc -> hasMath x || acc) False

        LXError _ _ ->
            False


{-| Determine whether an environment has math in it
-}
envHasMath : String -> LatexExpression -> Bool
envHasMath envType expr =
    List.member envType [ "equation", "align", "eqnarray" ] || hasMath expr
