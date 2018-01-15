module MiniLatex.Parser exposing (..)

import Dict
import Parser exposing (..)


{- ELLIE: https://ellie-app.com/pcB5b3BPfa1/0

   https://ellie-app.com/pcB5b3BPfa1/1

-}


{-| The type for the Abstract syntax tree
-}
type LatexExpression
    = LXString String
    | Comment String
    | Item Int LatexExpression
    | InlineMath String
    | DisplayMath String
    | Macro String (List LatexExpression)
    | Environment String LatexExpression
    | LatexList (List LatexExpression)



{- End of Has Math code -}


defaultLatexList : LatexExpression
defaultLatexList =
    LatexList [ LXString "Parse Error" ]


defaultLatexExpression : List LatexExpression
defaultLatexExpression =
    [ Macro "NULL" [] ]


parse : String -> List LatexExpression
parse text =
    let
        expr =
            Parser.run latexList text
    in
    case expr of
        Ok (LatexList list) ->
            list

        Err error ->
            [ LXString ("<strong>Error:</strong> " ++ "<pre class=\"errormessage\">" ++ toString error.problem ++ " </pre><strong>in </strong> </span><pre class=\"errormessage\">" ++ error.source ++ "</pre>") ]

        _ ->
            [ LXString "yada!" ]



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


reservedWord : Parser ()
reservedWord =
    inContext "reservedWord" <|
        (succeed identity
            |= oneOf [ symbol "\\begin", keyword "\\end", keyword "\\item" ]
        )



{- PARSERS FOR TERMINALS -- Type Parser String

   and helpers of type  Char -> Bool
-}


word : Parser String
word =
    inContext "word" <|
        succeed identity
            |. spaces
            |= keep oneOrMore notSpecialCharacter
            |. ws


notSpecialCharacter : Char -> Bool
notSpecialCharacter c =
    not (c == ' ' || c == '\n' || c == '\\' || c == '$')


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
    not (c == ' ' || c == '\n' || c == '\\' || c == '$' || c == '}' || c == '&')


macroName : Parser String
macroName =
    inContext "macroName" <|
        (allOrNothing <|
            succeed identity
                |. mustFail reservedWord
                |= innerMacroName
        )


innerMacroName : Parser String
innerMacroName =
    inContext "innerMacroName" <|
        succeed identity
            |. spaces
            |. symbol "\\"
            |= keep oneOrMore notMacroSpecialCharacter


notMacroSpecialCharacter : Char -> Bool
notMacroSpecialCharacter c =
    not (c == '{' || c == ' ' || c == '\n')


endWord : Parser String
endWord =
    inContext "endWord" <|
        (succeed identity
            |. ignore zeroOrMore ((==) ' ')
            |. symbol "\\end{"
            |= parseUntil "}"
        )



{- PARSERS FOR NON-TERMINAS: Type Parser LatexExpression

   or sometiemes Parser () -> Parser LatexExpresson

-}


{-| Production: $ LatexList &\Rightarrow LatexExpression^+ $
-}
latexList : Parser LatexExpression
latexList =
    inContext "latexList" <|
        (succeed identity
            |. ws
            |= repeat oneOrMore latexExpression
            |> map LatexList
        )


{-| Production: $ LatexExpression &\Rightarrow Words\ |\ Comment\ |\ IMath\ |\ DMath\ |\ Macro\ |\ Env $
-}
latexExpression : Parser LatexExpression
latexExpression =
    oneOf
        [ texComment
        , lazy (\_ -> environment)
        , displayMathDollar
        , displayMathBrackets
        , inlineMath ws
        , macro ws
        , words
        ]


words : Parser LatexExpression
words =
    inContext "words" <|
        (succeed identity
            |= repeat oneOrMore word
            |> map (String.join " ")
            |> map LXString
        )


{-| Like `words`, but after a word is recognized spaces, not spaces + newlines are consumed
-}
specialWords : Parser LatexExpression
specialWords =
    inContext "specialWords" <|
        (succeed identity
            |= repeat oneOrMore specialWord
            |> map (String.join " ")
            |> map LXString
        )


texComment : Parser LatexExpression
texComment =
    inContext "texComment" <|
        (symbol "%"
            |. ignoreUntil "\n"
            |> source
            |> map Comment
        )



{- MATHEMATICAL TEXT -}


inlineMath : Parser () -> Parser LatexExpression
inlineMath wsParser =
    inContext "inline math" <|
        succeed InlineMath
            |. symbol "$"
            |= parseUntil "$"
            |. wsParser


displayMathDollar : Parser LatexExpression
displayMathDollar =
    inContext "display math $$" <|
        succeed DisplayMath
            |. spaces
            |. symbol "$$"
            |= parseUntil "$$"
            |. spaces


displayMathBrackets : Parser LatexExpression
displayMathBrackets =
    inContext "display math brackets" <|
        succeed DisplayMath
            |. spaces
            |. symbol "\\["
            |= parseUntil "\\]"



{- MACROS -}
{- NOTE: macro sequences should be of the form "" followed by alphabetic characterS,
   but not equal to certain reserved words, e.g., "\begin", "\end", "\item"
-}


