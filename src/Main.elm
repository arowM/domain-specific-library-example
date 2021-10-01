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
            [ column
                [ customTextBlock
                    (Text.concat
                        [ Text.fromString
                            """
                            Domain specific library/framework
                            """
                            |> Text.setImportance 2
                        , Text.fromString
                            """
                            を用いた
                            """
                            |> Text.setImportance 1
                        ]
                    )
                    |> alignHCenter
                , customTextBlock
                    (Text.concat
                        [ Text.fromString
                            """
                            実践的
                            """
                            |> Text.setImportance 2
                        , Text.fromString
                            """
                            開発手法
                            """
                            |> Text.setImportance 1
                        ]
                    )
                    |> alignHCenter
                ]
                |> alignVCenter
            ]
            |> toHeader1
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
自己紹介
"""
            [ row
                [ image images.sample
                    |> setMaxWidthInEm 20
                , customTextBlock
                    (Text.concat
                        [ Text.fromString
                            """
                            さくらちゃん
                            """
                            |> Text.setImportance 1
                        , Text.fromString
                            """
                            は
                            """
                        , Text.fromString
                            """
                            さくらちゃん
                            """
                            |> Text.setImportance 1
                        , Text.fromString
                            """
                            やぎぃ
                            """
                        ]
                    )
                ]
            , unorderedList
                [ column
                    [ customTextBlock
                        (Text.link
                            { href = "https://qiita.com/arowM/items/9eddd10d531154cbc065"
                            , target = "_blank"
                            }
                            """
                            HaskellとElmの会社をつぶしてUXハッカーになった話
                            """
                        )
                    , textBlock
                        """
                        「関数型」との付き合い方で死ぬほど苦労しました。
                        """
                    , customTextBlock
                        ( Text.concat
                            [ Text.fromString
                                """
                                先人達による基礎研究の結果をお借りして
                                """
                            , Text.fromString
                                """
                                実践的
                                """
                                    |> Text.setImportance 1
                            , Text.fromString
                                """
                                な「関数型」の活用をしています。
                                """
                            ]
                        )
                    ]
                , textBlock
                    """
                    「パワハラ圧迫面接CTO」がオプトから消えて良かったやぎぃ🐐
                    """
                , customTextBlock <|
                    Text.concat
                        [ Text.link
                            { href = "https://twitter.com/arowM_"
                            , target = "_blank"
                            }
                            """
                            ツイッター
                            """
                        , Text.fromString
                            """
                            でかわいいヤギさんをリツイートするのが仕事
                            """
                        ]
                , textBlock
                        """
                        「プログラミングElm」もよろしくね！
                        """
                ]
            , tweet "https://twitter.com/arowM_/status/1363008744695627778"
            ]
    , \_ ->
        titledPage
            """
        本発表における「関数型」
        """
            [ tweet "https://twitter.com/arowM_/status/1384397125757272065"
            , tweet "https://twitter.com/arowM_/status/906175017854967808"
            , tweet "https://twitter.com/arowM_/status/1435817233410707465"
            , unorderedList
                [ column
                    [ textBlock
                        """
                        「関数型プログラミング」: 制約の多い「オブジェクト指向プログラミング」
                        """
                    , column
                        [ Text.fromString
                            """
                            制約を多くすることで、以下のメリットが得られる
                            """
                                |> Text.setImportance -1
                                |> customTextBlock
                        , unorderedList
                            [ Text.fromString
                                """
                                強力な静的解析が可能とする
                                """
                                    |> Text.setImportance -1
                                    |> customTextBlock
                            , Text.fromString
                                """
                                ドキュメントの正しさが担保される（型注釈・doctest）
                                """
                                    |> Text.setImportance -1
                                    |> customTextBlock
                            ]
                        ]
                    , Text.fromString
                        """
                        制約の例: イミュータブル、強い静的型
                        """
                            |> Text.setImportance -1
                            |> customTextBlock
                    ]
                , textBlock
                    """
                    「関数型プログラミング言語」: HaskellやElm程度の強力な静的解析を可能とする言語
                    """
                ]
            , tweet "https://twitter.com/arowM_/status/1442788528346132482"
            ]
    , \{ images } ->
        titledPage
            """
        ゆるふわ「オブジェクト指向」
        """
            [ unorderedList
                [ textBlock
                    """
                    データ型を核としたモジュール: オブジェクト
                    """
                , textBlock
                    """
                    核となるデータ型をもつ値: オブジェクトインスタンス
                    """
                , textBlock
                    """
                    「オブジェクトインスタンス」を返す関数: コンストラクター
                    """
                , textBlock
                    """
                    「オブジェクトインスタンス」を受け取る関数: インスタンスメソッド
                    """
                , textBlock
                    """
                    「オブジェクトインスタンス」を受け取って「オブジェクトインスタンス」を返す関数: Setter
                    """
                , textBlock
                    """
                    「オブジェクトインスタンス」を受け取って内部状態をあらわす値を返す関数: Getter
                    """
                , textBlock
                    """
                    「オブジェクトインスタンス」を受け取って「オブジェクトインスタンス」を返す関数: インスタンスメソッド
                    """
                , textBlock
                    """
                    Opaque Typeによる カプセル化
                    """
                ]
            , column
                [ textBlock
                    """
                    このスライドアプリも「オブジェクト指向」で開発しています。
                    """
                , Text.link
                    { href = "https://github.com/arowM/domain-specific-library-example"
                    , target = "_blank"
                    }
                    """
                    この資料のソースはGitHub上で公開されています。
                    """
                        |> customTextBlock
                        |> alignRight
                ]
            , image images.doc
            ]
    , \{ images } ->
        titledPage
            """
        （閑話）汎用性のジレンマ
        """
            [ row
                [ column
                    [ Text.fromString
                        """
                        エクセル万能！
                        """
                            |> Text.setImportance 2
                            |> customTextBlock
                            |> alignHCenter
                    , textBlock
                        """
                        人事・労務・顧客管理・売上管理・在庫管理、エクセルはあらゆることに使える。
                        """
                    , column
                        [ textBlock
                            """
                            ...じゃあ、専用のクラウドサービスは何のためにあるの？
                            """
                                |> alignBottom
                        ]
                            |> setMaxHeightInfinite
                    ]
                        |> setMaxHeightInfinite
                , image images.general
                    |> setMaxWidthInEm 20
                    |> alignRight
                ]
                    |> setMaxWidthFit
            ]
    , \_ ->
        titledPage
            """
        汎用性のジレンマ（その２）
        """
            [ column
                [ Text.fromString
                    """
                    汎用性をあげるとユーザービリティが下がる
                    """
                        |> Text.setImportance 2
                        |> customTextBlock
                        |> setMaxWidthFit
                        |> alignCenter
                ]
                    |> setMaxHeightInfinite
            , column
                    [ textBlock
                        """
                        ライブラリーやフレームワークも同様
                        """
                    , textBlock
                        """
                        汎用性を高くしたいが、そうすると特定用途には使いにくくなる
                        """
                    ]
                        |> setMaxWidthFit
                        |> alignHCenter
            ]
    , \_ ->
        titledPage
            """
        Domain Specific Framework / Library
        """
            [ Text.fromString
                """
                Domain（作っているアプリ）専用のフレームワーク/ライブラリーを作っちゃえばいいじゃん！
                """
                    |> Text.setImportance 1
                    |> customTextBlock
                    |> setMaxWidthFit
                    |> alignCenter
            , textBlock
                """
                用いるツール/技術の例:
                """
            , unorderedList
                [ column
                    [ textBlock
                        """
                        ドキュメント生成機能
                        """
                    , textBlock
                        """
                        Haddockやelm-doc-previewなど
                        """
                    ]
                , column
                    [ textBlock
                        """
                        ドキュメント上のテストツール
                        """
                    , textBlock
                        """
                        doctestやelm-verify-examplesなど
                        """
                    ]
                , column
                    [ textBlock
                        """
                        内部実装の隠蔽
                        """
                    , textBlock
                        """
                        Opaque type など
                        """
                    ]
                ]

            ]
    , \_ ->
        titledPage
            """
        （Before）Domain Specific Framework/Library を使わない場合
        """
            [ textBlock
                """
                従来のElmアプリコード
                """
                    |> toHeader3
            , textBlock
                """
                Elmはシンプルではあるが、さすがに初見ではむずかしい
                """
            , code originalCode
            ]
    , \_ ->
        titledPage
            """
        （After）Domain Specific Framework/Library を使った場合
        """
            [ textBlock
                """
                Domain Specific Framework を使ったアプリコード
                """
                    |> toHeader3
            , Text.fromString
                """
                このスライドアプリのソースコード
                """
                    |> Text.setImportance -1
                    |> customTextBlock
            , textBlock
                """
                とりあえずメソッドチェーン的にパイプをつないでビューを組み立てたら完成する
                """
            , code dsfCode
            ]
    , \_ ->
        titledPage
            """
        Domain Specific Framework / Library を使うことのメリット
        """
            [ unorderedList
                [ column
                    [ textBlock
                        """
                        技術レベルに合わせたホモジニアスな並行開発が可能になる
                        """
                    , textBlock
                        """
                        このアプリの Domain Specific Framework があれば、CSSの知識はほとんどいらない
                        """
                    , textBlock
                        """
                        Elmをほとんど知らない人でも、最低限の基礎文法を押さえればアプリ開発ができてしまう
                        """
                    , textBlock
                        """
                        商用アプリでも、運営側の都合にあわせた高頻度な変更を、経験が浅いメンバーに任せられる
                        """
                    ]
                , column
                    [ textBlock
                        """
                        バグが飛躍的に減る
                        """
                    , textBlock
                        """
                        人間は大域的な思考と局所的な思考を同時に持つことが困難
                        """
                    , textBlock
                        """
                        めちゃくちゃがんばって考えていた問題が、休憩したら「そもそももっと楽な方法があったじゃん」はよくあること
                        """
                    , textBlock
                        """
                        UXを考えながら配列の要素について考えるなんて、できるわけない
                        """
                    , textBlock
                        """
                        Domain Specific Framework/Library によって「困難を分割」できる
                        """
                    ]
                , column
                    [ textBlock
                        """
                        テストを書きやすい
                        """
                    , textBlock
                        """
                        ライブラリー部分とアプリ部分が明確に分離しているのでテストを書きやすくなる
                        """
                    ]
                , column
                    [ textBlock
                        """
                        レビューしやすい
                        """
                    , textBlock
                        """
                        全体の実装に詳しくならなくてもレビューできる
                        """
                    , textBlock
                        """
                        ライブラリー部分はテストケースを確認するだけなので、全体の処理の流れが間違っていないかなどについて集中できる
                        """
                    ]
                , column
                    [ textBlock
                        """
                        ドキュメントや設計がよくなる
                        """
                    , textBlock
                        """
                        「ライブラリーをつくってる」と思うと、ついつい自然にAPI設計が上手になったり、ドキュメントをちゃんと書いちゃうね！
                        """
                    ]
                ]
            ]
    , \_ ->
        titledPage
            """
        既存手法との比較
        """
            [ column
                [ textBlock
                    """
                    ヤブガラシくん「いままでもモジュール切り出したりしてたし、別にふつうじゃね？」
                    """
                    |> toHeader3
                , textBlock
                    """
                    さくらちゃん「そうだよ。でも、名前がつくことって大事じゃない？」
                    """
                , textBlock
                    """
                    さくらちゃん「『ライブラリー』や『フレームワーク』をつくる技術は、アプリケーション開発の技術とは似て非なるもの」
                    """
                , textBlock
                    """
                    さくらちゃん「『ライブラリー』と意識すると、適切な設計や使用ツール・技術はまったく別物になるよ」
                    """
                ]
            , column
                [ textBlock
                    """
                    ヤブガラシくん「結局『オレオレフレームワーク』じゃんwww 情弱乙ww」
                    """
                    |> toHeader3
                , textBlock
                    """
                    さくらちゃん「そうだよ。でも『オレオレフレームワーク』はなんでダメなのか考えたことあるの？」
                    """
                , textBlock
                    """
                    さくらちゃん「ドキュメントがしっかりしてて、脆弱性が入り込みにくくて、設計がしっかりしてて、動作が安定してたら、別にオレオレフレームワークも悪くなくない？」
                    """
                , textBlock
                    """
                    さくらちゃん「Domain Specific Frameworkは既存のフレームワーク上につくるもの。だからそういう最低限が担保されるんだ」
                    """
                ]
            ]
    , \_ ->
        titledPage
            """
        言いたいことを言うだけタイム
        """
            [ unorderedList
                [ textBlock
                    """
                    UX設計が上手です。レビューとかするので会社からお金を出してもらってください。
                    """
                , textBlock
                    """
                    週に15時間以上はたらくと蕁麻疹がでちゃうけど、自由に楽しくさせてくれるならスカウトしてくれてもいいよ
                    """
                , [ Text.link
                    { href = "https://twitter.com/arowM_"
                    , target = "_blank"
                    }
                    """
                    さくらちゃんのツイッター
                    """
                  , Text.fromString
                    """
                    をフォローして、ヤギさんのかわいさに目覚めてください。
                    """
                  ]
                      |> Text.concat
                      |> customTextBlock
                , textBlock
                    """
                    「関数型」でマウントとってくるやつは実際にはまともなアプリ開発できないから騙されないでね
                    """
                , column
                    [ textBlock
                        """
                        さくらちゃんもお手伝いしてる会社がエンジニアさがし中です。
                        """
                    , textBlock
                        """
                        さくらちゃんは、Domain Specific Libraryを使ってシステムを刷新する仕事とかしてます。
                        """
                    , tweet "https://twitter.com/respon_go/status/1436247807808004096"
                    ]
                ]
            ]
    ]



-- Config


type alias Flags =
    { images :
        { sample : String
        , doc : String
        , general : String
        }
    }


port extraJS : () -> Cmd msg


-- Code samples

originalCode : String
originalCode = """
main : Program () Model Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }



