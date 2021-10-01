module Dsf.Text exposing
    ( Text
    , concat
    , fromString
    , link
    , setImportance
    )

{-| Module for Text type.


# Core

@docs Text
@docs concat


# Constructors

@docs fromString
@docs link


# Operators

@docs setImportance

-}

import Internal
import Internal.Text as Text


{-| Represents text content.
-}
type alias Text =
    Text.Text Internal.Msg


{-| -}
concat : List Text -> Text
concat =
    Text.concat


{-| Construct a `Text` from `String`.
-}
fromString : String -> Text
fromString =
    Text.fromString


{-| Construct a `Text` instance with hyper link.
-}
link : { href : String, target : String } -> String -> Text
link =
    Text.link


{-| -}
setImportance : Int -> Text -> Text
setImportance =
    Text.setImportance
