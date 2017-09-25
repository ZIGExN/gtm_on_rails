# Class to take a roll as javascript's object in dataLayer
module GtmOnRails
  class DataLayer::Object
    attr_accessor :data

    def initialize(**args)
      @data = args.with_indifferent_access
    end

    def add(**hash)
      @data.merge!(hash)
    end

    def as_json(options = nil)
      @data.as_json(options)
    end

    def to_json(options = nil)
      hash = as_json(options)
      
      hash.to_json
    end

    def to_js(options = nil)
      "dataLayer.push(#{self.to_json(options)});".html_safe
    end

    def method_missing(method, *args, &block)
      if method.to_s.end_with?('=')
        key     = method.to_s.chop.to_sym
        _method = :[]=
        _args   = [key] + args
      else
        key     = method
        _method = :[]
        _args   = [key]
      end

      if @data.has_key?(key)
        @data.send(_method, *_args)
      else
        super
      end
    end
  end
end