-- MODEL


type alias Model =
  { key : Nav.Key
  , url : Url.Url
  }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
  ( Model key url, Cmd.none )



-- UPDATE


type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    LinkClicked urlRequest ->
      case urlRequest of
        Browser.Internal url ->
          ( model, Nav.pushUrl model.key (Url.toString url) )

        Browser.External href ->
          ( model, Nav.load href )

    UrlChanged url ->
      ( { model | url = url }
      , Cmd.none
      )


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
  { title = "URL Interceptor"
  , body =
      [ text "The current URL is: "
      , b [] [ text (Url.toString model.url) ]
      , ul []
          [ viewLink "/home"
          , viewLink "/profile"
          , viewLink "/reviews/the-century-of-the-self"
          , viewLink "/reviews/public-opinion"
          , viewLink "/reviews/shah-of-shahs"
          ]
      ]
  }


viewLink : String -> Html msg
viewLink path =
  li [] [ a [ href path ] [ text path ] ]
"""


dsfCode : String
dsfCode = """
main : Program Flags Model Msg
main =
    Dsf.run extraJS cover pages


cover : Flags -> Page
cover _ =
    coverPage
        [ column
            [ textBlock
                \"""
                2021年10月1日
                \"""
            , customTextBlock
                (Text.fromString
                    \"""
                    第一回関数型プログラミング（仮）の会
                    \"""
                    |> Text.setImportance -1
                )
            ]
            |> setMaxWidthFit
            |> alignRight
        , column
            [ column
                [ customTextBlock
                    (Text.concat
                        [ Text.fromString
                            \"""
                            Domain specific library/framework
                            \"""
                            |> Text.setImportance 2
                        , Text.fromString
                            \"""
                            を用いた
                            \"""
                            |> Text.setImportance 1
                        ]
                    )
                    |> alignHCenter
                , customTextBlock
                    (Text.concat
                        [ Text.fromString
                            \"""
                            実践的
                            \"""
                            |> Text.setImportance 2
                        , Text.fromString
                            \"""
                            開発手法
                            \"""
                            |> Text.setImportance 1
                        ]
                    )
                    |> alignHCenter
                ]
                |> alignVCenter
            ]
            |> toHeader1
            |> setMaxHeightInfinite
        , customTextBlock
            (Text.link
                { href = "https://twitter.com/arowM_"
                , target = "_blank"
                }
                \"""
                ヤギのさくらちゃん
                \"""
            )
            |> alignRight
        ]
"""
