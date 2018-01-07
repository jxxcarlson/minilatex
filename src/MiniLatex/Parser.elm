module MiniLatex.Parser exposing (..)

import Dict
import List.Extra
import Parser exposing (..)


{- ELLIE: https://ellie-app.com/pcB5b3BPfa1/0

   https://ellie-app.com/pcB5b3BPfa1/1

-}


{-| Types
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


defaultLatexList : LatexExpression
defaultLatexList =
    LatexList [ LXString "Parse Error" ]


defaultLatexExpression : List LatexExpression
defaultLatexExpression =
    [ Macro "NULL" [] ]


parseParagraph : String -> List LatexExpression
parseParagraph text =
    let
        expr =
            Parser.run latexList text
    in
        case expr of
            Ok (LatexList list) ->
                list

            Err error ->
                [ LXString ("<strong>Error:</strong> " ++ "<pre class=\"errormessage\">" ++ (toString error.problem) ++ " </pre><strong>in </strong> </span><pre class=\"errormessage\">" ++ error.source ++ "</pre>") ]

            _ ->
                [ LXString "yada!" ]



-- |> Result.withDefault defaultLatexExpression
{- PARSER: TOP LEVEL -}


latexList : Parser LatexExpression
latexList =
    inContext "latexList" <|
        (succeed identity
            |= repeat oneOrMore parse
            |> map LatexList
        )


parse : Parser LatexExpression
parse =
    oneOf
        [ texComment
        , lazy (\_ -> environment)
        , displayMathDollar
        , displayMathBrackets
        , inlineMath
        , macro
        , words
        ]



{- PARSER HELPERS -}


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



{- PARSE WORDS -}


word : Parser String
word =
    inContext "word" <|
        succeed identity
            |. spaces
            |= keep oneOrMore (\c -> not (c == ' ' || c == '\n' || c == '\\' || c == '$'))
            |. ignore zeroOrMore (\c -> c == ' ' || c == '\n')


{-| Like `word`, but after a word is recognized spaces, not spaces + newlines are consumed
-}
word2 : Parser String
word2 =
    inContext "word2" <|
        succeed identity
            |. spaces
            |= keep oneOrMore (\c -> not (c == ' ' || c == '\n' || c == '\\' || c == '$' || c == '}' || c == '&'))
            |. spaces


word2a : Parser String
word2a =
    inContext "word" <|
        succeed identity
            |. spaces
            |= keep oneOrMore (\c -> not (c == ' ' || c == '\n' || c == '\\' || c == '$' || c == '}'))
            |. spaces


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
words2 : Parser LatexExpression
words2 =
    inContext "words2" <|
        (succeed identity
            |= repeat oneOrMore word2
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



{- ITEMIZED LISTS -}


item : Parser LatexExpression
item =
    inContext "item" <|
        (succeed identity
            |. ws
            |. keyword "\\item"
            |. spaces
            |= repeat zeroOrMore (oneOf [ words2, inlineMath2, macro2 ])
            |. symbol "\n"
            |. spaces
            |> map (\x -> Item 1 (LatexList x))
        )



{- MATHEMATICAL TEXT -}


inlineMath : Parser LatexExpression
inlineMath =
    inContext "inline math" <|
        succeed InlineMath
            |. symbol "$"
            |= parseUntil "$"
            |. ws


{-| Like `inlineMath`, but only spaces, note spaces + newlines, are consumed after recognizing an element
-}
inlineMath2 : Parser LatexExpression
inlineMath2 =
    inContext "inline math" <|
        succeed InlineMath
            |. symbol "$"
            |= parseUntil "$"
            |. spaces


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
            |. ignore zeroOrMore ((==) ' ')
            |. symbol "\\["
            |= parseUntil "\\]"



{- MACROS -}
{- NOTE: macro sequences should be of the form "" followed by alphabetic characterS,
   but not equal to certain reserved words, e.g., "\begin", "\end", "\item"
-}


macro : Parser LatexExpression
macro =
    inContext "macro" <|
        succeed Macro
            |= macroName
            |= repeat zeroOrMore arg
            |. ws


{-| Like macro, but only spaces, not spaces + nelines are consumed after recognition
-}
macro2 : Parser LatexExpression
macro2 =
    inContext "macro2" <|
        succeed Macro
            |= macroName
            |= repeat zeroOrMore arg
            |. spaces


{-| Use to parse arguments for macros
-}
arg : Parser LatexExpression
arg =
    inContext "arg" <|
        (succeed identity
            |. keyword "{"
            |= repeat zeroOrMore (oneOf [ words2, inlineMath2, lazy (\_ -> macro) ])
            |. symbol "}"
            |> map LatexList
        )


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
            |= keep zeroOrMore (\c -> not (c == '{' || c == ' ' || c == '\n'))


allOrNothing : Parser a -> Parser a
allOrNothing parser =
    inContext "allOrNothing" <|
        (delayedCommitMap always parser (succeed ()))


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



{- ENVIRONMENTS -}
{- Dispatcher code -}


environment : Parser LatexExpression
environment =
    inContext "environment" <|
        (lazy (\_ -> beginWord |> andThen environmentOfType))


parseEnvirnomentDict =
    Dict.fromList
        [ ( "enumerate", \endWord envType -> itemEnvironmentBody endWord envType )
        , ( "itemize", \endWord envType -> itemEnvironmentBody endWord envType )
        , ( "tabular", \endWord envType -> tabularEnvironmentBody endWord envType )
        , ( "mathJax", \endWord envType -> mathJaxBody endWord envType )
        ]


environmentParser name =
    case Dict.get name parseEnvirnomentDict of
        Just p ->
            p

        Nothing ->
            standardEnvironmentBody


environmentOfType : String -> Parser LatexExpression
environmentOfType envType =
    inContext "environmentOfType" <|
        (let
            endWord =
                "\\end{" ++ envType ++ "}"

            envKind =
                if List.member envType [ "equation", "align", "eqnarray", "verbatim", "verse" ] then
                    "mathJax"
                else
                    envType
         in
            environmentParser envKind endWord envType
        )



{- Subparsers -}


standardEnvironmentBody endWord envType =
    inContext "standardEnvironmentBody" <|
        (succeed identity
            |. ws
            |= repeat zeroOrMore parse
            |. ws
            |. symbol endWord
            |. ws
            |> map LatexList
            |> map (Environment envType)
        )


itemEnvironmentBody endWord envType =
    inContext "itemEnvironmentBody" <|
        (succeed identity
            |. ws
            |= repeat zeroOrMore (oneOf [ item, texComment ])
            |. ws
            |. symbol endWord
            |. ws
            |> map LatexList
            |> map (Environment envType)
        )


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
mathJaxBody endWord envType =
    inContext "mathJaxBody" <|
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
            |= oneOf [ inlineMath2, words2 ]
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
        (oneOf
            [ nextCell
                |> andThen (\c -> tableCellHelp (c :: revCells))
            , succeed (List.reverse revCells)
            ]
        )


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



{- XXXX -}


beginWord : Parser String
beginWord =
    inContext "beginWord" <|
        (succeed identity
            |. ignore zeroOrMore ((==) ' ')
            |. symbol "\\begin{"
            |= parseUntil "}"
        )


endWord : Parser String
endWord =
    inContext "endWord" <|
        (succeed identity
            |. ignore zeroOrMore ((==) ' ')
            |. symbol "\\end{"
            |= parseUntil "}"
        )
