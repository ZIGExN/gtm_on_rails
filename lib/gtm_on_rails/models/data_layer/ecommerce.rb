# Class to take a roll as javascript's object in dataLayer for Enhanced Ecommerce
module GtmOnRails
  class DataLayer::Ecommerce < DataLayer::Object
    ACTIVITY_TYPES = [:product_impression, :product_click, :product_detail, :add_to_cart, :remove_from_cart, :promotion_impression, :promotion_click, :checkout, :purchase, :refund]

    def initialize(activity_type, *args)
      raise ArgumentError.new("'#{activity_type}' is undefined activity type.") unless activity_type.in?(ACTIVITY_TYPES)

      sanitize = true
      if args.first.keys.count == 1 && args.first.keys.first.to_sym == :sanitize
        sanitize = args.shift[:sanitize]
      end

      @data = send(:"generate_#{activity_type}_hash", *[sanitize, args.first]).with_indifferent_access
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

      def generate_product_impression_hash(sanitize, args)
        result = get_default_data(args)

        result[:event] = args.delete(:event) if args[:event].present?

        result[:ecommerce][:impressions] = get_impression(args) if args[:impressions].present?

        result.merge!(args) unless sanitize

        return result
      end

      def generate_product_click_hash(sanitize, args)
        result = get_default_data(args)

        result[:event] = args.delete(:event) || 'productClick'

        result[:event_category] = args.delete(:event_category) || 'Enhanced Ecommerce'
        result[:event_action]   = args.delete(:event_action)   || 'Product Click'
        result[:event_label]    = args.delete(:event_label)    || 'Enhanced Ecommerce Product Click'

        result[:ecommerce][:click]               = {}
        result[:ecommerce][:click][:actionField] = get_action(args)   if args[:action].present?
        result[:ecommerce][:click][:products]    = get_products(args) if args[:products].present?

        result.merge!(args) unless sanitize

        return result
      end

      def generate_product_detail_hash(sanitize, args)
        result = get_default_data(args)

        result[:event] = args.delete(:event) if args[:event].present?

        result[:ecommerce][:detail]               = {}
        result[:ecommerce][:detail][:actionField] = get_action(args)   if args[:action].present?
        result[:ecommerce][:detail][:products]    = get_products(args) if args[:products].present?

        result.merge!(args) unless sanitize

        return result
      end

      def generate_add_to_cart_hash(sanitize, args)
        result = get_default_data(args)

        result[:event] = args.delete(:event) || 'addToCart'

        result[:event_category] = args.delete(:event_category) || 'Enhanced Ecommerce'
        result[:event_action]   = args.delete(:event_action)   || 'Add to Cart'
        result[:event_label]    = args.delete(:event_label)    || 'Enhanced Ecommerce Add to Cart'

        result[:ecommerce][:add]            = {}
        result[:ecommerce][:add][:products] = get_products(args) if args[:products].present?

        result.merge!(args) unless sanitize

        return result
      end

      def generate_remove_from_cart_hash(sanitize, args)
        result = get_default_data(args)

        result[:event] = args.delete(:event) || 'removeFromCart'

        result[:event_category] = args.delete(:event_category) || 'Enhanced Ecommerce'
        result[:event_action]   = args.delete(:event_action)   || 'Remove from Cart'
        result[:event_label]    = args.delete(:event_label)    || 'Enhanced Ecommerce Remove from Cart'

        result[:ecommerce][:remove]            = {}
        result[:ecommerce][:remove][:products] = get_products(args) if args[:products].present?

        result.merge!(args) unless sanitize

        return result
      end

      def generate_promotion_impression_hash(sanitize, args)
        result = get_default_data(args)

        result[:event] = args.delete(:event) if args[:event].present?

        result[:ecommerce][:promoView]              = {}
        result[:ecommerce][:promoView][:promotions] = get_promotion(args) if args[:promotions].present?

        result.merge!(args) unless sanitize

        return result
      end

      def generate_promotion_click_hash(sanitize, args)
        result = get_default_data(args)

        result[:event] = args.delete(:event) || 'promotionClick'

        result[:event_category] = args.delete(:event_category) || 'Enhanced Ecommerce'
        result[:event_action]   = args.delete(:event_action)   || 'Promotion Click'
        result[:event_label]    = args.delete(:event_label)    || 'Enhanced Ecommerce Promotion Click'

        result[:ecommerce][:promoClick]              = {}
        result[:ecommerce][:promoClick][:promotions] = get_promotion(args) if args[:promotions].present?

        result.merge!(args) unless sanitize

        return result
      end

      def generate_checkout_hash(sanitize, args)
        result = get_default_data(args)

        result[:event] = args.delete(:event) || 'checkout'

        result[:event_category] = args.delete(:event_category) || 'Enhanced Ecommerce'
        result[:event_action]   = args.delete(:event_action)   || 'Checkout'
        result[:event_label]    = args.delete(:event_label)    || 'Enhanced Ecommerce Checkout'

        result[:ecommerce][:checkout]               = {}
        result[:ecommerce][:checkout][:actionField] = get_action(args)   if args[:action].present?
        result[:ecommerce][:checkout][:products]    = get_products(args) if args[:products].present?

        result.merge!(args) unless sanitize

        return result
      end

      def generate_purchase_hash(sanitize, args)
        result = get_default_data(args)

        result[:event] = args.delete(:event) if args[:event].present?

        result[:ecommerce][:purchase]               = {}
        result[:ecommerce][:purchase][:actionField] = get_action(args)   if args[:action].present?
        result[:ecommerce][:purchase][:products]    = get_products(args) if args[:products].present?

        result.merge!(args) unless sanitize

        return result
      end

      def generate_refund_hash(sanitize, args)
        result = get_default_data(args)

        result[:event] = args.delete(:event) if args[:event].present?

        result[:ecommerce][:refund]               = {}
        result[:ecommerce][:refund][:actionField] = get_action(args)   if args[:action].present?
        result[:ecommerce][:refund][:products]    = get_products(args) if args[:products].present?

        result.merge!(args) unless sanitize

        return result
      end


      def get_default_data(args)
        hash = {}
        hash[:ecommerce]                = {}
        hash[:ecommerce][:currencyCode] = get_currency(args)
        hash
      end

      def get_currency(args)
        args.delete(:currency) || GtmOnRails.config.ecommerce_default_currency
      end

      def get_impression(args)
        args.delete(:impressions).map{|impression| impression.is_a?(Hash) ? GtmOnRails::DataLayer::Ecommerce::Impression.new(impression) : impression}
      end

      def get_promotion(args)
        args.delete(:promotions).map{|promotion| promotion.is_a?(Hash) ? GtmOnRails::DataLayer::Ecommerce::Promotion.new(promotion) : promotion}
      end

      def get_products(args)
        args.delete(:products).map{|product| product.is_a?(Hash) ? GtmOnRails::DataLayer::Ecommerce::Product.new(product) : product}
      end

      def get_action(args)
        args[:action].is_a?(Hash) ? GtmOnRails::DataLayer::Ecommerce::Action.new(args.delete(:action)) : args.delete(:action)
      end
  end
end
