require 'cafe_press/simple_order_api/client'

module CafePress
  module SimpleOrderAPI
    root = File.join(File.dirname(__FILE__), 'simple_order_api', 'wsdl')
    TEST_ENDPOINT = File.join(root, 'sandbox.wsdl').freeze

    LIVE_ENDPOINT = File.join(root, 'production.wsdl').freeze
  end
end

