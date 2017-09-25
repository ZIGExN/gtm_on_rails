# GTMonRails
GTMonRails enables you to integrate Google Tag Manager easy with Rails application.

GTMonRails not only embed Google Tag Manager snippet, but simply operate and send JavaScript's variable 'dataLayer' for GTM in Ruby code.

GTMonRails basically can't be used only this, you have to set up Tag and Trigger on Google Tag Manager.

*Read this in other languages: [日本語](README.ja.md)*

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'gtm_on_rails'
```

And then execute:
```bash
$ bundle
```

And then run initial settings:
```bash
$ rails g gtm_on_rails:install
```

## Configure
Edit the `/config/initializers/gtm_on_rails.rb` file and customize following settings.
#### container_id
Set your Google Tag Manager container ID.
#### data_layer_limit_byte_size
DataLayer is limited by bytesize at once post. If post size is over this bytesize, exception occured.
#### send_controller_and_action_in_data_layer
Settings that send google tag manager controller and action name by dataLayer.
Be careful using this, if you enable this option, controller and action name output in html source code.
#### rescue_when_error_occurred
If somthing error occurred when output tags, subsequent tag's output is stopped and run subsequent processing.
The point is, dataLayer error won't affect displaying website, if you enable this option.
#### ecommerce_default_currency
Default local currency code when use Enhanced Ecommerce.
The local currency must be specified in the ISO 4217 standard.

## BasicUsage
#### Basic
You only push Hash object in `data_layer` variable, can send values what you want by dataLayer.
Usually I’d say you write like the following code in contoller.

```ruby
data_layer.push({
  name: 'name'
})
```
Configure the variable and so on Google Tag Manager when use sended values.

#### `GtmOnRails::DataLayerObject`
```ruby
object = GtmOnRails::DataLayerObject.new({name: 'name'})
data_layer.push(object)
```
You also can use `GtmOnRails::DataLayerObject` object rather than Hash as the above.

```ruby
object = GtmOnRails::DataLayerObject.new({name: 'name'})
object.name
object.name = 'name2'
```
You can access values with `GtmOnRails::DataLayerObject` object as the above.

#### `GtmOnRails::DataLayerEvent`
```ruby
event = GtmOnRails::DataLayerEvent.new('event_name', {name: 'name'})
data_layer.push(event)
```
You can send dataLayer with Google Tag Manager's event name, when write like the above code.

## Enhanced Ecommerce
You can use Enhanced Ecommerce of Google Analytics easily using GTMonRails.
Please look official help about details of Enhanced Ecommerce.
https://developers.google.com/analytics/devguides/collection/analyticsjs/enhanced-ecommerce
https://developers.google.com/tag-manager/enhanced-ecommerce

### Basis
Enhanced Ecommerce has the following 4 types of data object,

- Impression
- Product
- Promotion
- Action

and, the following 10 types of measuring activity object.

- Product Impressions(product_impression)
- Product Clicks(product_click)
- Views of Product Details(product_detail)
- Adding a Product to a Shopping Cart(add_to_cart)
- Removing a Product from a Shopping Cart(remove_from_cart)
- Promotion Impressions(promotion_impression)
- Promotion Clicks(promotion_click)
- Checkout Steps(checkout)
- Purchases(purchase)
- Refunds(refund)

4 types of data object is used in each measuring activity objects.
You enable Enhanced Ecommerce at Google Tag Manager, and 9 tyoes of measuring activity object is sent with 'dataLayer' with 'PageView' or 'Event' of Google Analytics.

### Data Object
Please look official help about details of Enhanced Ecommerce data object.
Only GTMonRails's own configures are described.

#### Impression `GtmOnRails::DataLayer::Ecommerce::Impression`
Official Help : https://developers.google.com/analytics/devguides/collection/analyticsjs/enhanced-ecommerce#impression-data

ex.
```ruby
GtmOnRails::DataLayer::Ecommerce::Impression.new(id: '01', name: 'product_1')
```

Key          | Description
------------ | -------------
id           | In Official Help
name         | In Official Help
list         | In Official Help
brand        | In Official Help
category     | Array of String. Maximum 5.
variant      | In Official Help
position     | In Official Help
price        | In Official Help

#### Product `GtmOnRails::DataLayer::Ecommerce::Product`
Official Help : https://developers.google.com/analytics/devguides/collection/analyticsjs/enhanced-ecommerce#product-data

ex.
```ruby
GtmOnRails::DataLayer::Ecommerce::Product.new(id: '01', name: 'product_1')
```

Key          | Description
------------ | -------------
id           | In Official Help
name         | In Official Help
list         | In Official Help
brand        | In Official Help
category     | Array of String. Maximum 5.
variant      | In Official Help
price        | In Official Help
quantity     | In Official Help
coupon       | In Official Help
position     | In Official Help

#### Promotion `GtmOnRails::DataLayer::Ecommerce::Promotion`
Official Help : https://developers.google.com/analytics/devguides/collection/analyticsjs/enhanced-ecommerce#promotion-data

ex.
```ruby
GtmOnRails::DataLayer::Ecommerce::Promotion.new(id: '01', name: 'product_1')
```

Key          | Description
------------ | -------------
id           | In Official Help
name         | In Official Help
creative     | In Official Help
position     | In Official Help

#### Action `GtmOnRails::DataLayer::Ecommerce::Action`
Official Help : https://developers.google.com/analytics/devguides/collection/analyticsjs/enhanced-ecommerce#action-data

ex.
```ruby
GtmOnRails::DataLayer::Ecommerce::Action.new(list: 'general product list')
```

Key          | Description
------------ | -------------
id           | In Official Help
affiliation  | In Official Help
revenue      | In Official Help
tax          | In Official Help
shipping     | In Official Help
coupon       | In Official Help
list         | In Official Help
step         | In Official Help
option       | In Official Help

### Measuring Activity Object
Please look official help about details of Enhanced Ecommerce data object.
Only GTMonRails's own configures are described.

#### Product Impressions(product_impression)
Official Help : https://developers.google.com/tag-manager/enhanced-ecommerce#product-impressions

You need to send this activity to GoogleAnalytics as 'PageView'.

ex.
```ruby
GtmOnRails::DataLayer::Ecommerce.product_impression(impressions: impressions)
```

Key          | Description
------------ | -------------
currency     | Local currency. The local currency must be specified in the ISO 4217 standard. Default value is configured in `config/initializers/gtm_o_rails.rb`.
impressions  | Array of `GtmOnRails::DataLayer::Ecommerce::Impression` object or Hash.

#### Product Clicks(product_click)
Official Help : https://developers.google.com/tag-manager/enhanced-ecommerce#product-clicks

You need to send this activity to GoogleAnalytics as 'Event'.

ex.
```ruby
GtmOnRails::DataLayer::Ecommerce.product_click(action: action, products: products)
```

Key          | Description
------------ | -------------
currency     | Local currency. The local currency must be specified in the ISO 4217 standard. Default value is configured in `config/initializers/gtm_o_rails.rb`.
action       | `GtmOnRails::DataLayer::Ecommerce::Action` object or Hash.
products     | Array of `GtmOnRails::DataLayer::Ecommerce::Product` object or Hash.

#### Views of Product Details(product_detail)
Official Help : https://developers.google.com/tag-manager/enhanced-ecommerce#details

You need to send this activity to GoogleAnalytics as 'PageView'.

ex.
```ruby
GtmOnRails::DataLayer::Ecommerce.product_detail(action: action, products: products)
```

Key          | Description
------------ | -------------
currency     | Local currency. The local currency must be specified in the ISO 4217 standard. Default value is configured in `config/initializers/gtm_o_rails.rb`.
action       | `GtmOnRails::DataLayer::Ecommerce::Action` object or Hash.
products     | Array of `GtmOnRails::DataLayer::Ecommerce::Product` object or Hash.

#### Adding a Product to a Shopping Cart(add_to_cart)
Official Help : https://developers.google.com/tag-manager/enhanced-ecommerce#add

You need to send this activity to GoogleAnalytics as 'Event'.

ex.
```ruby
GGtmOnRails::DataLayer::Ecommerce.add_to_cart(products: products)
```

Key          | Description
------------ | -------------
currency     | Local currency. The local currency must be specified in the ISO 4217 standard. Default value is configured in `config/initializers/gtm_o_rails.rb`.
products     | Array of `GtmOnRails::DataLayer::Ecommerce::Product` object or Hash.

#### Removing a Product from a Shopping Cart(remove_from_cart)
Official Help : https://developers.google.com/tag-manager/enhanced-ecommerce#add

You need to send this activity to GoogleAnalytics as 'Event'.

ex.
```ruby
GtmOnRails::DataLayer::Ecommerce.remove_from_cart(products: products)
```

Key          | Description
------------ | -------------
currency     | Local currency. The local currency must be specified in the ISO 4217 standard. Default value is configured in `config/initializers/gtm_o_rails.rb`.
products     | Array of `GtmOnRails::DataLayer::Ecommerce::Product` object or Hash.

#### Promotion Impressions(promotion_impression)
Official Help : https://developers.google.com/tag-manager/enhanced-ecommerce#promo-impressions

You need to send this activity to GoogleAnalytics as 'PageView'.

ex.
```ruby
GtmOnRails::DataLayer::Ecommerce.promotion_impression(promotions: promotions)
```

Key          | Description
------------ | -------------
currency     | Local currency. The local currency must be specified in the ISO 4217 standard. Default value is configured in `config/initializers/gtm_o_rails.rb`.
promotions   | Array of `GtmOnRails::DataLayer::Ecommerce::Promotion` object or Hash.

#### Promotion Clicks(promotion_click)
Official Help : https://developers.google.com/tag-manager/enhanced-ecommerce#promo-clicks

You need to send this activity to GoogleAnalytics as 'Event'.

ex.
```ruby
GtmOnRails::DataLayer::Ecommerce.promotion_click(promotions: promotions)
```

Key          | Description
------------ | -------------
currency     | Local currency. The local currency must be specified in the ISO 4217 standard. Default value is configured in `config/initializers/gtm_o_rails.rb`.
promotions   | Array of `GtmOnRails::DataLayer::Ecommerce::Promotion` object or Hash.

#### Checkout Steps(checkout)
Official Help : https://developers.google.com/tag-manager/enhanced-ecommerce#checkoutstep

You need to send this activity to GoogleAnalytics as 'Event'.

ex.
```ruby
action = GtmOnRails::DataLayer::Ecommerce::Action.new({
  step: 1
})
GtmOnRails::DataLayer::Ecommerce.checkout(action: action, products: products)
```

Key          | Description
------------ | -------------
currency     | Local currency. The local currency must be specified in the ISO 4217 standard. Default value is configured in `config/initializers/gtm_o_rails.rb`.
action       | `GtmOnRails::DataLayer::Ecommerce::Action` object or Hash.
products     | Array of `GtmOnRails::DataLayer::Ecommerce::Product` object or Hash.

#### Purchases(purchase)
Official Help : https://developers.google.com/tag-manager/enhanced-ecommerce#purchases

You need to send this activity to GoogleAnalytics as 'PageView'.

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

Key          | Description
------------ | -------------
currency     | Local currency. The local currency must be specified in the ISO 4217 standard. Default value is configured in `config/initializers/gtm_o_rails.rb`.
action       | `GtmOnRails::DataLayer::Ecommerce::Action` object or Hash.
products     | Array of `GtmOnRails::DataLayer::Ecommerce::Product` object or Hash.

#### Refunds(refund)
Official Help : https://developers.google.com/tag-manager/enhanced-ecommerce#refunds

You need to send this activity to GoogleAnalytics as 'PageView'.

ex.
```ruby
action = GtmOnRails::DataLayer::Ecommerce::Action.new({
  id: '01'
})
GtmOnRails::DataLayer::Ecommerce.refund(action: action)
```

Key          | Description
------------ | -------------
currency     | Local currency. The local currency must be specified in the ISO 4217 standard. Default value is configured in `config/initializers/gtm_o_rails.rb`.
action       | `GtmOnRails::DataLayer::Ecommerce::Action` object or Hash.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Author
[ykogure](https://github.com/ykogure)
