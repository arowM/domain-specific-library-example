module Internal.Slide exposing
    ( Slide
    , fromPages
    , current
    , next
    , prev
    , seek
    , proceed
    , back
    )

{-| Handle state for slide pages.


# Core

@docs Slide
@docs fromPages


# Getters

@docs current
@docs next
@docs prev


# Operators

@docs seek
@docs proceed
@docs back

-}

import Internal.Page as Page exposing (Page)
import List.Extra as List
import Url


{-| Current state of slide pages.

    import Internal.Page as Page exposing (Page)

    sample : Slide msg
    sample =
        fromPages samplePage0
            [ samplePage1
            , samplePage2
            ]

    samplePage0 : Page msg
    samplePage0 =
        Page.cover []

    samplePage1 : Page msg
    samplePage1 =
        Page.titled "samplePage1" []

    samplePage2 : Page msg
    samplePage2 =
        Page.titled "samplePage2" []

    sample
        |> current
    --> samplePage0

    sample
        |> next
    --> Just samplePage1

    sample
        |> prev
    --> Nothing

    sample
        |> seek "samplePage2"
        |> current
    --> samplePage2

    sample
        |> seek "samplePage2"
        |> next
    --> Nothing

    sample
        |> seek "unknown page"
        |> current
    --> samplePage0

    sample
        |> back
        |> current
    --> samplePage0

    sample
        |> proceed
        |> current
    --> samplePage1

    sample
        |> proceed
        |> proceed
        |> current
    --> samplePage2

    sample
        |> proceed
        |> proceed
        |> proceed
        |> current
    --> samplePage2

-}
type Slide msg
    = Slide (Slide_ msg)


type alias Slide_ msg =
    { prev : List (Page msg)
    , current : Page msg
    , next : List (Page msg)
    }


{-| A constructor for `Slide`.
The first argument takes the first page, and second argument takes the proceeding pages.
It just shows the first page.
-}
fromPages : Page msg -> List (Page msg) -> Slide msg
fromPages p ps =
    Slide
        { prev = []
        , current = p
        , next = ps
        }



-- Getters


{-| Take current slide page.
-}
current : Slide msg -> Page msg
current (Slide slide) =
    slide.current


{-| Take next slide page.
If no next page exists, it returns `Nothing`.
-}
next : Slide msg -> Maybe (Page msg)
next (Slide slide) =
    List.head slide.next


{-| Take previous slide page.
If no previous page exists, it returns `Nothing`.
-}
prev : Slide msg -> Maybe (Page msg)
prev (Slide slide) =
    List.head slide.prev



-- Operators


{-| Seek a slide page by the given title string.
If no such title page exists, it returns the given `Slide` instance as it is.
-}
seek : String -> Slide msg -> Slide msg
seek str (Slide slide) =
    let
        ls =
            List.reverse slide.prev ++ [ slide.current ] ++ slide.next
    in
    case List.splitWhen (\page -> Url.percentEncode (Page.title page) == str) ls of
        Nothing ->
            Slide slide

        Just ( _, [] ) ->
            Slide slide

        Just ( xs, y :: ys ) ->
            Slide
                { prev = List.reverse xs
                , current = y
                , next = ys
                }


{-| Proceed to the next slide page.
If no next page exists, it returns the given `Slide` itself.
-}
proceed : Slide msg -> Slide msg
proceed (Slide slide) =
    case slide.next of
        [] ->
            Slide slide

        new :: left ->
            Slide
                { prev = slide.current :: slide.prev
                , current = new
                , next = left
                }


{-| Back to the previous slide page.
If no previous page exists, it returns the given `Slide` itself.
-}
back : Slide msg -> Slide msg
back (Slide slide) =
    case slide.prev of
        [] ->
            Slide slide

        new :: left ->
            Slide
                { prev = left
                , current = new
                , next = slide.current :: slide.next
                }
