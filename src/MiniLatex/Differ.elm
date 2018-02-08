module MiniLatex.Differ
    exposing
        ( EditRecord
        , createEditRecord
        , diff
        , emptyEditRecord
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


type alias IdListPacket =
    { idList : List String
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


createEditRecord : (String -> String) -> String -> EditRecord
createEditRecord transformer text =
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
update seed transformer editRecord text =
    let
        newParagraphs =
            Paragraph.logicalParagraphify text

        diffRecord =
            diff editRecord.paragraphs newParagraphs

        newRenderedParagraphs =
            differentialRender transformer diffRecord editRecord

        p =
            differentialIdList seed diffRecord editRecord
    in
    EditRecord newParagraphs newRenderedParagraphs emptyLatexState p.idList p.newIdsStart p.newIdsEnd


{-| Let u and v be two lists of strings. Write them as
u = axb, v = ayb, where a is the greatest common prefix
and b is the greatest common suffix. Return DiffRecord a b x y
-}
diff : List String -> List String -> DiffRecord
diff u v =
    let
        a =
            commonInitialSegment u v

        b_ =
            commonTerminalSegment u v

        la =
            List.length a

        lb =
            List.length b_

        x =
            u |> List.drop la |> dropLast lb

        y =
            v |> List.drop la |> dropLast lb

        b =
            if la == List.length u then
                []
            else
                b_
    in
    DiffRecord a b x y


prefixer : Int -> Int -> String
prefixer b k =
    "p." ++ toString b ++ "." ++ toString k


{-| Given:

  - a seed : Int

  - a `renderer` which maps strings to strings

  - a `diffRecord`, which identifies the locaton of changed strings in a list of strings

  - an `editRecord`, which gives existing state as follows:
    -- paragraphs : List String
    -- renderedParagraphs : List String
    -- latexState : LatexState

    The renderer is applied to the source text of the paragraphs
    that have changed an updated renderedParagraphs list is returned
    as part of a diffPacket. That packet also contains information
    on paragrah ids. (This may be unnecessary).

Among other things, generate a fresh id list for the changed elements.

-}
differentialRender : (String -> String) -> DiffRecord -> EditRecord -> List String
differentialRender renderer diffRecord editRecord =
    let
        ii =
            List.length diffRecord.commonInitialSegment

        it =
            List.length diffRecord.commonTerminalSegment

        initialSegmentRendered =
            List.take ii editRecord.renderedParagraphs

        terminalSegmentRendered =
            takeLast it editRecord.renderedParagraphs

        middleSegmentRendered =
            List.map renderer diffRecord.middleSegmentInTarget
    in
    initialSegmentRendered ++ middleSegmentRendered ++ terminalSegmentRendered


differentialIdList : Int -> DiffRecord -> EditRecord -> IdListPacket
differentialIdList seed diffRecord editRecord =
    let
        ii =
            List.length diffRecord.commonInitialSegment

        it =
            List.length diffRecord.commonTerminalSegment

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

        ( newIdsStart, newIdsEnd ) =
            if nt == 0 then
                ( Nothing, Nothing )
            else
                ( Just ii, Just (ii + nt - 1) )
    in
    { idList = idList
    , newIdsStart = newIdsStart
    , newIdsEnd = newIdsEnd
    }
