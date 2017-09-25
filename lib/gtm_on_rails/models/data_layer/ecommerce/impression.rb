# Class to take a roll as javascript's object in dataLayer for impressionFieldObjects of Enhanced Ecommerce
module GtmOnRails
  class DataLayer::Ecommerce::Impression < DataLayer::Object
    def initialize(**args)
      raise ArgumentError.new("required either 'id' or 'name', or both.") if args[:id].blank? && args[:name].blank?

      @data = {}

      @data[:id]       = args[:id]       if args[:id].present?
      @data[:name]     = args[:name]     if args[:name].present?
      @data[:list]     = args[:list]     if args[:list].present?
      @data[:brand]    = args[:brand]    if args[:brand].present?
      @data[:variant]  = args[:variant]  if args[:variant].present?
      @data[:position] = args[:position] if args[:position].present?
      @data[:price]    = args[:price]    if args[:price].present?
      if args[:category].present?
        if args[:category].is_a?(Array)
          @data[:category] = args[:category].join('/')
        else
          @data[:category] = args[:category]
        end
      end
    end

    def to_js
      to_json
    end
  end
end
