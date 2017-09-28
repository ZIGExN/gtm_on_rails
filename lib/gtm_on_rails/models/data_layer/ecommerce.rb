# Class to take a roll as javascript's object in dataLayer for Enhanced Ecommerce
module GtmOnRails
  class DataLayer::Ecommerce < DataLayer::Object
    ACTIVITY_TYPES = [:product_impression, :product_click, :product_detail, :add_to_cart, :remove_from_cart, :promotion_impression, :promotion_click, :checkout, :purchase, :refund]

    def initialize(activity_type, **args)
      raise ArgumentError.new("'#{activity_type}' is undefined activity type.") unless activity_type.in?(ACTIVITY_TYPES)

      @data = send(:"generate_#{activity_type}_hash", args).with_indifferent_access
    end

    class << self
      def method_missing(method, *args, &block)
        if method.in?(ACTIVITY_TYPES)
          self.new(method, *args)
        else
          super
        end
      end
    end

    def to_event(event_name = 'ga_event')
      GtmOnRails::DataLayer::Event.new(event_name || @data[:event], @data.except(:event).deep_symbolize_keys)
    end

    private
      def generate_product_impression_hash(args)
        result = {}

        result[:event] = args[:event] if args[:event].present?

        result[:ecommerce]                = {}
        result[:ecommerce][:currencyCode] = args[:currency] || GtmOnRails.config.ecommerce_default_currency

        if args[:impressions].present?
          result[:ecommerce][:impressions] = args[:impressions].map{|impression| impression.is_a?(Hash) ? GtmOnRails::DataLayer::Ecommerce::Impression.new(impression) : impression}
        end

        return result
      end

      def generate_product_click_hash(args)
        result = {}

        result[:event] = args[:event] || 'productClick'

        result[:event_category] = args[:event_category] || 'Enhanced Ecommerce'
        result[:event_action]   = args[:event_action]   || 'Product Click'
        result[:event_label]    = args[:event_label]    || 'Enhanced Ecommerce Product Click'

        result[:ecommerce]                = {}
        result[:ecommerce][:currencyCode] = args[:currency] || GtmOnRails.config.ecommerce_default_currency

        result[:ecommerce][:click] = {}

        if args[:action].present?
          action = args[:action].is_a?(Hash) ? GtmOnRails::DataLayer::Ecommerce::Action.new(args[:action]) : args[:action]
          result[:ecommerce][:click][:actionField] = action
        end

        if args[:products].present?
          result[:ecommerce][:click][:products] = args[:products].map{|product| product.is_a?(Hash) ? GtmOnRails::DataLayer::Ecommerce::Product.new(product) : product}
        end

        return result
      end

      def generate_product_detail_hash(args)
        result = {}

        result[:event] = args[:event] if args[:event].present?

        result[:ecommerce]                = {}
        result[:ecommerce][:currencyCode] = args[:currency] || GtmOnRails.config.ecommerce_default_currency

        result[:ecommerce][:detail] = {}

        if args[:action].present?
          action = args[:action].is_a?(Hash) ? GtmOnRails::DataLayer::Ecommerce::Action.new(args[:action]) : args[:action]
          result[:ecommerce][:detail][:actionField] = action
        end

        if args[:products].present?
          result[:ecommerce][:detail][:products] = args[:products].map{|product| product.is_a?(Hash) ? GtmOnRails::DataLayer::Ecommerce::Product.new(product) : product}
        end

        return result
      end

      def generate_add_to_cart_hash(args)
        result = {}

        result[:event] = args[:event] || 'addToCart'

        result[:event_category] = args[:event_category] || 'Enhanced Ecommerce'
        result[:event_action]   = args[:event_action]   || 'Add to Cart'
        result[:event_label]    = args[:event_label]    || 'Enhanced Ecommerce Add to Cart'

        result[:ecommerce]                = {}
        result[:ecommerce][:currencyCode] = args[:currency] || GtmOnRails.config.ecommerce_default_currency

        result[:ecommerce][:add] = {}
        if args[:products].present?
          result[:ecommerce][:add][:products] = args[:products].map{|product| product.is_a?(Hash) ? GtmOnRails::DataLayer::Ecommerce::Product.new(product) : product}
        end

        return result
      end

      def generate_remove_from_cart_hash(args)
        result = {}

        result[:event] = args[:event] || 'removeFromCart'

        result[:event_category] = args[:event_category] || 'Enhanced Ecommerce'
        result[:event_action]   = args[:event_action]   || 'Remove from Cart'
        result[:event_label]    = args[:event_label]    || 'Enhanced Ecommerce Remove from Cart'

        result[:ecommerce]                = {}
        result[:ecommerce][:currencyCode] = args[:currency] || GtmOnRails.config.ecommerce_default_currency

        result[:ecommerce][:remove] = {}
        if args[:products].present?
          result[:ecommerce][:remove][:products] = args[:products].map{|product| product.is_a?(Hash) ? GtmOnRails::DataLayer::Ecommerce::Product.new(product) : product}
        end

        return result
      end

      def generate_promotion_impression_hash(args)
        result = {}

        result[:event] = args[:event] if args[:event].present?

        result[:ecommerce]                = {}
        result[:ecommerce][:currencyCode] = args[:currency] || GtmOnRails.config.ecommerce_default_currency

        result[:ecommerce][:promoView] = {}

        if args[:promotions].present?
          result[:ecommerce][:promoView][:promotions] = args[:promotions].map{|promotion| promotion.is_a?(Hash) ? GtmOnRails::DataLayer::Ecommerce::Promotion.new(promotion) : promotion}
        end

        return result
      end

      def generate_promotion_click_hash(args)
        result = {}

        result[:event] = args[:event] || 'promotionClick'

        result[:event_category] = args[:event_category] || 'Enhanced Ecommerce'
        result[:event_action]   = args[:event_action]   || 'Promotion Click'
        result[:event_label]    = args[:event_label]    || 'Enhanced Ecommerce Promotion Click'

        result[:ecommerce]                = {}
        result[:ecommerce][:currencyCode] = args[:currency] || GtmOnRails.config.ecommerce_default_currency

        result[:ecommerce][:promoClick] = {}

        if args[:promotions].present?
          result[:ecommerce][:promoClick][:promotions] = args[:promotions].map{|promotion| promotion.is_a?(Hash) ? GtmOnRails::DataLayer::Ecommerce::Promotion.new(promotion) : promotion}
        end

        return result
      end

      def generate_checkout_hash(args)
        result = {}

        result[:event] = args[:event] || 'checkout'

        result[:event_category] = args[:event_category] || 'Enhanced Ecommerce'
        result[:event_action]   = args[:event_action]   || 'Checkout'
        result[:event_label]    = args[:event_label]    || 'Enhanced Ecommerce Checkout'

        result[:ecommerce]                = {}
        result[:ecommerce][:currencyCode] = args[:currency] || GtmOnRails.config.ecommerce_default_currency

        result[:ecommerce][:checkout] = {}

        if args[:action].present?
          action = args[:action].is_a?(Hash) ? GtmOnRails::DataLayer::Ecommerce::Action.new(args[:action]) : args[:action]
          result[:ecommerce][:checkout][:actionField] = action
        end

        if args[:products].present?
          result[:ecommerce][:checkout][:products] = args[:products].map{|product| product.is_a?(Hash) ? GtmOnRails::DataLayer::Ecommerce::Product.new(product) : product}
        end

        return result
      end

      def generate_purchase_hash(args)
        result = {}

        result[:event] = args[:event] if args[:event].present?

        result[:ecommerce]                = {}
        result[:ecommerce][:currencyCode] = args[:currency] || GtmOnRails.config.ecommerce_default_currency

        result[:ecommerce][:purchase] = {}

        action = args[:action] || {}
        action = action.is_a?(Hash) ? GtmOnRails::DataLayer::Ecommerce::Action.new(action) : action
        result[:ecommerce][:purchase][:actionField] = action
        
        if args[:products].present?
          result[:ecommerce][:purchase][:products] = args[:products].map{|product| product.is_a?(Hash) ? GtmOnRails::DataLayer::Ecommerce::Product.new(product) : product}
        end

        return result
      end

      def generate_refund_hash(args)
        result = {}

        result[:event] = args[:event] if args[:event].present?

        result[:ecommerce]                = {}
        result[:ecommerce][:currencyCode] = args[:currency] || GtmOnRails.config.ecommerce_default_currency

        result[:ecommerce][:refund] = {}

        if args[:action].present?
          action = args[:action].is_a?(Hash) ? GtmOnRails::DataLayer::Ecommerce::Action.new(args[:action]) : args[:action]
          result[:ecommerce][:refund][:actionField] = action
        end
        
        if args[:products].present?
          result[:ecommerce][:refund][:products] = args[:products].map{|product| product.is_a?(Hash) ? GtmOnRails::DataLayer::Ecommerce::Product.new(product) : product}
        end

        return result
      end
  end
end
