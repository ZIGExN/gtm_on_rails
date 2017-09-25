# Class to take a roll as javascript's object in dataLayer for productFieldObjects of Enhanced Ecommerce
module GtmOnRails
  class DataLayer::Ecommerce::Product < DataLayer::Object
    def initialize(**args)
      raise ArgumentError.new("required either 'id' or 'name', or both.") if args[:id].blank? && args[:name].blank?

      @data = {}

      @data[:id]       = args[:id]       if args[:id].present?
      @data[:name]     = args[:name]     if args[:name].present?
      @data[:brand]    = args[:brand]    if args[:brand].present?
      @data[:variant]  = args[:variant]  if args[:variant].present?
      @data[:price]    = args[:price]    if args[:price].present?
      @data[:quantity] = args[:quantity] if args[:quantity].present?
      @data[:coupon]   = args[:coupon]   if args[:coupon].present?
      @data[:position] = args[:position] if args[:position].present?
      if args[:category].present?
        if args[:category].is_a?(Array)
          raise ArgumentError.new("'category' can be up to 5.") if args[:category].count > 5
          @data[:category] = args[:category].join('/')
        else
          @data[:category] = args[:category]
        end
      end

      # Custom Dimensions
      dimension_keys = args.keys.map(&:to_s).select{|key| key.match(/^dimension[0-9]+/)}.map(&:to_sym)
      dimension_keys.each do |dimension_key|
        @data[dimension_key] = args[dimension_key]
      end

      # Custom Metrics
      metric_keys = args.keys.map(&:to_s).select{|key| key.match(/^metric[0-9]+/)}.map(&:to_sym)
      metric_keys.each do |metric_key|
        @data[metric_key] = args[metric_key]
      end
    end

    def to_js
      to_json
    end
  end
end
