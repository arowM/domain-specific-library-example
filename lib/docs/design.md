# 詳細設計書

## 用語と表記

`docs/frontend.md`参照。

## ページ構成

* `/domain-specific-library-example/:pageTitle`

### 状態変数

(なし)

## 画面要素

### _{slideBody}_

#### パラメーター

* _a`slide`_ `{Slide}`

#### 内部状態変数

（なし）

#### 表示要素

* section
    * _a`slide.prev`_ が`null`でない場合のみ
    * attribute: `data-slide="prev"`
    * special style:
        ```
        translate: scaleX(-100);
        ```
    * `Page.view`の結果を表示する
        * arg1: _a`slide.prev`_
* section
    * attribute: `data-slide="current"`
    * `Page.view`の結果を表示する
        * arg1: _a`slide.current`_
* section
    * _a`slide.next`_ が`null`でない場合のみ
    * attribute: `data-slide="next"`
    * special style:
        ```
        translate: scaleX(100);
        ```
    * `Page.view`の結果を表示する
        * arg1: _a`slide.next`_
* button `#back`
    * _a`slide.prev`_ が`null`でない場合のみ
    * label
        ```
        ◀
        ```
    * 画面左端に重ねて半透過表示
* button `#proceed`
    * _a`slide.next`_ が`null`でない場合のみ
    * label
        ```
        ▶
        ```
    * 画面右端に重ねて半透過表示

## ページ表示

### _(loading)_

ページ読み込み中の表示

#### パラメーター

（なし）

#### 表示要素

* メッセージ
    ```
    Loading...
    ```

### _(slide)_

スライド表示

#### パラメーター

* _a`slide`_ `{Slide}`

#### 表示要素

* _{slideBody}_
    * _a`slide`_: _a`slide`_

## 処理の流れ

「Loading」へ

### Loading

#### パラメーター

* _a`url`_ `{Url}`: 現在のページURL
* _a`initSlide`_ `{Slide}`: 初期状態のスライド

#### 処理内容

* _(loading)_ を表示する
* `Route.fromUrl`を実行し、結果を _tmp`route`_ とする
    * arg1: _a`url`_
* *(分岐)* _tmp`route`_ について:
    * `Route.NotFound` の場合:
        * `/domain-specific-library-example/` をpushStateする
        * 遷移が完了したら、「ShowSlide」へ
            * _a`slide`_: _a`initSlide`_
    * `Route.Slide` の場合:
        * `Slide.seek` を実行し、結果を _tmp`slide`_ とする
            * arg1: _tmp`route.title`_
            * arg2: _a`initSlide`_
        * 「ShowSlide」へ
            * _a`slide`_: _tmp`slide`_

### ShowSlide

#### パラメーター

* _a`slide`_ `{Slide}`: スライドの現状

#### 処理内容

* _(slide)_ を表示
    * _a`slide`_: _a`slide`_
* ユーザーが以下のいずれかの操作をするまで待機して、対応した処理を行う
    * `_(slide)_#proceed` をクリックする:
        * _a`slide`_ を`Slide.proceed`で更新した結果を _a`newSlide`_ とする
        * `/domain-specific-library-example/:pageTitle` をpushStateする
            * _p`pageTitle`_: _a`newSlide.current.title`_
        * 遷移が完了したら、「ShowSlide」の最初へ
            * _a`slide`_: _a`newSlide`_
    * キーボードの「→」キーを押す:
        * _a`slide`_ を`Slide.proceed`で更新した結果を _a`newSlide`_ とする
        * `/domain-specific-library-example/:pageTitle` をpushStateする
            * _p`pageTitle`_: _a`newSlide.current.title`_
        * 遷移が完了したら、「ShowSlide」の最初へ
            * _a`slide`_: _a`newSlide`_
    * `_(slide)_#back` をクリックする:
        * _a`slide`_ を`Slide.back`で更新した結果を _a`newSlide`_ とする
        * `/domain-specific-library-example/:pageTitle` をpushStateする
            * _p`pageTitle`_: _a`newSlide.current.title`_
        * 遷移が完了したら、「ShowSlide」の最初へ
            * _a`slide`_: _a`newSlide`_
    * キーボードの「→」キーを押す:
        * _a`slide`_ を`Slide.back`で更新した結果を _a`newSlide`_ とする
        * `/domain-specific-library-example/:pageTitle` をpushStateする
            * _p`pageTitle`_: _a`newSlide.current.title`_
        * 遷移が完了したら、「ShowSlide」の最初へ
            * _a`slide`_: _a`newSlide`_
