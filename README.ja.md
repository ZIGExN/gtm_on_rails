# GTMonRails
GTMonRailsは、RubyOnRailsを使う際にGoogleTagManagerとの連携を簡単に行う事をできるようにするRails用のGemです。

GTMの設置タグを出力するだけでなく、主にJavaScriptを使って行うdataLayer変数の操作や送信をRubyのコード側で行うことができます。

このGemは基本的には単品では機能しません。GoogleTagManager側での設定と合わせて使用して下さい。

*Read this in other languages: [English](README.md)*

## Installation
Gemfileに以下を追記して、追加して下さい。

```ruby
gem 'gtm_on_rails'
```

そしてbundle installを行って下さい。
```bash
$ bundle
```

最後に以下のコマンドを実行して初期設定を行って下さい。
```bash
$ rails g gtm_on_rails:install
```

## Configure
インストールで追加された`/config/initializers/gtm_on_rails.rb`の内容を変更することによって設定を変更して下さい。
#### container_id
GoogleTagManagerのコンテナIDを設定して下さい。
#### data_layer_limit_byte_size
dataLayerには一度にPOSTできる容量に制限があります。GTMonRailsでは、dataLayerに設定された値がここで設定したバイト数を超えた場合、エラーを返します。
#### send_controller_and_action_in_data_layer
この設定を有効にすることによって、dataLayerにRailsのcontroller名とaction名を自動で追加して送信し、GoogleTagManager側で使用することができます。
controller名とaction名はJavaScriptのコードとしてHTMLのソースコード内に出力されるので、その点を留意して下さい。
#### rescue_when_error_occurred
この設定を有効にすることによって、JavaScriptのコードとして出力される際に、dataLayerに設定した値などの問題でエラーが発生場合にエラーを握りつぶします。
つまり、計測周りのエラーによってサイトの表示に影響が出ないようにします。

## BasicUsage
#### 基本
`data_layer`という変数(正確にはhelperが呼び出す変数@gtm_on_rails_data_layer)にdataLayerで送信したい内容をHash型で追加するだけでdataLayerで好きな値を送信できます。
controller内等で以下のように記述する感じになると思います。

```ruby
data_layer.push({
  name: 'name'
})
```

送信したdataLayerの内容は、GoogleTagManager側で変数に設定する等して使用して下さい。

#### `GtmOnRails::DataLayerObject`
```ruby
object = GtmOnRails::DataLayerObject.new({name: 'name'})
data_layer.push(object)
```
Hash形式ではなく、上記のように`GtmOnRails::DataLayerObject`クラスを用いることもできます。

```ruby
object = GtmOnRails::DataLayerObject.new({name: 'name'})
object.name
object.name = 'name2'
```
`GtmOnRails::DataLayerObject`クラスでは、上記のように値にアクセスできます。

#### `GtmOnRails::DataLayerEvent`
```ruby
event = GtmOnRails::DataLayerEvent.new('イベント名', {name: 'name'})
data_layer.push(event)
```
上記のように記述することで、イベント名を設定して送信できます。

## 拡張Eコマース
GoogleAnalyticsの拡張Eコマース機能を本Gemで簡単に設定できます。
拡張Eコマース機能の仕様については下記を参照して下さい。
https://developers.google.com/analytics/devguides/collection/analyticsjs/enhanced-ecommerce
https://developers.google.com/tag-manager/enhanced-ecommerce

### 基本
拡張Eコマースには、
- インプレッション
- 商品
- プロモーション
- アクション

の4種類のデータ型と、

- 商品インプレッション(product_impression)
- 商品クリック(product_click)
- 商品詳細表示(product_detail)
- カート追加(add_to_cart)
- カートから削除(remove_from_cart)
- プロモーションインプレッション(promotion_impression)
- プロモーションクリック(promotion_click)
- 決済(checkout)
- 購入(purchase)
- 払い戻し(refund)
の10種類のアクションが存在します。

4種類のデータは各アクションで使用します。
9種類のアクションは、GoogleAnalyticsの'PageView'か'Event'で拡張Eコマース機能を有効にし、データレイヤーを使用して送信します。

### データ型
基本はGoogle公式のヘルプを参照して下さい。
GTMonRails固有の内容のみ記載します。

#### インプレッション `GtmOnRails::DataLayer::Ecommerce::Impression`
公式仕様：https://developers.google.com/analytics/devguides/collection/analyticsjs/enhanced-ecommerce#impression-data

ex.
```ruby
GtmOnRails::DataLayer::Ecommerce::Impression.new(id: '01', name: '商品1')
```

キー         | 説明
------------ | -------------
id           | ヘルプ参照
name         | ヘルプ参照
list         | ヘルプ参照
brand        | ヘルプ参照
category     | Arrayで指定することが可能。最大で5つまで指定可能。
variant      | ヘルプ参照
position     | ヘルプ参照
price        | ヘルプ参照

