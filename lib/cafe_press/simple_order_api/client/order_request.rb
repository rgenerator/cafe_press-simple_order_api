require 'savon'
require 'rexml/document'

module CafePress
  module SimpleOrderAPI
    class Client
      class OrderRequest
        attr_accessor :partner_id, :order, :shipping_address, :line_items, :options

        def initialize(partner_id)
          @partner_id = partner_id
        end

        def create_order(order_hash, options = {})
          @options = options
          client = Savon.client(wsdl: end_point,
                                log_level: :debug,
                                log: true,
                                convert_request_keys_to: :camelcase,
                                pretty_print_xml: true,
                                namespaces: {
                                   'xmlns:caf' => "http://Cafepress.com/"
                                  },
                                )
          puts client.call(:create_order, message: order_hash)
        end

        def cancel_order(order_id)

        end

        def get_status(order_id)

        end

        def end_point
          if @options[:live]
            CafePress::SimpleOrderAPI::LIVE_ENDPOINT
          else
            CafePress::SimpleOrderAPI::TEST_ENDPOINT
          end
        end
      end # end for class OrderRequest
    end # end for module Client
  end # end for module SimpleOrderAPI
end # end for module CafePress