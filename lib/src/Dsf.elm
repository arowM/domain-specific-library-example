module Dsf exposing
    ( run
    , Model
    , Msg
    , Page
    , coverPage
    , titledPage
    )

{-| Domain specific framework for our application.


# Core

@docs run
@docs Model
@docs Msg


# Page

@docs Page
@docs coverPage
@docs titledPage

-}

import Dsf.View exposing (View)
import Internal
import Internal.Page as Page


{-| Generate a slide application from a list of `Page`.
-}
run : (() -> Cmd Msg) -> (flags -> Page) -> List (flags -> Page) -> Program flags Model Msg
run =
    Internal.run


{-| Represents a specific page in a slide application.
-}
type alias Page =
    Page.Page Internal.Msg


{-| -}
type alias Model =
    Internal.Model


{-| -}
type alias Msg =
    Internal.Msg


{-| Construct a cover page.
-}
coverPage : List View -> Page
coverPage =
    Page.cover


{-| Construct a page with title header.
-}
titledPage : String -> List View -> Page
titledPage =
    Page.titled
