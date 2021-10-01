module Dsf.View exposing
    ( View
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
    )

{-| Module for an view parts to build a page.


# Core

@docs View


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

-}

import Dsf.Text exposing (Text)
import Internal
import Internal.View as View


{-| Represents one of the view elements that build up a particular page.

Each `View` instance has following properties.

  - minimum width
  - maximum width
  - minimum height
  - maximum height
  - vertical alignment
  - horizontal alignment

-}
type alias View =
    View.View Internal.Msg


{-| Construct a `View` instance that has text content.

  - minimum width: None
  - maximum width: Just large enough not to overflow the parent element
  - minimum height: Just small enough that the content does not overflow
  - maximum height: Same as minimum height
  - vertical alignment: top-aligned
  - horizontal alignment: left-aligned

-}
textBlock : String -> View
textBlock =
    View.textBlock


{-| Like `textBlock` but it can customize the text content with `Dsf.Text` module.
-}
customTextBlock : Text -> View
customTextBlock =
    View.customTextBlock


{-| Construct a `View` instance that shows image.
The first argument specifies the image file name.

  - minimum width: None
  - maximum width: Just large enough not to overflow the parent element
  - minimum height: Just small enough that the content does not overflow
  - maximum height: Same as minimum height
  - vertical alignment: top-aligned
  - horizontal alignment: left-aligned

-}
image : String -> View
image =
    View.image


{-| Construct a `View` instance that contains tweet.
The first argument specifies the tweet URL.

  - minimum width: None
  - maximum width: Just large enough not to overflow the parent element
  - minimum height: Just small enough that the content does not overflow
  - maximum height: Same as minimum height
  - vertical alignment: top-aligned
  - horizontal alignment: left-aligned

-}
tweet : String -> View
tweet =
    View.tweet


{-| Construct a `View` instance that shows code.

  - minimum width: None
  - maximum width: Just large enough not to overflow the parent element
  - minimum height: Just small enough that the content does not overflow
  - maximum height: Same as minimum height
  - vertical alignment: top-aligned
  - horizontal alignment: left-aligned

-}
code : String -> View
code =
    View.code


{-| Construct a `View` instance that horizontally alings the child `Views`.
Wraps child elements when they are overflowing.

  - minimum width: The largest size of the minimum widths of all child elements
  - maximum width: The sum of the maximum widths of all child elements
  - minimum height: The largest size of the minimum heights of all child elements
  - maximum height: The largest size of the maximum heights of all child elements
  - vertical alignment: top-aligned
  - horizontal alignment: left-aligned

-}
row : List View -> View
row =
    View.row


{-| Construct a `View` instance that vertically alings the child `Views`.

  - minimum width: The largest size of the minimum widths of all child elements
  - maximum width: The largest size of the maximum widths of all child elements
  - minimum height: The sum of the minimum heights of all child elements
  - maximum height: The sum of the maximum heights of all child elements
  - vertical alignment: top-aligned
  - horizontal alignment: left-aligned

-}
column : List View -> View
column =
    View.column


{-| Like column, but it shows children as unordered list items.
-}
unorderedList : List View -> View
unorderedList =
    View.unorderedList


{-| Like column, but it shows children as ordered list items.
The first argument specifies the numbering type:

  - "a" for lowercase letters
  - "A" for uppercase letters
  - "i" for lowercase Roman numerals
  - "I" for uppercase Roman numerals
  - "1" for numbers

cf., [MDN document](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/ol#attr-type)

-}
orderedList : String -> List View -> View
orderedList =
    View.orderedList


{-| Set minimum width in [em unit](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Values_and_units#relative_length_units).
-}
setMinWidthInEm : Float -> View -> View
setMinWidthInEm =
    View.setMinWidthInEm


{-| Set minimum width not to wrap inner contents.
-}
setMinWidthNowrap : View -> View
setMinWidthNowrap =
    View.setMinWidthNowrap


{-| Set maximum width in [em unit](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Values_and_units#relative_length_units).
-}
setMaxWidthInEm : Float -> View -> View
setMaxWidthInEm =
    View.setMaxWidthInEm


{-| Set maximum width to fit its contents.
-}
setMaxWidthFit : View -> View
setMaxWidthFit =
    View.setMaxWidthFit


{-| Set minimum height in [em unit](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Values_and_units#relative_length_units).
-}
setMinHeightInEm : Float -> View -> View
setMinHeightInEm =
    View.setMinHeightInEm


{-| Set maximum height in [em unit](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Values_and_units#relative_length_units).
-}
setMaxHeightInEm : Float -> View -> View
setMaxHeightInEm =
    View.setMaxHeightInEm


{-| Set maximum height infinite.
-}
setMaxHeightInfinite : View -> View
setMaxHeightInfinite =
    View.setMaxHeightInfinite


{-| Move a `View` towards the right edge.
-}
alignRight : View -> View
alignRight =
    View.alignRight


{-| Move a `View` towards the bottom edge.
-}
alignBottom : View -> View
alignBottom =
    View.alignBottom


{-| Move a `View` towards the center vertically.
-}
alignVCenter : View -> View
alignVCenter =
    View.alignVCenter


{-| Move a `View` towards the center horizontally.
-}
alignHCenter : View -> View
alignHCenter =
    View.alignHCenter


{-| Alias for `alignHCenter << alignVCenter`.
-}
alignCenter : View -> View
alignCenter =
    View.alignCenter


{-| Gives a View the semantics of the "Heading level 1".
-}
toHeader1 : View -> View
toHeader1 =
    View.toHeader1


{-| Gives a View the semantics of the "Heading level 2".
-}
toHeader2 : View -> View
toHeader2 =
    View.toHeader2


{-| Gives a View the semantics of the "Heading level 3".
-}
toHeader3 : View -> View
toHeader3 =
    View.toHeader3
