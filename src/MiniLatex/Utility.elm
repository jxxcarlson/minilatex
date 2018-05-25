module MiniLatex.Utility exposing (addLineNumbers)

{-| Add line numbers to a piece of text. -}

addLineNumbers : String -> String
addLineNumbers text =
    text
        |> String.trim
        |> String.split "\n"
        |> List.foldl addNumberedLine ( 0, [] )
        |> Tuple.second
        |> List.reverse
        |> String.join "\n"


addNumberedLine : String -> ( Int, List String ) -> ( Int, List String )
addNumberedLine line data =
    let
        ( k, lines ) =
            data
    in
    ( k + 1, [ numberedLine (k + 1) line ] ++ lines )

numberedLine : Int -> String -> String
numberedLine k line =
    String.padLeft 2 ' ' (toString k) ++ " " ++ line
