module MiniLatex.Parser exposing (..)

-- ( LatexExpression(..)
-- , defaultLatexList
-- , endWord
-- , envName
-- , latexList
-- , macro
-- , parse
-- , ws
-- )

import Dict
import MiniLatex.ParserHelpers exposing (..)
import Parser exposing (..)


{- ELLIE: https://ellie-app.com/pcB5b3BPfa1/0

   https://ellie-app.com/pcB5b3BPfa1/1

-}
{- End of Has Math code -}


{-| The type for the Abstract syntax tree
-}
type LatexExpression
    = LXString String
    | Comment String
    | Item Int LatexExpression
    | InlineMath String
    | DisplayMath String
    | SMacro String (List LatexExpression) LatexExpression
    | Macro String (List LatexExpression)
    | Environment String LatexExpression
    | LatexList (List LatexExpression)


smacro : Parser LatexExpression
smacro =
    succeed SMacro
        |= smacroName
        |= repeat zeroOrMore arg
        |= smacroBody


smacroBody : Parser LatexExpression
smacroBody =
    inContext "smacroBody" <|
        (succeed identity
            |. spaces
            |= repeat oneOrMore (oneOf [ specialWords, inlineMath spaces, macro spaces ])
            |. symbol "\n\n"
            |> map (\x -> LatexList x)
        )



-- bibitem =
--     andThen (parseUntil "\n\n")
-- |= andThen (\x -> "foo") parseUntil "\n\n"


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
            [ LXString (errorMessage2 error) ]

        _ ->
            [ LXString "yada!" ]


errorMessage error =
    "<strong>Error:</strong> "
        ++ "<pre class=\"errormessage\">"
        ++ toString error.problem
        ++ " </pre><strong>in </strong> </span><pre class=\"errormessage\">"
        ++ error.source
        ++ "</pre>"


errorMessage2 error =
    "row: "
        ++ toString error.row
        ++ "\ncol: "
        ++ toString error.col
        ++ "\nProblem: "
        ++ toString error.problem
        ++ "\nContext: "
        ++ toString error.context
        ++ "\nSource: "
        ++ error.source



{- WORDS AND TEXT -}


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


macroName : Parser String
macroName =
    inContext "macroName" <|
        (allOrNothing <|
            succeed identity
                |. mustFail reservedWord
                |= innerMacroName
        )


smacroName : Parser String
smacroName =
    inContext "macroName" <|
        (allOrNothing <|
            succeed identity
                |. mustFail smacroReservedWord
                |= innerMacroName
        )


innerMacroName : Parser String
innerMacroName =
    inContext "innerMacroName" <|
        succeed identity
            |. spaces
            |. symbol "\\"
            |= keep oneOrMore notMacroSpecialCharacter



{- Latex List and Expression -}


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
        , smacro
        , words
        ]



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



{- ENVIRONMENTS -}


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


endWord : Parser String
endWord =
    inContext "endWord" <|
        (succeed identity
            |. ignore zeroOrMore ((==) ' ')
            |. symbol "\\end{"
            |= parseUntil "}"
        )



{- DISPATCHER AND SUBPARSERS -}


environmentParser : String -> String -> String -> Parser LatexExpression
environmentParser name =
    case Dict.get name parseEnvironmentDict of
        Just p ->
            p

        Nothing ->
            standardEnvironmentBody


parseEnvironmentDict : Dict.Dict String (String -> String -> Parser LatexExpression)
parseEnvironmentDict =
    Dict.fromList
        [ ( "enumerate", \endWord envType -> itemEnvironmentBody endWord envType )
        , ( "itemize", \endWord envType -> itemEnvironmentBody endWord envType )
        , ( "tabular", \endWord envType -> tabularEnvironmentBody endWord envType )
        , ( "passThrough", \endWord envType -> passThroughBody endWord envType )
        ]


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
            |= repeat zeroOrMore item
            |. ws
            |. symbol endWord
            |. ws
            |> map LatexList
            |> map (Environment envType)


item : Parser LatexExpression
item =
    inContext "item" <|
        (succeed identity
            |. spaces
            |. symbol "\\item"
            |. spaces
            |= repeat zeroOrMore (oneOf [ words, inlineMath spaces, macro spaces ])
            |. ws
            |> map (\x -> Item 1 (LatexList x))
        )



{- TABLES -}


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


tableBody : Parser LatexExpression
tableBody =
    inContext "tableBody" <|
        (succeed identity
            |. repeat zeroOrMore arg
            |. ws
            |= repeat oneOrMore tableRow
            |> map LatexList
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


tableCell : Parser LatexExpression
tableCell =
    inContext "tableCell" <|
        (succeed identity
            |. spaces
            |= oneOf [ inlineMath spaces, specialWords ]
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
