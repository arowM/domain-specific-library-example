# Domain specific framework

## A Quick Example

```
port module Main exposing (Flags, main)

import Dsf exposing (Model, Msg, Page, coverPage, titledPage)
import Dsf.Text as Text
import Dsf.View exposing (..)


main : Program Flags Model Msg
main =
    Dsf.run extraJS cover pages


cover : Flags -> Page
cover _ =
    coverPage
        [ column
            [ textBlock
                """
                2021年10月1日
                """
            , customTextBlock
                (Text.fromString
                    """
                    第一回関数型プログラミング（仮）の会
                    """
                    |> Text.setImportance -1
                )
            ]
            |> setMaxWidthFit
            |> alignRight
        , column
            [ customTextBlock
                (Text.fromString
                    """
                    発表タイトルがドーンッ！
                    """
                    |> Text.setImportance 2
                )
                |> toHeader1
                |> alignCenter
            ]
            |> setMaxHeightInfinite
        , customTextBlock
            (Text.link
                { href = "https://twitter.com/arowM_"
                , target = "_blank"
                }
                """
                ヤギのさくらちゃん
                """
            )
            |> alignRight
        ]


pages : List (Flags -> Page)
pages =
    [ \{ images } ->
        titledPage
            """
        最初のページ
        """
            [ image images.sample
                |> setMaxWidthInEm 10
            ]
    , \_ ->
        titledPage
            """
        次のページ
        """
            []
    , \_ ->
        titledPage
            """
        もっと次のページ
        """
            [ row
                [ tweet "https://twitter.com/arowM_/status/1363008744695627778"
                    |> alignHCenter
                , code """
module Main exposing (main)

import Dsf exposing (Model, Msg, Page, coverPage, titledPage)
import Dsf.View as View exposing (..)
import Dsf.Text as Text
import Dict exposing (Dict)
import Json.Encode exposing (Value)



main : Program Flags Model Msg
main =
    Dsf.run cover pages


type alias Flags =
    { images :
        { sample : String
        }
    }
"""
                    |> setMinWidthInEm 20
                ]
            ]
    ]



-- Config


type alias Flags =
    { images :
        { sample : String
        }
    }


port extraJS : () -> Cmd msg
```
