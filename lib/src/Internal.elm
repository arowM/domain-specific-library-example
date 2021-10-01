module Internal exposing
    ( run
    , Model
    , Msg
    , Page
    )

{-| Domain specific framework for our application.


# Core

@docs run
@docs Model
@docs Msg
@docs Page

-}

import Browser
import Browser.Events as Browser
import Browser.Navigation as Nav exposing (Key)
import Html exposing (Html)
import Html.Attributes as Attributes exposing (class)
import Html.Events as Events
import Html.Keyed as Keyed
import Init
import Internal.Constants as Constants
import Internal.Page as Page
import Internal.Route as Route
import Internal.Slide as Slide
import Json.Decode as JD exposing (Decoder)
import Task
import Update exposing (Update)
import Update.Lifter exposing (Lifter)
import Update.Sequence as Sequence
import Url exposing (Url)
import Url.Builder as Url



-- Core


{-| Generate a slide application from a list of `Page`.
-}
run : (() -> Cmd Msg) -> (flags -> Page) -> List (flags -> Page) -> Program flags Model Msg
run extraJS cover ps =
    Browser.application
        { init = init extraJS cover ps
        , view = view
        , update = Update.run << update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange =
            UrlChanged
                >> Sequence.resolve
                >> SeqMsg
        }


{-| -}
type alias Page =
    Page.Page Msg


{-| -}
type Model
    = Model Model_


type alias Model_ =
    { sequence : Sequence.Model
    , flow : Flow
    , key : Key
    , page : PageView
    , extraJS : () -> Cmd Msg
    }


init : (() -> Cmd Msg) -> (flags -> Page) -> List (flags -> Page) -> flags -> Url -> Key -> ( Model, Cmd Msg )
init extraJS cover pages flags url key =
    Init.top Model_
        |> Init.noCmd Sequence.initModel
        |> Init.noCmd
            (Loading_
                { url = url
                , initSlide = Slide.fromPages (cover flags) (List.map (\f -> f flags) pages)
                }
            )
        |> Init.noCmd key
        |> Init.noCmd LoadingView
        |> Init.noCmd extraJS
        |> Init.andThen
            (Sequence.call Start
                |> Update.map SeqMsg
                |> Update.run
            )
        |> Tuple.mapFirst Model



-- -- Helper functions


jump : Flow -> Update Model Msg
jump flow =
    Update.batch
        [ Update.modify <| \(Model model) -> Model { model | sequence = Sequence.initModel }
        , Update.modify <| \(Model model) -> Model { model | flow = flow }
        , Sequence.call Start
        ]
        |> Update.map SeqMsg


seqLifter : Lifter Model Sequence.Model
seqLifter =
    { get = \(Model model) -> model.sequence
    , set = \sequence (Model model) -> Model { model | sequence = sequence }
    }



-- Msg


{-| -}
type Msg
    = SeqMsg (Sequence.Msg SeqMsg)
    | LinkClicked Browser.UrlRequest


type SeqMsg
    = Start
    | ClickProceed
    | DownRightKey
    | ClickBack
    | DownLeftKey
    | UrlChanged Url
    | LoadRoute Slide


update : Msg -> Update Model Msg
update message =
    case message of
        SeqMsg msg ->
            Update.with (\(Model model) -> model)
                [ \model ->
                    case model.flow of
                        Loading_ loading ->
                            seqLoading loading msg

                        ShowSlide_ showSlide ->
                            seqShowSlide showSlide msg
                ]

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    Update.push <|
                        \(Model model) ->
                            Url.toString url
                                |> Nav.pushUrl model.key

                Browser.External href ->
                    Update.push <| \_ -> Nav.load href


type Flow
    = Loading_ Loading
    | ShowSlide_ ShowSlide


type alias Loading =
    { url : Url
    , initSlide : Slide
    }


type alias ShowSlide =
    { slide : Slide
    }



-- View


view : Model -> Browser.Document Msg
view (Model model) =
    case model.page of
        LoadingView ->
            { title = "Loading"
            , body = [ loadingView ]
            }

        SlideView slide ->
            { title =
                slide
                    |> Slide.current
                    |> Page.title
            , body = [ slideView slide ]
            }



-- ## 画面要素
-- -- ### _{slideBody}_


slideBody : Slide -> Html Msg
slideBody slide =
    Keyed.node "div"
        [ class "slide_body"
        ]
    <|
        List.filterMap identity
            [ case Slide.prev slide of
                Nothing ->
                    Nothing

                Just prev ->
                    Just
                        ( Page.title prev
                        , Html.section
                            [ Attributes.attribute "data-slide" "prev"
                            , class "slide_body_section"
                            ]
                            [ Page.view prev
                            ]
                        )
            , Just
                ( Slide.current slide |> Page.title
                , Html.section
                    [ Attributes.attribute "data-slide" "current"
                    , class "slide_body_section"
                    ]
                    [ Page.view (Slide.current slide)
                    ]
                )
            , case Slide.next slide of
                Nothing ->
                    Nothing

                Just next ->
                    Just
                        ( Page.title next
                        , Html.section
                            [ Attributes.attribute "data-slide" "next"
                            , class "slide_body_section"
                            ]
                            [ Page.view next
                            ]
                        )
            , case Slide.next slide of
                Nothing ->
                    Nothing

                Just _ ->
                    Just
                        ( "slide_body_proceedButton"
                        , Html.button
                            [ class "slide_body_proceedButton"
                            , ClickProceed
                                |> Sequence.resolve
                                |> SeqMsg
                                |> Events.onClick
                            ]
                            [ Html.text "▶"
                            ]
                        )
            , case Slide.prev slide of
                Nothing ->
                    Nothing

                Just _ ->
                    Just
                        ( "slide_body_backButton"
                        , Html.button
                            [ class "slide_body_backButton"
                            , ClickBack
                                |> Sequence.resolve
                                |> SeqMsg
                                |> Events.onClick
                            ]
                            [ Html.text "◀"
                            ]
                        )
            ]



