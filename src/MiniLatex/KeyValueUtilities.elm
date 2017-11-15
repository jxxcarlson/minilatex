module MiniLatex.KeyValueUtilities exposing (getKeyValueList, getValue)

import Char
import Parser exposing (..)


-- type alias KeyValuePair =
--     { key : String
--     , value : String
--     }
--


type alias KeyValuePair =
    ( String, String )


keyValuePair : Parser KeyValuePair
keyValuePair =
    inContext "KeyValuePair" <|
        succeed (,)
            |. ignore zeroOrMore (\c -> c == ' ' || c == '\n')
            |= keep oneOrMore (\c -> c /= ' ' && c /= ':')
            |. symbol ":"
            |. ignore zeroOrMore (\c -> c == ' ' || c == '\n')
            |= keep oneOrMore (\c -> c /= ' ' && c /= ',')
            |. ignore zeroOrMore (\c -> c == ',' || c == ' ' || c == '\n')


keyValuePairs : Parser (List KeyValuePair)
keyValuePairs =
    inContext "keyValuePairs" <|
        succeed identity
            |= repeat zeroOrMore keyValuePair


getKeyValueList str =
    Parser.run keyValuePairs str |> Result.withDefault []



-- getValue : List KeyValuePair -> String -> String


getValue key kvpList =
    kvpList
        |> List.filter (\x -> (Tuple.first x) == key)
        |> List.map (\x -> Tuple.second x)
        |> List.head
        |> Maybe.withDefault ""
