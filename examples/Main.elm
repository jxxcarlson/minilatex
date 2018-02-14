port module Main exposing (..)

{-| Test app for MiniLatex
-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.Keyed as Keyed
import MiniLatex.HasMath
import MiniLatex.Driver as MiniLatex
import MiniLatex.Differ exposing (EditRecord)
import Random
import Source
import View exposing (..)
import Types exposing (..)
import Json.Encode as Encode


main =
    Html.program { view = view, update = update, init = init, subscriptions = subscriptions }


init : ( Model, Cmd Msg )
init =
    let
        parseResult =
            MiniLatex.parse Source.initialText

        editRecord =
            MiniLatex.setup 0 Source.initialText

        model =
            { counter = 0
            , sourceText = Source.initialText
            , sourceText2 = Source.initialText
            , editRecord = editRecord
            , inputString = exportLatex2Html editRecord
            , parseResult = parseResult
            , hasMathResult = Debug.log "hasMathResult" (List.map MiniLatex.HasMath.listHasMath parseResult)
            , seed = 0
            , configuration = StandardView
            , lineViewStyle = Horizontal
            }
    in
        ( model, Random.generate NewSeed (Random.int 1 10000) )


port sendToJs : Encode.Value -> Cmd msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FastRender ->
            let
                newEditRecord =
                    MiniLatex.update model.seed model.editRecord model.sourceText

                parseResult =
                    MiniLatex.parse model.sourceText

                hasMathResult =
                    Debug.log "hasMathResult" (List.map MiniLatex.HasMath.listHasMath parseResult)
            in
                ( { model
                    | counter = model.counter + 1
                    , editRecord = newEditRecord
                    , parseResult = parseResult
                    , hasMathResult = hasMathResult
                  }
                , Cmd.batch
                    [ sendToJs <| encodeData "fast" newEditRecord.idList
                    , Random.generate NewSeed (Random.int 1 10000)
                    ]
                )

        ReRender ->
            useSource model.sourceText model

        Reset ->
            ( { model
                | counter = model.counter + 1
                , sourceText = ""
                , editRecord = MiniLatex.setup model.seed ""
              }
            , sendToJs <| encodeData "full" []
            )

        Restore ->
            ( { model
                | counter = model.counter + 1
                , sourceText = Source.initialText
                , editRecord = MiniLatex.setup model.seed Source.initialText
              }
            , sendToJs <| encodeData "full" []
            )

        GetContent str ->
            ( { model | sourceText = str }, Cmd.none )

        GenerateSeed ->
            ( model, Random.generate NewSeed (Random.int 1 10000) )

        NewSeed newSeed ->
            ( { model | seed = newSeed }, Cmd.none )

        ShowStandardView ->
            ( { model | configuration = StandardView }, Cmd.none )

        ShowParseResultsView ->
            ( { model | configuration = ParseResultsView }, Cmd.none )

        ShowRenderToLatexView ->
            ( { model | configuration = RenderToLatexView }, Cmd.none )

        ShowRawHtmlView ->
            ( { model | configuration = RawHtmlView }, Cmd.none )

        SetHorizontalView ->
            ( { model | lineViewStyle = Horizontal }, Cmd.none )

        SetVerticalView ->
            ( { model | lineViewStyle = Vertical }, Cmd.none )

        TechReport ->
            useSource Source.report model

        WavePackets ->
            useSource Source.wavePackets model

        WeatherApp ->
            useSource Source.weatherApp model

        MathPaper ->
            useSource Source.nongeodesic model

        Grammar ->
            useSource Source.grammar model

        Types.Input s ->
            ( { model | inputString = s }, Cmd.none )


useSource : String -> Model -> ( Model, Cmd Msg )
useSource text model =
    let
        editRecord =
            MiniLatex.setup model.seed text
    in
        ( { model
            | counter = model.counter + 1
            , sourceText = text
            , editRecord = editRecord
            , parseResult = MiniLatex.parse text
            , inputString = exportLatex2Html editRecord
          }
        , sendToJs <| encodeData "full" []
        )


exportLatex2Html : EditRecord -> String
exportLatex2Html editRecord =
    editRecord
        |> MiniLatex.getRenderedText ""
        |> \text -> Source.htmlPrefix ++ text ++ Source.htmlSuffix


encodeData model idList =
    let
        idValueList =
            Debug.log "idValueList"
                (List.map Encode.string idList)
    in
        [ ( "model", Encode.string model )
        , ( "idList", Encode.list idValueList )
        ]
            |> Encode.object



{- VIEW FUNCTIONS -}


view : Model -> Html Msg
view model =
    div [ style [ ( "width", appWidth model.configuration ), ( "margin", "auto" ) ] ]
        [ mainView model
        ]


mainView model =
    case model.configuration of
        StandardView ->
            standardView model

        ParseResultsView ->
            parseResultsView model

        RawHtmlView ->
            rawHtmlResultsView model

        RenderToLatexView ->
            renderToLatexView model


standardView model =
    div [ style [ ( "float", "left" ) ] ]
        [ headerRibbon
        , editor model
        , renderedSource model
        , spacer 5
        , footerRibbon model
        ]


renderToLatexView model =
    div [ style [ ( "float", "left" ) ] ]
        [ headerRibbon
        , editor model
        , renderedSource model
        , renderToLatex model
        , spacer 5
        , footerRibbon model
        ]


parseResultsView model =
    div [ style [ ( "float", "left" ) ] ]
        [ headerRibbon
        , editor model
        , renderedSource model
        , showParseResult model
        , spacer 5
        , footerRibbon model
        ]


rawHtmlResultsView model =
    div [ style [ ( "float", "left" ) ] ]
        [ headerRibbon
        , editor model
        , renderedSource model
        , showHtmlResult model
        , spacer 5
        , footerRibbon model
        ]
