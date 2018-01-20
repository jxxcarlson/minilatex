module MiniLatex.Html exposing (a, div, img)


div : List String -> List String -> String
div attributes children =
    let
        attributeString =
            attributes |> String.join " "

        childrenString =
            children |> String.join "\n"
    in
    "<div " ++ attributeString ++ " >\n" ++ childrenString ++ "\n</div>"


img url imageAttributs =
    "<img src=\"" ++ url ++ "\" width=" ++ toString imageAttributs.width ++ " >"


a url label =
    "<a href=\"" ++ url ++ "\"  target=\"_blank\" >\n" ++ label ++ "\n</a>"
