module Internal.Text exposing
    ( Text
    , run
    , concat
    , fromString
    , code
    , link
    , setImportance
    )

{-| Module for Text type.


# Core

@docs Text
@docs run
@docs concat


# Constructors

@docs fromString
@docs code
@docs link


# Operators

@docs setImportance

-}

import Html exposing (Attribute, Html)
import Html.Attributes as Attributes


{-| Represents text content.
-}
type Text msg
    = Text (Text_ msg)


type alias Text_ msg =
    { attributes : List (Attribute msg)
    , importance : Int
    , tagName : String
    , nodeType : NodeType msg
    }


type NodeType msg
    = StringNode String
    | InnerNode (List (Text msg))


{-| -}
run : Text msg -> Html msg
run (Text text) =
    case text.nodeType of
        StringNode str ->
            Html.node text.tagName
                (commonAttributes text)
                [ Html.text str
                ]

        InnerNode ls ->
            Html.node text.tagName
                (commonAttributes text)
                (List.map run ls)


commonAttributes : Text_ msg -> List (Attribute msg)
commonAttributes text =
    List.concat
        [ [ Attributes.attribute "data-importance" (String.fromInt text.importance)
          , Attributes.class "text"
          ]
        , text.attributes
        ]


{-| -}
concat : List (Text msg) -> Text msg
concat ls =
    Text
        { attributes = []
        , importance = 0
        , tagName = "span"
        , nodeType = InnerNode ls
        }


{-| Construct a `Text` from `String`.
-}
fromString : String -> Text msg
fromString str =
    Text
        { attributes = []
        , importance = 0
        , tagName = "span"
        , nodeType = StringNode <| String.trim str
        }


{-| -}
code : String -> Text msg
code str =
    Text
        { attributes =
            [ Attributes.class "code"
            , Attributes.class "language-elm"
            ]
        , importance = 0
        , tagName = "code"
        , nodeType = StringNode <| String.trimLeft str
        }


{-| Construct a `Text` instance with hyper link.
-}
link : { href : String, target : String } -> String -> Text msg
link { href, target } text =
    Text
        { attributes =
            [ Attributes.href href
            , Attributes.target target
            ]
        , importance = 0
        , tagName = "a"
        , nodeType = StringNode <| String.trim text
        }


{-| -}
setImportance : Int -> Text msg -> Text msg
setImportance n (Text text) =
    Text { text | importance = n }
