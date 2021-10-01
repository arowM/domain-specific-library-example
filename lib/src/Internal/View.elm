module Internal.View exposing
    ( View
    , run
    , textBlock
    , customTextBlock
    , image
    , tweet
    , code
    , column
    , row
    , unorderedList
    , orderedList
    , setMinWidthInEm
    , setMinWidthNowrap
    , setMaxWidthInEm
    , setMaxWidthFit
    , setMinHeightInEm
    , setMaxHeightInEm
    , setMaxHeightInfinite
    , alignRight
    , alignBottom
    , alignCenter
    , alignVCenter
    , alignHCenter
    , toHeader1
    , toHeader2
    , toHeader3
    , pushAttributes
    )

{-| Module for an view parts to build a page.


# Core

@docs View
@docs run


# Constructors

@docs textBlock
@docs customTextBlock
@docs image
@docs tweet
@docs code
@docs column
@docs row
@docs unorderedList
@docs orderedList


# Operators


## Sizing / Alignments

@docs setMinWidthInEm
@docs setMinWidthNowrap
@docs setMaxWidthInEm
@docs setMaxWidthFit
@docs setMinHeightInEm
@docs setMaxHeightInEm
@docs setMaxHeightInfinite
@docs alignRight
@docs alignBottom
@docs alignCenter
@docs alignVCenter
@docs alignHCenter


## Semantics

@docs toHeader1
@docs toHeader2
@docs toHeader3


## Low level

@docs pushAttributes

-}

import Html exposing (Attribute, Html)
import Html.Attributes as Attributes exposing (class)
import Internal.Text as Text exposing (Text)


{-| Represents one of the view elements that build up a particular page.

Each `View` instance has following properties.

  - minimum width
  - maximum width
  - minimum height
  - maximum height
  - vertical alignment
  - horizontal alignment

-}
type View msg
    = View (View_ msg)


type alias View_ msg =
    { actions : List (List (Attribute msg))
    , attributes : List (Attribute msg)
    , minWidth : MinSize
    , maxWidth : MaxSize
    , minHeight : MinSize
    , maxHeight : MaxSize
    , verticalAlign : VerticalAlign
    , horizontalAlign : HorizontalAlign
    , tagName : String
    , nodeType : NodeType msg
    }


type MinSize
    = MinSizeInEm Float
    | MinSizeContain
    | MinSizeNone


type MaxSize
    = MaxSizeInEm Float
    | MaxSizeFit
    | MaxSizeNone


type VerticalAlign
    = Top
    | Bottom
    | VCenter


type HorizontalAlign
    = Left
    | Right
    | HCenter


type NodeType msg
    = TextNode (Text msg)
    | RowNode (List (View msg))
    | ColumnNode (List (View msg))


{-| Convert to `Html`.
-}
run : View msg -> Html msg
run (View view) =
    case view.nodeType of
        TextNode text ->
            Html.node view.tagName
                (commonAttributes view)
                [ Text.run text
                ]

        RowNode vs ->
            Html.node view.tagName
                (commonAttributes view)
                (List.map run vs)

        ColumnNode vs ->
            Html.node view.tagName
                (commonAttributes view)
                (List.map run vs)


commonAttributes : View_ msg -> List (Attribute msg)
commonAttributes view =
    view.attributes
        ++ List.concat
            [ case view.minWidth of
                MinSizeInEm a ->
                    [ Attributes.style "min-width" (String.fromFloat a ++ "em")
                    , class "minWidth-em"
                    ]

                MinSizeContain ->
                    [ class "minWidth-contain"
                    ]

                MinSizeNone ->
                    [ class "minWidth-none"
                    ]
            , case view.maxWidth of
                MaxSizeInEm a ->
                    [ Attributes.style "max-width" (String.fromFloat a ++ "em")
                    , class "maxWidth-em"
                    ]

                MaxSizeFit ->
                    [ class "maxWidth-fit"
                    ]

                MaxSizeNone ->
                    [ class "maxWidth-none"
                    ]
            , case view.minHeight of
                MinSizeInEm a ->
                    [ Attributes.style "min-height" (String.fromFloat a ++ "em")
                    , class "minHeight-em"
                    ]

                MinSizeContain ->
                    [ class "minHeight-contain"
                    ]

                MinSizeNone ->
                    [ class "minHeight-none"
                    ]
            , case view.maxHeight of
                MaxSizeInEm a ->
                    [ Attributes.style "max-height" (String.fromFloat a ++ "em")
                    , class "maxHeight-em"
                    ]

                MaxSizeFit ->
                    [ class "maxHeight-fit"
                    ]

                MaxSizeNone ->
                    [ class "maxHeight-none"
                    ]
            , case view.verticalAlign of
                Top ->
                    [ class "verticalAlign-top"
                    ]

                Bottom ->
                    [ class "verticalAlign-bottom"
                    ]

                VCenter ->
                    [ class "verticalAlign-center"
                    ]
            , case view.horizontalAlign of
                Left ->
                    [ class "horizontalAlign-left"
                    ]

                Right ->
                    [ class "horizontalAlign-right"
                    ]

                HCenter ->
                    [ class "horizontalAlign-center"
                    ]
            ]


