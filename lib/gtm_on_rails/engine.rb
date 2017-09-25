require 'gtm_on_rails/config'
require 'gtm_on_rails/controllers/initialize_data_layer'
require 'gtm_on_rails/models/data_layer'
require 'gtm_on_rails/models/data_layer/object'
require 'gtm_on_rails/models/data_layer/event'
require 'gtm_on_rails/models/data_layer/ecommerce'
require 'gtm_on_rails/models/data_layer/ecommerce/action'
require 'gtm_on_rails/models/data_layer/ecommerce/impression'
require 'gtm_on_rails/models/data_layer/ecommerce/product'
require 'gtm_on_rails/models/data_layer/ecommerce/promotion'
require 'gtm_on_rails/tag_helper'

module GtmOnRails
  def self.config
    @config ||= GtmOnRails::Config.new
  end
 
  def self.configure(&block)
    yield(config) if block_given?
  end
  
  class Engine < ::Rails::Engine
    isolate_namespace GtmOnRails

    initializer 'gtm_on_rails.action_controller_extension' do
      ActiveSupport.on_load :action_controller do
        include GtmOnRails::Controllers::InitializeDataLayer
      end
    end
    initializer 'gtm_on_rails.action_view_helpers' do
      ActiveSupport.on_load :action_view do
        include GtmOnRails::TagHelper
      end
    end
  end
end
