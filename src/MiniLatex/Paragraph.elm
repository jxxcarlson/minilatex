module MiniLatex.Paragraph exposing (logicalParagraphify)

import MiniLatex.Parser
import Parser
import Regex


type ParserState
    = Start
    | InParagraph
    | InBlock String
    | IgnoreLine
    | Error


type LineType
    = Blank
    | Ignore
    | Text
    | BeginBlock String
    | EndBlock String


type alias ParserRecord =
    { currentParagraph : String, paragraphList : List String, state : ParserState }


getBeginArg : String -> String
getBeginArg line =
    let
        parseResult =
            Parser.run MiniLatex.Parser.envName line

        arg =
            case parseResult of
                Ok word ->
                    word

                Err _ ->
                    ""
    in
    arg


getEndArg : String -> String
getEndArg line =
    let
        parseResult =
            Parser.run MiniLatex.Parser.endWord line

        arg =
            case parseResult of
                Ok word ->
                    word

                Err _ ->
                    ""
    in
    arg


lineType : String -> LineType
lineType line =
    if line == "" then
        Blank
    else if line == "\\begin{thebibliography}" || line == "\\end{thebibliography}" then
        Ignore
    else if String.startsWith "\\begin" line then
        BeginBlock (getBeginArg line)
    else if String.startsWith "\\end" line then
        EndBlock (getEndArg line)
    else
        Text


{-| nextState is the transition function for a finite-state
machine which parses lines.
-}
nextState : String -> ParserState -> ParserState
nextState line parserState =
    case ( parserState, lineType line ) of
        ( Start, Blank ) ->
            Start

        ( Start, Text ) ->
            InParagraph

        ( Start, BeginBlock arg ) ->
            InBlock arg

        ( Start, Ignore ) ->
            IgnoreLine

        ( IgnoreLine, Blank ) ->
            Start

        ( IgnoreLine, Text ) ->
            InParagraph

        ( IgnoreLine, BeginBlock arg ) ->
            InBlock arg

        ( InBlock arg, Blank ) ->
            InBlock arg

        ( InBlock arg, Text ) ->
            InBlock arg

        ( InBlock arg, BeginBlock arg2 ) ->
            InBlock arg

        ( InBlock arg1, EndBlock arg2 ) ->
            if arg1 == arg2 then
                Start
            else
                InBlock arg1

        ( InParagraph, Text ) ->
            InParagraph

        ( InParagraph, BeginBlock str ) ->
            InParagraph

        ( InParagraph, EndBlock arg ) ->
            InParagraph

        ( InParagraph, Blank ) ->
            Start

        ( _, _ ) ->
            Error


joinLines : String -> String -> String
joinLines a b =
    case ( a, b ) of
        ( "", _ ) ->
            b

        ( _, "" ) ->
            a

        ( "\n", _ ) ->
            "\n" ++ b

        ( _, "\n" ) ->
            a ++ "\n"

        ( a, b ) ->
            a ++ "\n" ++ b


fixLine : String -> String
fixLine line =
    if line == "" then
        "\n"
    else
        line


updateParserRecord : String -> ParserRecord -> ParserRecord
updateParserRecord line parserRecord =
    let
        state2 =
            nextState line parserRecord.state
    in
    case state2 of
        Start ->
            { parserRecord
                | currentParagraph = ""
                , paragraphList = parserRecord.paragraphList ++ [ joinLines parserRecord.currentParagraph line ]
                , state = state2
            }

        InParagraph ->
            { parserRecord
                | currentParagraph = joinLines parserRecord.currentParagraph line
                , state = state2
            }

        InBlock arg ->
            { parserRecord
                | currentParagraph = joinLines parserRecord.currentParagraph (fixLine line)
                , state = state2
            }

        IgnoreLine ->
            { parserRecord
                | state = state2
            }

        Error ->
            parserRecord


logicalParagraphParse : String -> ParserRecord
logicalParagraphParse text =
    (text ++ "\n")
        |> String.split "\n"
        |> List.foldl updateParserRecord { currentParagraph = "", paragraphList = [], state = Start }


{-| logicalParagraphify text: split text into logical
parapgraphs, where these are either normal paragraphs, i.e.,
blocks text with no blank lines surrounded by blank lines,
or outer blocks of the form \begin{_} ... \end{_}.
-}
logicalParagraphify : String -> List String
logicalParagraphify text =
    let
        lastState =
            logicalParagraphParse text
    in
    lastState.paragraphList
        ++ [ lastState.currentParagraph ]
        |> List.filter (\x -> x /= "")
        |> List.map (\paragraph -> paragraph ++ "\n\n\n")


paragraphify : String -> List String
paragraphify text =
    --String.split "\n\n" text
    Regex.split Regex.All (Regex.regex "\\n\\n+") text
        |> List.filter (\x -> String.length x /= 0)
        |> List.map (String.trim >> (\x -> x ++ "\n\n"))