{-| Construct a `View` instance that has text content.

  - minimum width: None
  - maximum width: Just small enough that the content does not overflow
  - minimum height: Just small enough that the content does not overflow
  - maximum height: Same as minimum height
  - vertical alignment: top-aligned
  - horizontal alignment: left-aligned

-}
textBlock : String -> View msg
textBlock str =
    Text.fromString str
        |> customTextBlock


{-| Like `textBlock` but it can customize the text content with `Internal.Text` module.
-}
customTextBlock : Text msg -> View msg
customTextBlock text =
    View
        { actions = []
        , attributes =
            [ class "textBlock"
            ]
        , minWidth = MinSizeNone
        , maxWidth = MaxSizeFit
        , minHeight = MinSizeContain
        , maxHeight = MaxSizeFit
        , verticalAlign = Top
        , horizontalAlign = Left
        , tagName = "div"
        , nodeType = TextNode text
        }


{-| Construct a `View` instance that shows image.
The first argument specifies the image file name.

  - minimum width: None
  - maximum width: Just large enough not to overflow the parent element
  - minimum height: Just small enough that the content does not overflow
  - maximum height: Same as minimum height
  - vertical alignment: top-aligned
  - horizontal alignment: left-aligned

-}
image : String -> View msg
image name =
    View
        { actions = []
        , attributes =
            [ class "image"
            , Attributes.src name
            ]
        , minWidth = MinSizeNone
        , maxWidth = MaxSizeNone
        , minHeight = MinSizeContain
        , maxHeight = MaxSizeFit
        , verticalAlign = Top
        , horizontalAlign = Left
        , tagName = "img"
        , nodeType = RowNode []
        }


{-| Construct a `View` instance that contains tweet.
The first argument specifies the tweet URL.

  - minimum width: None
  - maximum width: Just large enough not to overflow the parent element
  - minimum height: Just small enough that the content does not overflow
  - maximum height: Same as minimum height
  - vertical alignment: top-aligned
  - horizontal alignment: left-aligned

-}
tweet : String -> View msg
tweet url =
    Text.link
        { href = url
        , target = ""
        }
        "Loading..."
        |> customTextBlock
        |> setTagName "blockquote"
        |> pushAttributes
            [ class "twitter-tweet"
            ]


{-| Construct a `View` instance that shows code.

  - minimum width: None
  - maximum width: Just large enough not to overflow the parent element
  - minimum height: Just small enough that the content does not overflow
  - maximum height: Same as minimum height
  - vertical alignment: top-aligned
  - horizontal alignment: left-aligned

-}
code : String -> View msg
code c =
    customTextBlock (Text.code c)
        |> setTagName "pre"
        |> pushAttributes
            [ class "pre" ]


{-| Construct a `View` instance that horizontally alings the child `Views`.
Wraps child elements when they are overflowing.

  - minimum width: The largest size of the minimum widths of all child elements
  - maximum width: The sum of the maximum widths of all child elements
  - minimum height: The largest size of the minimum heights of all child elements
  - maximum height: The largest size of the maximum heights of all child elements
  - vertical alignment: top-aligned
  - horizontal alignment: left-aligned

-}
row : List (View msg) -> View msg
row children =
    View
        { actions = []
        , attributes =
            [ class "row"
            ]
        , minWidth = MinSizeNone
        , maxWidth = MaxSizeFit
        , minHeight = MinSizeContain
        , maxHeight = MaxSizeNone
        , verticalAlign = Top
        , horizontalAlign = Left
        , tagName = "div"
        , nodeType =
            List.map (pushAttributes [ class "rowItem" ]) children
                |> RowNode
        }


{-| Construct a `View` instance that vertically alings the child `Views`.

  - minimum width: The largest size of the minimum widths of all child elements
  - maximum width: The largest size of the maximum widths of all child elements
  - minimum height: The sum of the minimum heights of all child elements
  - maximum height: The sum of the maximum heights of all child elements
  - vertical alignment: top-aligned
  - horizontal alignment: left-aligned

-}
column : List (View msg) -> View msg
column children =
    View
        { actions = []
        , attributes =
            [ class "column"
            ]
        , minWidth = MinSizeContain
        , maxWidth = MaxSizeNone
        , minHeight = MinSizeContain
        , maxHeight = MaxSizeFit
        , verticalAlign = Top
        , horizontalAlign = Left
        , tagName = "div"
        , nodeType =
            List.map (pushAttributes [ class "columnItem" ]) children
                |> ColumnNode
        }


