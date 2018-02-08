module MiniLatex.Utility exposing (addLineNumbers)


addLineNumbers text =
    text
        |> String.trim
        |> String.split "\n"
        |> List.foldl addNumberedLine ( 0, [] )
        |> Tuple.second
        |> List.reverse
        |> String.join "\n"


addNumberedLine line data =
    let
        ( k, lines ) =
            data
    in
    ( k + 1, [ numberedLine (k + 1) line ] ++ lines )


numberedLine k line =
    String.padLeft 5 ' ' (toString k) ++ "  " ++ line