-- ## ページ表示
-- -- ### _(loading)_


type PageView
    = LoadingView
    | SlideView Slide


loadingView : Html msg
loadingView =
    Html.text
        """
        Loading...
        """



-- -- ### _(slide)_


slideView : Slide -> Html Msg
slideView slide =
    Html.div
        [ class "slide"
        ]
        [ slideBody slide
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.onKeyDown keyDecoder


keyDecoder : Decoder Msg
keyDecoder =
    JD.andThen
        (\str ->
            case str of
                "ArrowLeft" ->
                    DownLeftKey
                        |> Sequence.resolve
                        |> SeqMsg
                        |> JD.succeed

                "ArrowRight" ->
                    DownRightKey
                        |> Sequence.resolve
                        |> SeqMsg
                        |> JD.succeed

                _ ->
                    JD.fail "Ignore"
        )
        (JD.field "key" JD.string)



-- ## 処理の流れ
-- -- ### Loading


seqLoading : Loading -> Sequence.Msg SeqMsg -> Update Model Msg
seqLoading loading msg =
    Sequence.run
        seqLifter
        msg
        [ Sequence.on Start
            [ Update.modify <|
                \(Model model) ->
                    Model
                        { model
                            | page = LoadingView
                        }
            , let
                route =
                    Route.fromUrl loading.url
              in
              case route of
                Route.NotFound ->
                    Update.push <|
                        \(Model model) ->
                            Nav.pushUrl model.key <|
                                Url.absolute
                                    [ Constants.urlPrefix
                                    ]
                                    []

                Route.SlidePage_ slidePage ->
                    let
                        slide =
                            Slide.seek slidePage.title loading.initSlide
                    in
                    Update.push <|
                        \_ ->
                            Task.succeed slide
                                |> Task.perform (SeqMsg << Sequence.resolve << LoadRoute)
            ]
        , \v ->
            case v of
                UrlChanged url ->
                    avoidElmReviewWarning url <|
                        Sequence.succeed <|
                            jump
                                (ShowSlide_
                                    { slide = loading.initSlide
                                    }
                                )

                LoadRoute slide ->
                    Sequence.succeed <|
                        jump
                            (ShowSlide_
                                { slide = slide
                                }
                            )

                _ ->
                    Sequence.waitAgain Update.none
        ]


avoidElmReviewWarning : Url -> a -> a
avoidElmReviewWarning _ =
    identity



-- -- ### ShowSlide


seqShowSlide : ShowSlide -> Sequence.Msg SeqMsg -> Update Model Msg
seqShowSlide showSlide msg =
    Sequence.run
        seqLifter
        msg
        [ Sequence.on Start
            [ Update.modify <|
                \(Model model) ->
                    Model
                        { model
                            | page = SlideView showSlide.slide
                        }
            ]
        , \v ->
            case v of
                ClickProceed ->
                    let
                        newSlide =
                            Slide.proceed showSlide.slide
                    in
                    Sequence.succeed <|
                        Update.batch
                            [ Update.push <|
                                \(Model model) ->
                                    Nav.pushUrl model.key <|
                                        Url.absolute
                                            [ Constants.urlPrefix
                                            , newSlide
                                                |> Slide.current
                                                |> Page.title
                                            ]
                                            []
                            , Update.push <| \(Model { extraJS }) -> extraJS ()
                            , jump
                                (ShowSlide_
                                    { slide = newSlide
                                    }
                                )
                            ]

                DownRightKey ->
                    let
                        newSlide =
                            Slide.proceed showSlide.slide
                    in
                    Sequence.succeed <|
                        Update.batch
                            [ Update.push <|
                                \(Model model) ->
                                    Nav.pushUrl model.key <|
                                        Url.absolute
                                            [ Constants.urlPrefix
                                            , newSlide
                                                |> Slide.current
                                                |> Page.title
                                            ]
                                            []
                            , Update.push <| \(Model { extraJS }) -> extraJS ()
                            , jump
                                (ShowSlide_
                                    { slide = newSlide
                                    }
                                )
                            ]

                ClickBack ->
                    let
                        newSlide =
                            Slide.back showSlide.slide
                    in
                    Sequence.succeed <|
                        Update.batch
                            [ Update.push <|
                                \(Model model) ->
                                    Nav.pushUrl model.key <|
                                        Url.absolute
                                            [ Constants.urlPrefix
                                            , newSlide
                                                |> Slide.current
                                                |> Page.title
                                            ]
                                            []
                            , Update.push <| \(Model { extraJS }) -> extraJS ()
                            , jump
                                (ShowSlide_
                                    { slide = newSlide
                                    }
                                )
                            ]

                DownLeftKey ->
                    let
                        newSlide =
                            Slide.back showSlide.slide
                    in
                    Sequence.succeed <|
                        Update.batch
                            [ Update.push <|
                                \(Model model) ->
                                    Nav.pushUrl model.key <|
                                        Url.absolute
                                            [ Constants.urlPrefix
                                            , newSlide
                                                |> Slide.current
                                                |> Page.title
                                            ]
                                            []
                            , Update.push <| \(Model { extraJS }) -> extraJS ()
                            , jump
                                (ShowSlide_
                                    { slide = newSlide
                                    }
                                )
                            ]

                _ ->
                    Sequence.waitAgain Update.none
        ]



-- Reexport Slide


type alias Slide =
    Slide.Slide Msg
