# Class to take a roll as javascript's object in dataLayer for promoFieldObjects of Enhanced Ecommerce
module GtmOnRails
  class DataLayer::Ecommerce::Promotion < DataLayer::Object
    def initialize(**args)
      raise ArgumentError.new("required either 'id' or 'name', or both.") if args[:id].blank? && args[:name].blank?

      @data = {}

      @data[:id]       = args[:id]       if args[:id].present?
      @data[:name]     = args[:name]     if args[:name].present?
      @data[:creative] = args[:creative] if args[:creative].present?
      @data[:position] = args[:position] if args[:position].present?
    end

    def to_js
      to_json
    end
  end
end