#### 商品 `GtmOnRails::DataLayer::Ecommerce::Product`
公式仕様：https://developers.google.com/analytics/devguides/collection/analyticsjs/enhanced-ecommerce#product-data

ex.
```ruby
GtmOnRails::DataLayer::Ecommerce::Product.new(id: '01', name: '商品1')
```

キー         | 説明
------------ | -------------
id           | ヘルプ参照
name         | ヘルプ参照
list         | ヘルプ参照
brand        | ヘルプ参照
category     | Arrayで指定することが可能。最大で5つまで指定可能。
variant      | ヘルプ参照
price        | ヘルプ参照
quantity     | ヘルプ参照
coupon       | ヘルプ参照
position     | ヘルプ参照

#### プロモーション `GtmOnRails::DataLayer::Ecommerce::Promotion`
公式仕様：https://developers.google.com/analytics/devguides/collection/analyticsjs/enhanced-ecommerce#promotion-data

ex.
```ruby
GtmOnRails::DataLayer::Ecommerce::Promotion.new(id: '01', name: '商品1')
```

キー         | 説明
------------ | -------------
id           | ヘルプ参照
name         | ヘルプ参照
creative     | ヘルプ参照
position     | ヘルプ参照

#### アクション `GtmOnRails::DataLayer::Ecommerce::Action`
公式仕様：https://developers.google.com/analytics/devguides/collection/analyticsjs/enhanced-ecommerce#action-data

ex.
```ruby
GtmOnRails::DataLayer::Ecommerce::Action.new(list: '商品一覧')
```

キー         | 説明
------------ | -------------
id           | ヘルプ参照
affiliation  | ヘルプ参照
revenue      | ヘルプ参照
tax          | ヘルプ参照
shipping     | ヘルプ参照
coupon       | ヘルプ参照
list         | ヘルプ参照
step         | ヘルプ参照
option       | ヘルプ参照

### アクション型
基本はGoogle公式のヘルプを参照して下さい。
GTMonRails固有の内容のみ記載します。

#### 商品インプレッション(product_impression)
公式仕様：https://developers.google.com/tag-manager/enhanced-ecommerce#product-impressions

このアクションは「PageView」でGoogleAnalytics側に送信する。

ex.
```ruby
GtmOnRails::DataLayer::Ecommerce.product_impression(impressions: impressions)
```

キー         | 説明
------------ | -------------
currency     | 通貨。「ISO 4217」規格のアルファベットを指定する。未指定の場合は`config/initializers/gtm_o_rails.rb`で指定したデフォルト値が使用される。
impressions  | `GtmOnRails::DataLayer::Ecommerce::Impression`クラスのオブジェクトまたはHashのArrayを指定する。

#### 商品クリック(product_click)
公式仕様：https://developers.google.com/tag-manager/enhanced-ecommerce#product-clicks

このアクションは「Event」でGoogleAnalytics側に送信する。

ex.
```ruby
GtmOnRails::DataLayer::Ecommerce.product_click(action: action, products: products)
```

キー         | 説明
------------ | -------------
currency     | 通貨。「ISO 4217」規格のアルファベットを指定する。未指定の場合は`config/initializers/gtm_o_rails.rb`で指定したデフォルト値が使用される。
action       | `GtmOnRails::DataLayer::Ecommerce::Action`クラスのオブジェクトまたはHashを指定する。
products     | `GtmOnRails::DataLayer::Ecommerce::Product`クラスのオブジェクトまたはHashのArrayを指定する。

#### 商品詳細表示(product_detail)
公式仕様：https://developers.google.com/tag-manager/enhanced-ecommerce#details

このアクションは「PageView」でGoogleAnalytics側に送信する。

ex.
```ruby
GtmOnRails::DataLayer::Ecommerce.product_detail(action: action, products: products)
```

キー         | 説明
------------ | -------------
currency     | 通貨。「ISO 4217」規格のアルファベットを指定する。未指定の場合は`config/initializers/gtm_o_rails.rb`で指定したデフォルト値が使用される。
action       | `GtmOnRails::DataLayer::Ecommerce::Action`クラスのオブジェクトまたはHashを指定する。
products     | `GtmOnRails::DataLayer::Ecommerce::Product`クラスのオブジェクトまたはHashのArrayを指定する。

#### カート追加(add_to_cart)
公式仕様：https://developers.google.com/tag-manager/enhanced-ecommerce#add

このアクションは「Event」でGoogleAnalytics側に送信する。

ex.
```ruby
GGtmOnRails::DataLayer::Ecommerce.add_to_cart(products: products)
```

キー         | 説明
------------ | -------------
currency     | 通貨。「ISO 4217」規格のアルファベットを指定する。未指定の場合は`config/initializers/gtm_o_rails.rb`で指定したデフォルト値が使用される。
products     | `GtmOnRails::DataLayer::Ecommerce::Product`クラスのオブジェクトまたはHashのArrayを指定する。

