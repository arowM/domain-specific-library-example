# Domain specific framework

## A Quick Example

```
module Main exposing (main)

import Dsf exposing (Model, Msg, Page, coverPage, titledPage)
import Dsf.View as View exposing (View)
import Json.Encode exposing (Value)



main : Program Value Model Msg
main =
    Dsf.run
        (coverPage [])
        [
        ]
```
