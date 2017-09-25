# Class to take a roll as javascript's object in dataLayer for actionFieldObject of Enhanced Ecommerce
module GtmOnRails
  class DataLayer::Ecommerce::Action < DataLayer::Object
    def initialize(**args)
      @data = {}

      @data[:id]          = args[:id]          if args[:id].present?
      @data[:affiliation] = args[:affiliation] if args[:affiliation].present?
      @data[:revenue]     = args[:revenue]     if args[:revenue].present?
      @data[:tax]         = args[:tax]         if args[:tax].present?
      @data[:shipping]    = args[:shipping]    if args[:shipping].present?
      @data[:coupon]      = args[:coupon]      if args[:coupon].present?
      @data[:list]        = args[:list]        if args[:list].present?
      @data[:step]        = args[:step]        if args[:step].present?
      @data[:option]      = args[:option]      if args[:option].present?
    end

    def to_js
      to_json
    end
  end
end
