module MiniLatex.ParserHelpers exposing (..)

import Parser exposing (..)


{- PARSER HELPERS

   These have varaous types, e.g.,

     - Parser ()
     - String -> Parser String
     - Parser a -> Parser a
     - Parser a -> Parser ()

-}


spaces : Parser ()
spaces =
    ignore zeroOrMore (\c -> c == ' ')


ws : Parser ()
ws =
    ignore zeroOrMore (\c -> c == ' ' || c == '\n')


parseUntil : String -> Parser String
parseUntil marker =
    inContext "parseUntil" <|
        (ignoreUntil marker
            |> source
            |> map (String.dropRight <| String.length marker)
        )


allOrNothing : Parser a -> Parser a
allOrNothing parser =
    inContext "allOrNothing" <|
        delayedCommitMap always parser (succeed ())


mustFail : Parser a -> Parser ()
mustFail parser =
    inContext "mustFail" <|
        (oneOf
            [ delayedCommitMap always parser (succeed ()) |> map (always <| Err "I didn't fail")
            , succeed (Ok ())
            ]
            |> andThen
                (\res ->
                    case res of
                        Err e ->
                            fail e

                        Ok _ ->
                            succeed ()
                )
        )


word : Parser String
word =
    (inContext "word" <|
        succeed identity
            |. spaces
            |= keep oneOrMore notSpecialCharacter
            |. ws
    )
        -- |> map transformWords


{-| Like `word`, but after a word is recognized spaces, not spaces + newlines are consumed
-}
specialWord : Parser String
specialWord =
    inContext "specialWord" <|
        succeed identity
            |. spaces
            |= keep oneOrMore notSpecialTableOrMacroCharacter
            |. spaces


notSpecialTableOrMacroCharacter : Char -> Bool
notSpecialTableOrMacroCharacter c =
    not (c == ' ' || c == '\n' || c == '\\' || c == '$' || c == '}' || c == ']' || c == '&')


macroArgWord : Parser String
macroArgWord =
    inContext "specialWord" <|
        succeed identity
            |. spaces
            |= keep oneOrMore notMacroArgWordCharacter
            |. spaces


notMacroArgWordCharacter : Char -> Bool
notMacroArgWordCharacter c =
    not (c == '}' || c == ' ' || c == '\n')


reservedWord : Parser ()
reservedWord =
    inContext "reservedWord" <|
        (succeed identity
            |= oneOf [ symbol "\\begin", keyword "\\end", keyword "\\item", keyword "\\bibitem" ]
        )


smacroReservedWord : Parser ()
smacroReservedWord =
    inContext "reservedWord" <|
        (succeed identity
            |= oneOf [ symbol "\\begin", keyword "\\end", keyword "\\item" ]
        )


notSpecialCharacter : Char -> Bool
notSpecialCharacter c =
    not (c == ' ' || c == '\n' || c == '\\' || c == '$')


notMacroSpecialCharacter : Char -> Bool
notMacroSpecialCharacter c =
    not (c == '{' || c == '[' || c == ' ' || c == '\n')


{-| Transform special words
-}
transformWords : String -> String
transformWords str =
    if str == "--" then
        "\\ndash"
    else if str == "---" then
        "\\mdash"
    else
        str

