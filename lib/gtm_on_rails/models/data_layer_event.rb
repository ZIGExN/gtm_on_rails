# Class to take a roll as javascript's object in dataLayer for google tag manager event
module GtmOnRails
  class DataLayerEvent < GtmOnRails::DataLayerObject
    def initialize(event_name, **args)
      @data = args.merge(event: event_name).with_indifferent_access
    end

    def event_name
      @data[:event]
    end
    def event_name=(arg)
      @data[:event] = arg
    end
  end
end
