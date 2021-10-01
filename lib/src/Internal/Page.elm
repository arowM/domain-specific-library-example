module Internal.Page exposing
    ( Page
    , title
    , body
    , cover
    , titled
    , view
    )

{-| Module for a slide page.

-- Core

@docs Page

-- Getters

@docs title
@docs body

-- Constructors

@docs cover
@docs titled

-- View

@docs view

-}

import Html exposing (Html)
import Html.Attributes exposing (class)
import Internal.View as View exposing (View)



-- Core


{-| Represent a slide page.
-}
type Page msg
    = TitledPage String (List (View msg))
    | CoverPage (List (View msg))



-- Getters


{-| Take title string.
If the `Page` is cover page, it returns `""`.

    cover []
        |> title
    --> ""

    titled "titled" []
        |> title
    --> "titled"

-}
title : Page msg -> String
title page =
    case page of
        TitledPage t _ ->
            t

        CoverPage _ ->
            ""


{-| Take body from `Page`.
-}
body : Page msg -> List (View msg)
body page =
    case page of
        TitledPage _ vs ->
            vs

        CoverPage vs ->
            vs



-- Constructors


{-| Construct a cover page.
-}
cover : List (View msg) -> Page msg
cover =
    CoverPage


{-| Construct a page with title header.
-}
titled : String -> List (View msg) -> Page msg
titled str =
    TitledPage (String.trim str)



-- View


{-| -}
view : Page msg -> Html msg
view page =
    case page of
        TitledPage t vs ->
            renderTitledPage t vs

        CoverPage vs ->
            renderCoverPage vs


renderTitledPage : String -> List (View msg) -> Html msg
renderTitledPage t vs =
    View.column
        [ View.column
            [ View.textBlock t
                |> View.toHeader2
                |> View.alignCenter
            ]
            |> View.pushAttributes
                [ class "page_title"
                ]
        , View.column vs
            |> View.setMaxHeightInfinite
            |> View.pushAttributes
                [ class "page_body"
                ]
        ]
        |> View.pushAttributes
            [ class "page"
            ]
        |> View.run


renderCoverPage : List (View msg) -> Html msg
renderCoverPage vs =
    View.column
        [ View.column vs
            |> View.pushAttributes
                [ class "page_body"
                ]
        ]
        |> View.pushAttributes
            [ class "page"
            ]
        |> View.run
