module MiniLatex.Differ
    exposing
        ( EditRecord
        , emptyEditRecord
        , initialize
        , isEmpty
        , paragraphify
        , update
        , diff
          -- for testing
        , renderDiff
          -- for testing
        )

import Regex
import MiniLatex.LatexState exposing (LatexState, emptyLatexState)


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


paragraphify : String -> List String
paragraphify text =
    --String.split "\n\n" text
    Regex.split Regex.All (Regex.regex "\\n\\n+") text
        |> List.filter (\x -> String.length x /= 0)
        |> List.map ((String.trim) >> (\x -> x ++ "\n\n"))


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
            paragraphify text

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
            paragraphify text

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
            paragraphify text

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
            if la == (List.length u) then
                []
            else
                b
    in
        DiffRecord a bb x y


prefixer : Int -> Int -> String
prefixer b k =
    "p." ++ (toString b) ++ "." ++ (toString k)


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
            (List.map renderer) diffRecord.middleSegmentInTarget
    in
        { renderedParagraphs = initialSegmentRendered ++ middleSegmentRendered ++ terminalSegmentRendered
        , idList = idList
        , idListStart = ii
        }