#### カートから削除(remove_from_cart)
公式仕様：https://developers.google.com/tag-manager/enhanced-ecommerce#add

このアクションは「Event」でGoogleAnalytics側に送信する。

ex.
```ruby
GtmOnRails::DataLayer::Ecommerce.remove_from_cart(products: products)
```

キー         | 説明
------------ | -------------
currency     | 通貨。「ISO 4217」規格のアルファベットを指定する。未指定の場合は`config/initializers/gtm_o_rails.rb`で指定したデフォルト値が使用される。
products     | `GtmOnRails::DataLayer::Ecommerce::Product`クラスのオブジェクトまたはHashのArrayを指定する。

#### プロモーションインプレッション(promotion_impression)
公式仕様：https://developers.google.com/tag-manager/enhanced-ecommerce#promo-impressions

このアクションは「PageView」でGoogleAnalytics側に送信する。

ex.
```ruby
GtmOnRails::DataLayer::Ecommerce.promotion_impression(promotions: promotions)
```

キー         | 説明
------------ | -------------
currency     | 通貨。「ISO 4217」規格のアルファベットを指定する。未指定の場合は`config/initializers/gtm_o_rails.rb`で指定したデフォルト値が使用される。
promotions   | `GtmOnRails::DataLayer::Ecommerce::Promotion`クラスのオブジェクトまたはHashのArrayを指定する。

#### プロモーションクリック(promotion_click)
公式仕様：https://developers.google.com/tag-manager/enhanced-ecommerce#promo-clicks

このアクションは「Event」でGoogleAnalytics側に送信する。

ex.
```ruby
GtmOnRails::DataLayer::Ecommerce.promotion_click(promotions: promotions)
```

キー         | 説明
------------ | -------------
currency     | 通貨。「ISO 4217」規格のアルファベットを指定する。未指定の場合は`config/initializers/gtm_o_rails.rb`で指定したデフォルト値が使用される。
promotions   | `GtmOnRails::DataLayer::Ecommerce::Promotion`クラスのオブジェクトまたはHashのArrayを指定する。

#### 決済(checkout)
公式仕様：https://developers.google.com/tag-manager/enhanced-ecommerce#checkoutstep

このアクションは「Event」でGoogleAnalytics側に送信する。

ex.
```ruby
action = GtmOnRails::DataLayer::Ecommerce::Action.new({
  step: 1
})
GtmOnRails::DataLayer::Ecommerce.checkout(action: action, products: products)
```

キー         | 説明
------------ | -------------
currency     | 通貨。「ISO 4217」規格のアルファベットを指定する。未指定の場合は`config/initializers/gtm_o_rails.rb`で指定したデフォルト値が使用される。
action       | `GtmOnRails::DataLayer::Ecommerce::Action`クラスのオブジェクトまたはHashを指定する。
products     | `GtmOnRails::DataLayer::Ecommerce::Product`クラスのオブジェクトまたはHashのArrayを指定する。

#### 購入(purchase)
公式仕様：https://developers.google.com/tag-manager/enhanced-ecommerce#purchases

このアクションは「PageView」でGoogleAnalytics側に送信する。

ex.
```ruby
action = GtmOnRails::DataLayer::Ecommerce::Action.new({
  id:          '01',
  affiliation: 'Online Store',
  revenue:     '35.43',
  tax:         '4.90',
  shipping:    '5.99',
  coupon:      'SUMMER_SALE'
})
GtmOnRails::DataLayer::Ecommerce.purchase(action: action, products: products)
```

キー         | 説明
------------ | -------------
currency     | 通貨。「ISO 4217」規格のアルファベットを指定する。未指定の場合は`config/initializers/gtm_o_rails.rb`で指定したデフォルト値が使用される。
action       | `GtmOnRails::DataLayer::Ecommerce::Action`クラスのオブジェクトまたはHashを指定する。
products     | `GtmOnRails::DataLayer::Ecommerce::Product`クラスのオブジェクトまたはHashのArrayを指定する。

#### 払い戻し(refund)
公式仕様：https://developers.google.com/tag-manager/enhanced-ecommerce#refunds

このアクションは「PageView」でGoogleAnalytics側に送信する。

ex.
```ruby
action = GtmOnRails::DataLayer::Ecommerce::Action.new({
  id: '01'
})
GtmOnRails::DataLayer::Ecommerce.refund(action: action)
```

キー         | 説明
------------ | -------------
currency     | 通貨。「ISO 4217」規格のアルファベットを指定する。未指定の場合は`config/initializers/gtm_o_rails.rb`で指定したデフォルト値が使用される。
action       | `GtmOnRails::DataLayer::Ecommerce::Action`クラスのオブジェクトまたはHashを指定する。


## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Author
[ykogure](https://github.com/ykogure)
