module MiniLatex.Differ
    exposing
        ( EditRecord
        , ParserRecord
        , ParserState(..)
        , diff
          -- for testing
        , emptyEditRecord
        , initialize
        , isEmpty
        , logicalParagraphParse
        , logicalParagraphify
        , nextState
        , paragraphify
        , renderDiff
          -- for testing
        , update
        , updateParserRecord
        )

import MiniLatex.LatexState exposing (LatexState, emptyLatexState)
import MiniLatex.Parser
import Parser
import Regex


{- TYPES -}


type alias DiffRecord =
    { commonInitialSegment : List String
    , commonTerminalSegment : List String
    , middleSegmentInSource : List String
    , middleSegmentInTarget : List String
    }


type alias DiffPacket =
    { renderedParagraphs : List String
    , idList : List String
    , idListStart : Int
    }


type alias EditRecord =
    { paragraphs : List String
    , renderedParagraphs : List String
    , latexState : LatexState
    , idList : List String
    , idListStart : Int
    }


emptyEditRecord : EditRecord
emptyEditRecord =
    EditRecord [] [] emptyLatexState [] 0


type ParserState
    = Start
    | InParagraph
    | InBlock String
    | Error


type LineType
    = Blank
    | Text
    | BeginBlock String
    | EndBlock String


type alias ParserRecord =
    { currentParagraph : String, paragraphList : List String, state : ParserState }


getBeginArg : String -> String
getBeginArg line =
    let
        parseResult =
            Parser.run MiniLatex.Parser.beginWord line

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

        _ =
            Debug.log "nextState" state2
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
or outer blocks of the form \begin{*} ... \end{*}.
-}
logicalParagraphify : String -> List String
logicalParagraphify text =
    let
        lastState =
            logicalParagraphParse text
    in
        lastState.paragraphList ++ [ lastState.currentParagraph ] |> List.filter (\x -> x /= "")


paragraphify : String -> List String
paragraphify text =
    --String.split "\n\n" text
    Regex.split Regex.All (Regex.regex "\\n\\n+") text
        |> List.filter (\x -> String.length x /= 0)
        |> List.map (String.trim >> (\x -> x ++ "\n\n"))


commonInitialSegment : List String -> List String -> List String
commonInitialSegment x y =
    if x == [] then
        []
    else if y == [] then
        []
    else
        let
            a =
                List.take 1 x

            b =
                List.take 1 y
        in
            if a == b then
                a ++ commonInitialSegment (List.drop 1 x) (List.drop 1 y)
            else
                []


commonTerminalSegment : List String -> List String -> List String
commonTerminalSegment x y =
    commonInitialSegment (List.reverse x) (List.reverse y) |> List.reverse


dropLast : Int -> List String -> List String
dropLast k x =
    x |> List.reverse |> List.drop k |> List.reverse


takeLast : Int -> List String -> List String
takeLast k x =
    x |> List.reverse |> List.take k |> List.reverse


initialize : (String -> String) -> String -> EditRecord
initialize transformer text =
    let
        paragraphs =
            logicalParagraphify text

        n =
            List.length paragraphs

        idList =
            List.range 1 n |> List.map (prefixer 0)

        renderedParagraphs =
            List.map transformer paragraphs
    in
        EditRecord paragraphs renderedParagraphs emptyLatexState idList 0


initialize2 : (List String -> ( List String, LatexState )) -> String -> EditRecord
initialize2 transformParagraphs text =
    let
        paragraphs =
            logicalParagraphify text

        n =
            List.length paragraphs

        idList =
            List.range 1 n |> List.map (prefixer 0)

        ( renderedParagraphs, latexState ) =
            transformParagraphs paragraphs
    in
        EditRecord paragraphs renderedParagraphs latexState idList 0


isEmpty : EditRecord -> Bool
isEmpty editRecord =
    editRecord.paragraphs == [] && editRecord.renderedParagraphs == []


update : Int -> (String -> String) -> EditRecord -> String -> EditRecord
update seed transformer editorRecord text =
    let
        newParagraphs =
            logicalParagraphify text

        diffRecord =
            diff editorRecord.paragraphs newParagraphs

        diffPacket =
            renderDiff seed transformer diffRecord editorRecord.renderedParagraphs
    in
        EditRecord newParagraphs diffPacket.renderedParagraphs emptyLatexState diffPacket.idList diffPacket.idListStart


diff : List String -> List String -> DiffRecord
diff u v =
    let
        a =
            commonInitialSegment u v

        b =
            commonTerminalSegment u v

        la =
            List.length a

        lb =
            List.length b

        x =
            u |> List.drop la |> dropLast lb

        y =
            v |> List.drop la |> dropLast lb

        bb =
            if la == List.length u then
                []
            else
                b
    in
        DiffRecord a bb x y


prefixer : Int -> Int -> String
prefixer b k =
    "p." ++ toString b ++ "." ++ toString k


renderDiff : Int -> (String -> String) -> DiffRecord -> List String -> DiffPacket
renderDiff seed renderer diffRecord renderedStringList =
    let
        ii =
            List.length diffRecord.commonInitialSegment

        it =
            List.length diffRecord.commonTerminalSegment

        initialSegmentRendered =
            List.take ii renderedStringList

        terminalSegmentRendered =
            takeLast it renderedStringList

        n =
            List.length diffRecord.middleSegmentInTarget

        idList =
            List.range 1 n |> List.map (prefixer seed)

        middleSegmentRendered =
            List.map renderer diffRecord.middleSegmentInTarget
    in
        { renderedParagraphs = initialSegmentRendered ++ middleSegmentRendered ++ terminalSegmentRendered
        , idList = idList
        , idListStart = ii
        }