macro : Parser () -> Parser LatexExpression
macro wsParser =
    inContext "macro" <|
        succeed Macro
            |= macroName
            |= repeat zeroOrMore arg
            |. wsParser


{-| Use to parse arguments for macros
-}
arg : Parser LatexExpression
arg =
    inContext "arg" <|
        (succeed identity
            |. keyword "{"
            |= repeat zeroOrMore (oneOf [ specialWords, inlineMath spaces, lazy (\_ -> macro ws) ])
            |. symbol "}"
            |> map LatexList
        )



{- ENVIRONMENTS -}
{- Dispatcher code -}


environment : Parser LatexExpression
environment =
    inContext "environment" <|
        lazy (\_ -> envName |> andThen environmentOfType)


envName : Parser String
envName =
    inContext "envName" <|
        (succeed identity
            |. spaces
            |. symbol "\\begin{"
            |= parseUntil "}"
        )


environmentOfType : String -> Parser LatexExpression
environmentOfType envType =
    inContext "environmentOfType" <|
        let
            endWord =
                "\\end{" ++ envType ++ "}"

            envKind =
                if List.member envType [ "equation", "align", "eqnarray", "verbatim", "listing", "verse" ] then
                    "passThrough"
                else
                    envType
        in
        environmentParser envKind endWord envType


parseEnvironmentDict : Dict.Dict String (String -> String -> Parser LatexExpression)
parseEnvironmentDict =
    Dict.fromList
        [ ( "enumerate", \endWord envType -> itemEnvironmentBody endWord envType )
        , ( "itemize", \endWord envType -> itemEnvironmentBody endWord envType )
        , ( "tabular", \endWord envType -> tabularEnvironmentBody endWord envType )
        , ( "passThrough", \endWord envType -> passThroughBody endWord envType )
        ]


environmentParser : String -> String -> String -> Parser LatexExpression
environmentParser name =
    case Dict.get name parseEnvironmentDict of
        Just p ->
            p

        Nothing ->
            standardEnvironmentBody



{- Subparsers -}


standardEnvironmentBody : String -> String -> Parser LatexExpression
standardEnvironmentBody endWord envType =
    inContext "standardEnvironmentBody" <|
        (succeed identity
            |. ws
            |= repeat zeroOrMore latexExpression
            |. ws
            |. symbol endWord
            |. ws
            |> map LatexList
            |> map (Environment envType)
        )



{- ITEMIZED LISTS -}


itemEnvironmentBody : String -> String -> Parser LatexExpression
itemEnvironmentBody endWord envType =
    inContext "itemEnvironmentBody" <|
        let
            beginSymbol =
                ""
        in
        succeed identity
            |. ws
            |. symbol "\\item"
            |= repeat zeroOrMore (item endWord)
            |. ws
            |> map LatexList
            |> map (Environment envType)


item : String -> Parser LatexExpression
item endWord =
    inContext "item" <|
        (succeed identity
            |. spaces
            |= repeat zeroOrMore (oneOf [ words, inlineMath ws, macro ws ])
            |. ws
            |. oneOf [ symbol "\\item", symbol endWord ]
            |> map (\x -> Item 1 (LatexList x))
        )


tabularEnvironmentBody : String -> String -> Parser LatexExpression
tabularEnvironmentBody endWord envType =
    inContext "tabularEnvironmentBody" <|
        (succeed identity
            |. ws
            |= tableBody
            |. ws
            |. symbol endWord
            |. ws
            |> map (Environment envType)
        )


{-| The body of the environment is parsed as an LXString.
This parser is used for envronments whose body is to be
passed to MathJax for processing and also for the verbatim
environment.
-}
passThroughBody : String -> String -> Parser LatexExpression
passThroughBody endWord envType =
    inContext "passThroughBody" <|
        (succeed identity
            |= parseUntil endWord
            |. ws
            |> map LXString
            |> map (Environment envType)
        )



{- TABLE -}


tableCell : Parser LatexExpression
tableCell =
    inContext "tableCell" <|
        (succeed identity
            |. spaces
            |= oneOf [ inlineMath spaces, specialWords ]
        )


tableRow : Parser LatexExpression
tableRow =
    inContext "tableRow" <|
        (succeed identity
            |. spaces
            |= andThen (\c -> tableCellHelp [ c ]) tableCell
            |. spaces
            |. oneOf [ symbol "\n", symbol "\\\\\n" ]
            |> map LatexList
        )


tableCellHelp : List LatexExpression -> Parser (List LatexExpression)
tableCellHelp revCells =
    inContext "tableCellHelp" <|
        oneOf
            [ nextCell
                |> andThen (\c -> tableCellHelp (c :: revCells))
            , succeed (List.reverse revCells)
            ]


nextCell : Parser LatexExpression
nextCell =
    inContext "nextCell" <|
        (delayedCommit spaces <|
            succeed identity
                |. symbol "&"
                |. spaces
                |= tableCell
        )


tableBody : Parser LatexExpression
tableBody =
    inContext "tableBody" <|
        (succeed identity
            |. repeat zeroOrMore arg
            |. ws
            |= repeat oneOrMore tableRow
            |> map LatexList
        )
