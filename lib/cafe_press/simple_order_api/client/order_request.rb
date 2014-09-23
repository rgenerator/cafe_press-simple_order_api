module CafePress
  module SimpleOrderAPI
    module Client
      class OrderRequest
        TEST_ENDPOINT = 'http://50.16.203.38/SimpleCPOrderAPIWebServiceSandbox/SimpleCPOrderWS.asmx'
        LIVE_ENDPOINT = 'https://api.cpdcprod.com/SimpleCPOrderWebService/SimpleCPOrderWS.asmx'

        def create_order(order_id, shipping_address, line_items, options = {})

        end
      end
    end
  end
end