{-| -}
pushAttributes : List (Attribute msg) -> View msg -> View msg
pushAttributes ls (View view) =
    View
        { view | attributes = view.attributes ++ ls }


{-| Like column, but it shows children as unordered list items.
-}
unorderedList : List (View msg) -> View msg
unorderedList children =
    column children
        |> modifyChildren (setTagName "li")
        |> pushAttributes [ class "column-unorderedList" ]
        |> setTagName "ul"


{-| Like column, but it shows children as ordered list items.
The first argument specifies the numbering type:

  - "a" for lowercase letters
  - "A" for uppercase letters
  - "i" for lowercase Roman numerals
  - "I" for uppercase Roman numerals
  - "1" for numbers

cf., [MDN document](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/ol#attr-type)

-}
orderedList : String -> List (View msg) -> View msg
orderedList type_ children =
    column children
        |> modifyChildren (setTagName "li")
        |> modifyChildren (pushAttributes [ Attributes.type_ type_ ])
        |> pushAttributes [ class "column-orderedList" ]
        |> setTagName "ol"


modifyChildren : (View msg -> View msg) -> View msg -> View msg
modifyChildren f (View view) =
    View
        { view
            | nodeType =
                case view.nodeType of
                    TextNode _ ->
                        view.nodeType

                    RowNode children ->
                        List.map f children
                            |> RowNode

                    ColumnNode children ->
                        List.map f children
                            |> ColumnNode
        }


setTagName : String -> View msg -> View msg
setTagName name (View view) =
    View
        { view | tagName = name }



-- Sizing / Alignments


{-| Set minimum width in [em unit](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Values_and_units#relative_length_units).
-}
setMinWidthInEm : Float -> View msg -> View msg
setMinWidthInEm a (View view) =
    View { view | minWidth = MinSizeInEm a }


{-| Set minimum width not to wrap inner contents.
-}
setMinWidthNowrap : View msg -> View msg
setMinWidthNowrap (View view) =
    View { view | minWidth = MinSizeContain }


{-| Set maximum width in [em unit](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Values_and_units#relative_length_units).
-}
setMaxWidthInEm : Float -> View msg -> View msg
setMaxWidthInEm a (View view) =
    View { view | maxWidth = MaxSizeInEm a }


{-| Set maximum width to fit its contents.
-}
setMaxWidthFit : View msg -> View msg
setMaxWidthFit (View view) =
    View { view | maxWidth = MaxSizeFit }


{-| Set minimum height in [em unit](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Values_and_units#relative_length_units).
-}
setMinHeightInEm : Float -> View msg -> View msg
setMinHeightInEm a (View view) =
    View { view | minHeight = MinSizeInEm a }


{-| Set maximum height in [em unit](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Values_and_units#relative_length_units).
-}
setMaxHeightInEm : Float -> View msg -> View msg
setMaxHeightInEm a (View view) =
    View { view | maxHeight = MaxSizeInEm a }


{-| Set maximum height infinite.
-}
setMaxHeightInfinite : View msg -> View msg
setMaxHeightInfinite (View view) =
    View { view | maxHeight = MaxSizeNone }


{-| Move a `View` towards the right edge.
-}
alignRight : View msg -> View msg
alignRight (View view) =
    View { view | horizontalAlign = Right }


{-| Move a `View` towards the bottom edge.
-}
alignBottom : View msg -> View msg
alignBottom (View view) =
    View { view | verticalAlign = Bottom }


{-| Move a `View` towards the center vertically.
-}
alignVCenter : View msg -> View msg
alignVCenter (View view) =
    View { view | verticalAlign = VCenter }


{-| Move a `View` towards the center horizontally.
-}
alignHCenter : View msg -> View msg
alignHCenter (View view) =
    View { view | horizontalAlign = HCenter }


{-| Alias for `alignHCenter << alignVCenter`.
-}
alignCenter : View msg -> View msg
alignCenter =
    alignVCenter << alignHCenter


{-| Gives a View the semantics of the "Heading level 1".
-}
toHeader1 : View msg -> View msg
toHeader1 =
    pushAttributes
        [ class "h1"
        ]
        >> setTagName "h1"


{-| Gives a View the semantics of the "Heading level 2".
-}
toHeader2 : View msg -> View msg
toHeader2 =
    pushAttributes
        [ class "h2"
        ]
        >> setTagName "h2"


{-| Gives a View the semantics of the "Heading level 3".
-}
toHeader3 : View msg -> View msg
toHeader3 =
    pushAttributes
        [ class "h3"
        ]
        >> setTagName "h3"
