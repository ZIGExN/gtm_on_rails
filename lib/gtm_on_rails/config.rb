module GtmOnRails
  class Config
    # Variables detail is writen in lib/generators/templates/gtm_on_rails.rb.
    attr_accessor :container_id
    attr_accessor :data_layer_limit_byte_size
    attr_accessor :send_controller_and_action_in_data_layer
    attr_accessor :rescue_when_error_occurred
    attr_accessor :ecommerce_default_currency
  end
end
