module MiniLatex.Differ
    exposing
        ( EditRecord
        , diff
        , emptyEditRecord
        , initialize
        , isEmpty
        , prefixer
        , update
        )

import MiniLatex.LatexState exposing (LatexState, emptyLatexState)
import MiniLatex.Paragraph as Paragraph


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
    , newIdsStart : Maybe Int
    , newIdsEnd : Maybe Int
    }


type alias EditRecord =
    { paragraphs : List String
    , renderedParagraphs : List String
    , latexState : LatexState
    , idList : List String
    , newIdsStart : Maybe Int
    , newIdsEnd : Maybe Int
    }


emptyEditRecord : EditRecord
emptyEditRecord =
    EditRecord [] [] emptyLatexState [] Nothing Nothing


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
            Paragraph.logicalParagraphify text

        n =
            List.length paragraphs

        idList =
            List.range 1 n |> List.map (prefixer 0)

        renderedParagraphs =
            List.map transformer paragraphs
    in
    EditRecord paragraphs renderedParagraphs emptyLatexState idList Nothing Nothing


isEmpty : EditRecord -> Bool
isEmpty editRecord =
    editRecord.paragraphs == [] && editRecord.renderedParagraphs == []


update : Int -> (String -> String) -> EditRecord -> String -> EditRecord
update seed transformer editorRecord text =
    let
        newParagraphs =
            Paragraph.logicalParagraphify text

        diffRecord =
            diff editorRecord.paragraphs newParagraphs

        diffPacket =
            renderDiff seed transformer diffRecord editorRecord editorRecord.renderedParagraphs
    in
    EditRecord newParagraphs diffPacket.renderedParagraphs emptyLatexState diffPacket.idList diffPacket.newIdsStart diffPacket.newIdsEnd


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


{-| Among other things, generate a fresh id list for the changed elements.
-}
renderDiff : Int -> (String -> String) -> DiffRecord -> EditRecord -> List String -> DiffPacket
renderDiff seed renderer diffRecord editRecord renderedStringList =
    let
        ii =
            List.length diffRecord.commonInitialSegment

        it =
            List.length diffRecord.commonTerminalSegment

        initialSegmentRendered =
            List.take ii renderedStringList

        terminalSegmentRendered =
            takeLast it renderedStringList

        ns =
            List.length diffRecord.middleSegmentInSource

        nt =
            List.length diffRecord.middleSegmentInTarget

        idListInitial =
            List.take ii editRecord.idList

        idListMiddle =
            List.range (ii + 1) (ii + nt) |> List.map (prefixer seed)

        idListTerminal =
            List.drop (ii + ns) editRecord.idList

        idList =
            idListInitial ++ idListMiddle ++ idListTerminal

        middleSegmentRendered =
            List.map renderer diffRecord.middleSegmentInTarget

        ( newIdsStart, newIdsEnd ) =
            Debug.log "newId Info"
                (if nt == 0 then
                    ( Nothing, Nothing )
                 else
                    ( Just ii, Just (ii + nt - 1) )
                )
    in
    { renderedParagraphs = initialSegmentRendered ++ middleSegmentRendered ++ terminalSegmentRendered
    , idList = idList
    , newIdsStart = newIdsStart
    , newIdsEnd = newIdsEnd
    }
