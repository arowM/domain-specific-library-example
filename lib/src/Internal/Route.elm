module Internal.Route exposing
    ( Route(..)
    , SlidePage
    , fromUrl
    )

{-| Handle routes.

@docs Route
@docs SlidePage
@docs fromUrl

-}

import Internal.Constants as Constants
import Url exposing (Url)
import Url.Parser as Url exposing ((</>), Parser)


{-| -}
type Route
    = NotFound
    | SlidePage_ SlidePage


{-| -}
type alias SlidePage =
    { title : String
    }


{-| -}
fromUrl : Url -> Route
fromUrl url =
    Url.parse route url
        |> Maybe.withDefault NotFound


route : Parser (Route -> a) a
route =
    Url.oneOf
        [ Url.map (\t -> SlidePage_ { title = t }) (Url.s Constants.urlPrefix </> Url.string)
        , Url.map (SlidePage_ { title = "" }) (Url.s Constants.urlPrefix)
        ]
