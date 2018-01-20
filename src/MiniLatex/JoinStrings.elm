module MiniLatex.JoinStrings exposing (joinList)

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
