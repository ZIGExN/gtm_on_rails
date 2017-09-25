# Class to take a roll as dataLayer of javascript's variable
module GtmOnRails
  class DataLayer
    include ActionView::Helpers::TagHelper

    attr_reader :objects

    def initialize(*args)
      options  = args.extract_options!
      @objects = args # @objects are instances of GTM::DataLayerObject
    end

    def push(objects)
      objects = [objects].flatten
      objects.each do |object|
        case object
        when Hash
          @objects << GtmOnRails::DataLayer::Object.new(object)
        when GtmOnRails::DataLayer::Object
          @objects << object
        end
      end
    end

    def to_js
      js_codes = []

      js_codes << "var dataLayer = dataLayer || [];"
      @objects.each do |data_layer_object|
        # dataLayer size limit exception
        size = data_layer_object.to_json.bytesize
        if size > GtmOnRails.config.data_layer_limit_byte_size
          logger.warn("DataLayer bytesize is over limit #{GtmOnRails.config.data_layer_limit_byte_size} bytes. Size is #{size} bytes.")
          next
        end

        js_codes << data_layer_object.to_js
      end

      return js_codes.join.html_safe
    end

    def print_on_html
      content_tag(:script, self.to_js)
    end
  end
end
